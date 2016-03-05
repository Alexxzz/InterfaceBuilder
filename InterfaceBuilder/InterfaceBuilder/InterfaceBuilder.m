#import <objc/runtime.h>
#import "InterfaceBuilder.h"

#pragma mark - Node

//@interface Node : NSObject
//@property (nonatomic, copy) NSString *classString;
//@property (nonatomic, copy) NSDictionary *attributes;
//@property (nonatomic, strong) NSArray<Node *> *children;
//
//- (instancetype)initWithClassString:(NSString *)classString;
//
//- (NSString *)description;
//
//+ (instancetype)nodeWithClassString:(NSString *)classString;
//@end
//
//@implementation Node
//- (instancetype)initWithClassString:(NSString *)classString
//{
//    self = [super init];
//    if (self) {
//        self.classString = classString;
//    }
//    return self;
//}
//
//+ (instancetype)nodeWithClassString:(NSString *)classString
//{
//    return [[self alloc] initWithClassString:classString];
//}
//
//- (NSString *)description
//{
//    NSMutableString *description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
//    [description appendFormat:@"self.classString=%@", self.classString];
//    [description appendFormat:@", self.children=%@", self.children];
//    [description appendString:@">"];
//    return description;
//}
//@end

#pragma mark - Interface builder

@interface InterfaceBuilder () <InterfaceParserDelegate>
@property (nonatomic, strong) id<InterfaceParserProtocol> parser;
@property (nonatomic, strong) UIView *rootView;
@property (nonatomic, strong) NSMutableArray *stack;
@end

@implementation InterfaceBuilder

- (instancetype)initWithInterfaceParser:(id<InterfaceParserProtocol>)parser
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
- (UIView *)getViewFromClassString:(NSString *)classString
{
    Class viewClass = NSClassFromString(classString);
    UIView *view = (UIView *) [[viewClass alloc] init];

    if ([view isKindOfClass:[UIView class]] == NO) {
        view = nil;
    }

    return view;
}

#pragma mark - InterfaceParserDelegate
- (void)interfaceParser:(id <InterfaceParserProtocol>)parser didStartViewWithClassString:(NSString *)classString
{
    UIView *view = [self getViewFromClassString:classString];
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
