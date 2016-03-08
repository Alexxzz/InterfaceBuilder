#import <objc/runtime.h>

#import "InterfaceBuilder.h"


#pragma mark - Interface builder

@interface InterfaceBuilder () <InterfaceParserDelegate>
@property (nonatomic, strong) id <InterfaceParserProtocol> parser;
@property (nonatomic, strong) UIView *rootView;
@property (nonatomic, strong) NSMutableArray *stack;
@property (nonatomic, strong) NSNumberFormatter *formatter;
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
        id value = [self getObject:stringValue];
        [view setValue:value forKeyPath:attr];
    }
}

- (id)getObject:(NSString *)stringValue
{
    id value = stringValue;
    NSNumber *numValue = [self.formatter numberFromString:stringValue];
    if (numValue != nil) {
        value = numValue;
    }
    return value;
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
    [self setAttributes:attributes toView:view];
    if (view == nil) {
        [parser abortParsing];
        return;
    }

    if (self.rootView == nil) {
        self.rootView = view;
    } else {
        UIView *topView = [self.stack lastObject];
        [topView addSubview:view];
    }

    [self.stack addObject:view];
}

- (void)interfaceParser:(id <InterfaceParserProtocol>)parser didEndViewWithClassString:(NSString *)classString
{
    [self.stack removeLastObject];
}

@end
