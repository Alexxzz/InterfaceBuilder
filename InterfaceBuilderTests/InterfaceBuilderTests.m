//
//  InterfaceBuilderTests.m
//  InterfaceBuilderTests
//
//  Created by Oleksandr Zahorskyi on 29/02/16.
//  Copyright (c) 2016 AlexZz. All rights reserved.
//

#import <XCTest/XCTest.h>

#import <OCHamcrest/OCHamcrest.h>
#import <OCMockito/OCMockito.h>

#import "InterfaceBuilder.h"
#import "XMLInterfaceParser.h"


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

#pragma mark - Frame layout
- (void)testSettingFrameParameters
{
    CGRect viewFrame = CGRectMake(10, 10, 200, 150);
    CGRect subviewFrame = CGRectMake(5, 5, 100, 50);
    InterfaceBuilder *interfaceBuilder = [self createBuilderWithInterfaceString:@
            "<UIView x='10' y='10' width='200' height='150'>"
                "<UILabel x='5' y='5' width='100' height='50' /> "
            "</UIView>"];

    UIView *view = [interfaceBuilder build];
    UILabel *subview = [view.subviews firstObject];
    assertThatBool(CGRectEqualToRect(view.frame, viewFrame), isTrue());
    assertThatBool(CGRectEqualToRect(subview.frame, subviewFrame), isTrue());
}

- (void)testSettingFrameParameters_centerPoint
{
    CGPoint viewCenterPoint = CGPointMake(10, 20);
    CGPoint subviewCenterPoint = CGPointMake(30, 40);
    InterfaceBuilder *interfaceBuilder = [self createBuilderWithInterfaceString:@
            "<UIView centerX='10' centerY='20'>"
                "<UILabel centerX='30' centerY='40'/> "
            "</UIView>"];

    UIView *view = [interfaceBuilder build];
    UILabel *subview = [view.subviews firstObject];
    assertThatBool(CGPointEqualToPoint(view.center, viewCenterPoint), isTrue());
    assertThatBool(CGPointEqualToPoint(subview.center, subviewCenterPoint), isTrue());
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
