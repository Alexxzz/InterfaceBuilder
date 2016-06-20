#import <objc/runtime.h>

#import "InterfaceBuilder.h"


#pragma mark - Interface builder

@interface InterfaceBuilder () <InterfaceParserDelegate>
@property (nonatomic, strong) id <InterfaceParserProtocol> parser;
@property (nonatomic, strong) UIView *rootView;
@property (nonatomic, strong) NSMutableArray *stack;
@property (nonatomic, strong) NSNumberFormatter *formatter;
@property (nonatomic, strong) NSSet *plugins;
@end

@implementation InterfaceBuilder

- (instancetype)initWithInterfaceParser:(id <InterfaceParserProtocol>)parser
{
    self = [super init];
    if (self) {
        _parser = parser;
        _parser.delegate = self;
    }

    return self;
}

- (UIView *)build
{
    self.rootView = nil;
    self.stack = [[NSMutableArray alloc] init];

    [self.parser parse];

    if (self.parser.error != nil) {
        return nil;
    }

    return self.rootView;
}

#pragma mark - View creation

- (UIView *)createViewFromClassString:(NSString *)classString
{
    Class viewClass = NSClassFromString(classString);
    UIView *view = (UIView *) [[viewClass alloc] init];

    if ([view isKindOfClass:[UIView class]] == NO) {
        view = nil;
    }

    return view;
}

- (void)setAttributes:(NSDictionary<NSString *, NSString *> *)attributes toView:(UIView *)view
{
    for (NSString *attr in [attributes allKeys]) {
        NSString *stringValue = attributes[attr];
        id value = [self convertAttribute:attr withValue:stringValue forView:view];

        @try {
            [view setValue:value forKeyPath:attr];
        } @catch (NSException *e) {
            NSLog(@"setAttributes Exception: %@", e);
        }
    }
}

- (id)convertAttribute:(NSString *)attribute withValue:(NSString *)stringValue forView:(UIView *)view
{
    id value = stringValue;

    Class propertyClass = [self classOfPropertyNamed:attribute inClass:[view class]];
    if ([propertyClass isEqual:[NSString class]] == NO) {
        NSNumber *numValue = [self.formatter numberFromString:stringValue];
        if (numValue != nil) {
            value = numValue;
        }
    }

    return value;
}

- (Class)classOfPropertyNamed:(NSString *)propertyName inClass:(Class)class
{
    Class propertyClass = nil;
    objc_property_t property = class_getProperty(class, [propertyName UTF8String]);
    if (property == nil) {
        return nil;
    }
    NSString *propertyAttributes = [NSString stringWithCString:property_getAttributes(property) encoding:NSUTF8StringEncoding];
    NSArray *splitPropertyAttributes = [propertyAttributes componentsSeparatedByString:@","];
    if (splitPropertyAttributes.count > 0) {
        NSString *encodeType = splitPropertyAttributes[0];
        NSArray *splitEncodeType = [encodeType componentsSeparatedByString:@"\""];
        if (splitEncodeType.count > 1) {
            NSString *className = splitEncodeType[1];
            propertyClass = NSClassFromString(className);
        }
    }
    return propertyClass;
}

- (void)addView:(UIView *)view
{
    if (self.rootView == nil) {
        self.rootView = view;
    } else {
        UIView *topView = [self.stack lastObject];
        [topView addSubview:view];
    }

    [self.stack addObject:view];
}

#pragma mark - Formatter

- (NSNumberFormatter *)formatter
{
    if (_formatter == nil) {
        _formatter = [[NSNumberFormatter alloc] init];
        _formatter.numberStyle = NSNumberFormatterDecimalStyle;
    }
    return _formatter;
}

#pragma mark - InterfaceParserDelegate

- (void)interfaceParser:(id <InterfaceParserProtocol>)parser didStartViewWithClassString:(NSString *)classString attributes:(NSDictionary *)attributes
{
    UIView *view = [self createViewFromClassString:classString];
    if (view == nil) {
        [parser abortParsing];
        return;
    }

    [self setAttributes:attributes toView:view];
    [self addView:view];

    [self notifyPluginsWithView:view viewClassName:classString attributes:attributes];
}

- (void)interfaceParser:(id <InterfaceParserProtocol>)parser didEndViewWithClassString:(NSString *)classString
{
    [self.stack removeLastObject];
}

#pragma mark - Plugins
- (void)addPlugin:(id <InterfaceBuilderPluginProtocol>)plugin
{
    if (plugin == nil) {
        return;
    }

    if (self.plugins == nil) {
        self.plugins = [[NSSet alloc] init];
    }

    self.plugins = [self.plugins setByAddingObject:plugin];
}

- (BOOL)containsPlugin:(id <InterfaceBuilderPluginProtocol>)plugin
{
    return [self.plugins containsObject:plugin];
}

- (void)removePlugin:(id <InterfaceBuilderPluginProtocol>)plugin
{
    self.plugins = [self.plugins objectsPassingTest:^BOOL(id obj, BOOL *stop) {
        return ([plugin isEqual:obj] == NO);
    }];
}

- (void)notifyPluginsWithView:(UIView *)view viewClassName:(NSString *)name attributes:(NSDictionary *)attributes
{
    for (id <InterfaceBuilderPluginProtocol> plugin in self.plugins) {
        [plugin interfaceBuilder:self
                    didBuildView:view
                     ofClassName:name
                  withAttributes:attributes];
    }
}

@end
