#import <objc/runtime.h>

#import "InterfaceBuilder.h"


#pragma mark - Interface builder

@interface InterfaceBuilder () <InterfaceParserDelegate>
@property (nonatomic, strong) id <InterfaceParserProtocol> parser;
@property (nonatomic, strong) UIView *rootView;
@property (nonatomic, strong) NSMutableArray *stack;
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

static inline void getPropertyType(Class class, NSString *methodName) {
    Method method = class_getInstanceMethod(class, NSSelectorFromString(methodName));
    const char *type = method_copyReturnType(method);

    printf("%s : %s\n", methodName.UTF8String, type);

    free((void *) type);
}

- (void)setAttributes:(NSDictionary<NSString *, NSString *> *)attributes toView:(UIView *)view
{
    for (NSString *attr in [attributes allKeys]) {
        NSString *value = attributes[attr];
        NSNumber *numValue = @([value integerValue]);
        [view setValue:numValue forKey:attr];
    }
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
