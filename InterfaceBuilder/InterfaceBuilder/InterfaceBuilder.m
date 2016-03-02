#import <objc/runtime.h>
#import "InterfaceBuilder.h"


@interface InterfaceBuilder () <NSXMLParserDelegate>
@property(nonatomic, strong) UIView *rootView;
@end

@implementation InterfaceBuilder

- (UIView *)buildFromString:(NSString *)string
{
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
    parser.delegate = self;
    [parser parse];

    return self.rootView;
}

#pragma mark
- (void)parser:(NSXMLParser *)parser
        didStartElement:(NSString *)elementName
        namespaceURI:(nullable NSString *)namespaceURI
        qualifiedName:(nullable NSString *)qName
        attributes:(NSDictionary<NSString *, NSString *> *)attributeDict
{
    Class viewClass = NSClassFromString(elementName);
    UIView *view = (UIView *) [[viewClass alloc] init];

    if (self.rootView == nil) {
        self.rootView = view;
    } else {
        [self.rootView addSubview:view];
    }
}


@end