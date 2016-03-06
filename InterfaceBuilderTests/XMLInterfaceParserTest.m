#import <XCTest/XCTest.h>

#import "XMLInterfaceParser.h"

#import <OCHamcrest/OCHamcrest.h>
#import <OCMockito/OCMockito.h>


@interface XMLInterfaceParserTest : XCTestCase
@end

@implementation XMLInterfaceParserTest
{
    id<InterfaceParserDelegate> mockDelegate;
}

- (void)setUp
{
    mockDelegate = mockProtocol(@protocol(InterfaceParserDelegate));
}

- (void)tearDown
{
    stopMocking(mockDelegate);
}

- (void)testInitWithString
{
    NSString *stringXml = @"<UIView />";

    XMLInterfaceParser *parser = [[XMLInterfaceParser alloc] initWithString:stringXml];
    parser.delegate = mockDelegate;
    [parser parse];

    [verify(mockDelegate) interfaceParser:anything() didStartViewWithClassString:@"UIView" attributes:anything()];
}

- (void)testInitWithData
{
    NSData *data = [@"<UILabel />" dataUsingEncoding:NSUTF8StringEncoding];

    XMLInterfaceParser *parser = [[XMLInterfaceParser alloc] initWithData:data];
    parser.delegate = mockDelegate;
    [parser parse];

    [verify(mockDelegate) interfaceParser:anything() didStartViewWithClassString:@"UILabel" attributes:anything()];
}

- (void)testEndViewDelegateMethodIsCalled
{
    NSString *stringXml = @"<UIButton />";

    XMLInterfaceParser *parser = [[XMLInterfaceParser alloc] initWithString:stringXml];
    parser.delegate = mockDelegate;
    [parser parse];

    [verify(mockDelegate) interfaceParser:anything() didEndViewWithClassString:@"UIButton"];
}

#pragma mark - Attributes
- (void)testAttributesArePassedToDelegate
{
    NSString *stringXml = @"<UIButton hidden='YES' alpha='0.5' />";

    XMLInterfaceParser *parser = [[XMLInterfaceParser alloc] initWithString:stringXml];
    parser.delegate = mockDelegate;
    [parser parse];

    NSDictionary *attributes = @{
            @"hidden": @"YES",
            @"alpha": @"0.5"};
    [verify(mockDelegate) interfaceParser:anything() didStartViewWithClassString:@"UIButton" attributes:attributes];
}

#pragma mark - Unhappy flows
- (void)testErrorInAttributes
{
    NSString *stringXml = @"<UIButton hidden />";

    XMLInterfaceParser *parser = [[XMLInterfaceParser alloc] initWithString:stringXml];
    parser.delegate = mockDelegate;
    [parser parse];

    [verifyCount(mockDelegate, never()) interfaceParser:anything() didStartViewWithClassString:anything() attributes:anything()];
    assertThat(parser.error, isNot(nilValue()));
}

- (void)testInput_emptyString
{
    NSString *stringXml = @"";

    XMLInterfaceParser *parser = [[XMLInterfaceParser alloc] initWithString:stringXml];
    [parser parse];

    [verifyCount(mockDelegate, never()) interfaceParser:anything() didStartViewWithClassString:anything() attributes:anything()];
    assertThat(parser.error, isNot(nilValue()));
}

- (void)testInput_nil
{
    NSString *stringXml = nil;

    XMLInterfaceParser *parser = [[XMLInterfaceParser alloc] initWithString:stringXml];
    [parser parse];

    [verifyCount(mockDelegate, never()) interfaceParser:anything() didStartViewWithClassString:anything() attributes:anything()];
    assertThat(parser.error, isNot(nilValue()));
}

@end