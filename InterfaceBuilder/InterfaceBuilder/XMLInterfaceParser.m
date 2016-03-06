#import "XMLInterfaceParser.h"


@interface XMLInterfaceParser() <NSXMLParserDelegate>
@property (nonatomic, strong) NSData *data;
@property (nonatomic, strong) NSXMLParser *parser;
@property (nonatomic, strong) NSError *error;
@end

@implementation XMLInterfaceParser

- (instancetype)initWithData:(NSData *)data
{
    self = [super init];
    if (self) {
        _data = data;
    }
    return self;
}

- (instancetype)initWithString:(NSString *)string
{
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    return [self initWithData:data];
}

- (void)parse
{
    self.parser = [[NSXMLParser alloc] initWithData:self.data];
    self.parser.delegate = self;
    [self.parser parse];

    self.error = self.parser.parserError;
}

- (void)abortParsing
{
    [self.parser abortParsing];
}

#pragma mark - NSXMLParserDelegate
- (void)parser:(NSXMLParser *)parser
        didStartElement:(NSString *)elementName
        namespaceURI:(nullable NSString *)namespaceURI
        qualifiedName:(nullable NSString *)qName
        attributes:(NSDictionary<NSString *, NSString *> *)attributeDict
{
    [self.delegate interfaceParser:self didStartViewWithClassString:elementName attributes:attributeDict];
}

- (void)parser:(NSXMLParser *)parser
 didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
{
    [self.delegate interfaceParser:self didEndViewWithClassString:elementName];
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    [parser abortParsing];
}

@end
