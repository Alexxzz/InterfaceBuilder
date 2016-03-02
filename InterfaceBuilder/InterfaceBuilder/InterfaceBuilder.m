#import <objc/runtime.h>
#import "InterfaceBuilder.h"

#pragma mark - Node

//@interface Node : NSObject
//@property (nonatomic, copy) NSString *classString;
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

@interface InterfaceBuilder () <NSXMLParserDelegate>
@property (nonatomic, strong) UIView *rootView;
@property (nonatomic, strong) NSMutableArray *stack;
@end

@implementation InterfaceBuilder

- (UIView *)buildFromString:(NSString *)string
{
    self.stack = [[NSMutableArray alloc] init];

    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
    parser.delegate = self;
    [parser parse];

    return self.rootView;
}

#pragma mark - NSXMLParserDelegate
- (void)parser:(NSXMLParser *)parser
        didStartElement:(NSString *)elementName
        namespaceURI:(nullable NSString *)namespaceURI
        qualifiedName:(nullable NSString *)qName
        attributes:(NSDictionary<NSString *, NSString *> *)attributeDict
{
    UIView *view = [self getViewFromClassString:elementName];
    if (view == nil) {
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

- (void)parser:(NSXMLParser *)parser
 didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
{
    [self.stack removeLastObject];
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

@end
