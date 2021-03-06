//
//  InterfaceBuilderTests.m
//  InterfaceBuilderTests
//
//  Created by Oleksandr Zahorskyi on 29/02/16.
//  Copyright (c) 2016 AlexZz. All rights reserved.
//

#import <XCTest/XCTest.h>

#import <OCHamcrest/OCHamcrest.h>

#import "InterfaceBuilder.h"
#import "XMLInterfaceParser.h"

#import "PluginDoubles.h"


#pragma mark - Custom view
@interface CustomView: UIView
@end
@implementation CustomView
@end

#pragma mark - Test
@interface InterfaceBuilderTests : XCTestCase
@end

@implementation InterfaceBuilderTests

#pragma mark - Helpers
- (InterfaceBuilder *)createBuilderWithInterfaceString:(NSString *)string
{
    XMLInterfaceParser *parser = [[XMLInterfaceParser alloc] initWithString:string];
    InterfaceBuilder *interfaceBuilder = [[InterfaceBuilder alloc] initWithInterfaceParser:parser];
    return interfaceBuilder;
}

#pragma mark - Tests
- (void)testReadAndBuildInterfaceWithSingleView
{
    InterfaceBuilder *interfaceBuilder = [self createBuilderWithInterfaceString:@"<UIView />"];

    UIView *view = [interfaceBuilder build];

    assertThat(view, isA([UIView class]));
}

- (void)testReadAndBuildInterfaceWithSingleLabel
{
    InterfaceBuilder *interfaceBuilder = [self createBuilderWithInterfaceString:@"<UILabel />"];

    UIView *view = [interfaceBuilder build];

    assertThat(view, isA([UILabel class]));
}

- (void)testOrganizeViewsInHierarchy
{
    InterfaceBuilder *interfaceBuilder = [self createBuilderWithInterfaceString:
            @"<UIView>"
                "<UILabel />"
                "<UIButton />"
            "</UIView>"];

    UIView *view = [interfaceBuilder build];

    assertThat([view.subviews firstObject], isA([UILabel class]));
    assertThat([view.subviews lastObject], isA([UIButton class]));
}

- (void)testOrganizeViewsInHierarchy_multipleNesting
{
    InterfaceBuilder *interfaceBuilder = [self createBuilderWithInterfaceString:
            @"<UIView>"
                "<UIView>"
                    "<UILabel />"
                "</UIView>"

                "<UIView>"
                    "<UIButton />"
                "</UIView>"
            "</UIView>"];

    UIView *view = [interfaceBuilder build];

    UIView *firstSubview = [view.subviews firstObject];
    UIView *secondSubview = [view.subviews lastObject];
    id firstSubviewSubview = [firstSubview.subviews firstObject];
    id secondSubviewSubview = [secondSubview.subviews firstObject];
    assertThat(firstSubviewSubview, isA([UILabel class]));
    assertThat(secondSubviewSubview, isA([UIButton class]));
}

- (void)testMultipleRunOfTheSameParserInstance
{
    InterfaceBuilder *interfaceBuilder = [self createBuilderWithInterfaceString:@"<UILabel />"];

    UIView *view1 = [interfaceBuilder build];
    UIView *view2 = [interfaceBuilder build];

    assertThat(view1, isA([UILabel class]));
    assertThat(view2, isA([UILabel class]));
}

#pragma mark - Custom view
- (void)testCreatesCustomView
{
    InterfaceBuilder *interfaceBuilder = [self createBuilderWithInterfaceString:@"<CustomView />"];

    UIView *view = [interfaceBuilder build];

    assertThat(view, isA([CustomView class]));
}

- (void)testCreatesCustomViewWithSubviews
{
    InterfaceBuilder *interfaceBuilder = [self createBuilderWithInterfaceString:@"<CustomView> <UIButton /> </CustomView>"];

    UIView *view = [interfaceBuilder build];

    assertThat([view.subviews lastObject], isA([UIButton class]));
}

#pragma mark - Attributes
- (void)testAttributeIsSetToACorrespondingView_numberValue
{
    InterfaceBuilder *interfaceBuilder = [self createBuilderWithInterfaceString:@"<UIView hidden='1'/>"];

    UIView *view = [interfaceBuilder build];

    assertThatBool(view.hidden, isTrue());
}

- (void)testAttributeIsSetToACorrespondingView_stringValue
{
    InterfaceBuilder *interfaceBuilder = [self createBuilderWithInterfaceString:@"<UILabel text='Hello World!'/>"];

    UILabel *label = (UILabel *) [interfaceBuilder build];

    assertThat(label.text, is(@"Hello World!"));
}

- (void)testAttributeIsSetByKeyPath
{
    InterfaceBuilder *interfaceBuilder = [self createBuilderWithInterfaceString:@"<UIView layer.cornerRadius='5.5'/>"];

    UIView *view = [interfaceBuilder build];

    assertThatFloat(view.layer.cornerRadius, is(@5.5));
}

- (void)testUnknownAttribute
{
    InterfaceBuilder *interfaceBuilder = [self createBuilderWithInterfaceString:@"<UIView text='100'/>"];

    UIView *view = [interfaceBuilder build];

    assertThat(view, isNot(nilValue()));
}

- (void)testSettingNumberAsStringToStringAttribute
{
    InterfaceBuilder *interfaceBuilder = [self createBuilderWithInterfaceString:@"<UILabel text='100'/>"];

    UILabel *label = (UILabel *) [interfaceBuilder build];

    assertThat(label.text, is(@"100"));
}

#pragma mark - Plugin system
- (void)testAddingPlugin
{
    id<InterfaceBuilderPluginProtocol> plugin = [[PluginDummy alloc] init];
    InterfaceBuilder *interfaceBuilder = [[InterfaceBuilder alloc] init];

    [interfaceBuilder addPlugin:plugin];
    BOOL hasPlugin = [interfaceBuilder containsPlugin:plugin];

    assertThatBool(hasPlugin, isTrue());
}

- (void)testRemovingPlugin
{
    id<InterfaceBuilderPluginProtocol> plugin = [[PluginDummy alloc] init];
    InterfaceBuilder *interfaceBuilder = [[InterfaceBuilder alloc] init];

    [interfaceBuilder addPlugin:plugin];
    [interfaceBuilder removePlugin:plugin];
    BOOL hasPlugin = [interfaceBuilder containsPlugin:plugin];

    assertThatBool(hasPlugin, isFalse());
}

- (void)testAddingNilPlugin
{
    InterfaceBuilder *interfaceBuilder = [[InterfaceBuilder alloc] init];

    [interfaceBuilder addPlugin:nil];
    BOOL hasPlugin = [interfaceBuilder containsPlugin:nil];

    assertThatBool(hasPlugin, isFalse());
}

- (void)testPluginKnowsWhichViewIsCreated
{
    Class viewClass = [UILabel class];
    NSDictionary *params = @{@"text": @"Hello World!"};

    InterfaceBuilder *interfaceBuilder = [self createBuilderWithInterfaceString:@"<UILabel text='Hello World!'/>"];
    PluginSpy *pluginSpy = [[PluginSpy alloc] init];
    [interfaceBuilder addPlugin:pluginSpy];

    UIView *view = [interfaceBuilder build];

    assertThat(pluginSpy.view, equalTo(view));
    assertThat(pluginSpy.viewClass, equalTo(viewClass));
    assertThat(pluginSpy.params, equalTo(params));
}

#pragma mark - Unhappy flows
- (void)testBadInput
{
    InterfaceBuilder *interfaceBuilder = [self createBuilderWithInterfaceString:@"Not correct input"];

    UIView *view = [interfaceBuilder build];

    assertThat(view, nilValue());
}

- (void)testNilInput
{
    InterfaceBuilder *interfaceBuilder = [self createBuilderWithInterfaceString:nil];

    UIView *view = [interfaceBuilder build];

    assertThat(view, nilValue());
}

- (void)testRootElementUnknownClass
{
    InterfaceBuilder *interfaceBuilder = [self createBuilderWithInterfaceString:@"<SomeUnknownView />"];

    UIView *view = [interfaceBuilder build];

    assertThat(view, nilValue());
}

- (void)testNestedElementUnknownClass
{
    InterfaceBuilder *interfaceBuilder = [self createBuilderWithInterfaceString:@"<UIView> <SomeUnknownView /> </UIView>"];

    UIView *view = [interfaceBuilder build];

    assertThat(view, nilValue());
}

- (void)testElementIsNotUIViewSubclass
{
    InterfaceBuilder *interfaceBuilder = [self createBuilderWithInterfaceString:@"<NSString> <UIView /> </NSString>"];

    UIView *view = [interfaceBuilder build];

    assertThat(view, nilValue());
}

- (void)testMultipleRootElements
{
    InterfaceBuilder *interfaceBuilder = [self createBuilderWithInterfaceString:@"<UIView /><UILabel />"];

    UIView *view = [interfaceBuilder build];

    assertThat(view, nilValue());
}

@end
