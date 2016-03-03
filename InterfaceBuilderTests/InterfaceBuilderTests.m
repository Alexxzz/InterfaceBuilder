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


#pragma mark - Custom view
@interface CustomView: UIView
@end
@implementation CustomView
@end

#pragma mark - Test
@interface InterfaceBuilderTests : XCTestCase
@end

@implementation InterfaceBuilderTests

- (void)testReadAndBuildInterfaceWithSingleView
{
    InterfaceBuilder *interfaceBuilder = [[InterfaceBuilder alloc] init];

    UIView *view = [interfaceBuilder buildFromString:@"<UIView />"];

    assertThat(view, isA([UIView class]));
}

- (void)testReadAndBuildInterfaceWithSingleLabel
{
    InterfaceBuilder *interfaceBuilder = [[InterfaceBuilder alloc] init];

    UIView *view = [interfaceBuilder buildFromString:@"<UILabel />"];

    assertThat(view, isA([UILabel class]));
}

- (void)testOrganizeViewsInHierarchy
{
    InterfaceBuilder *interfaceBuilder = [[InterfaceBuilder alloc] init];

    UIView *view = [interfaceBuilder buildFromString:
            @"<UIView>"
                "<UILabel />"
                "<UIButton />"
            "</UIView>"];

    assertThat([view.subviews firstObject], isA([UILabel class]));
    assertThat([view.subviews lastObject], isA([UIButton class]));
}

- (void)testOrganizeViewsInHierarchy_multipleNesting
{
    InterfaceBuilder *interfaceBuilder = [[InterfaceBuilder alloc] init];

    UIView *view = [interfaceBuilder buildFromString:
            @"<UIView>"
                "<UIView>"
                    "<UILabel />"
                "</UIView>"

                "<UIView>"
                    "<UIButton />"
                "</UIView>"
            "</UIView>"];

    UIView *firstSubview = [view.subviews firstObject];
    UIView *secondSubview = [view.subviews lastObject];
    id firstSubviewSubview = [firstSubview.subviews firstObject];
    id secondSubviewSubview = [secondSubview.subviews firstObject];
    assertThat(firstSubviewSubview, isA([UILabel class]));
    assertThat(secondSubviewSubview, isA([UIButton class]));
}

- (void)testMultipleRootElements
{
    InterfaceBuilder *interfaceBuilder = [[InterfaceBuilder alloc] init];

    UIView *view = [interfaceBuilder buildFromString:@"<UIView /><UILabel />"];

    assertThat(view, isA([UIView class]));
    assertThat(view.subviews, isEmpty());
}

#pragma mark - Custom view
- (void)testCreatesCustomView
{
    InterfaceBuilder *interfaceBuilder = [[InterfaceBuilder alloc] init];

    UIView *view = [interfaceBuilder buildFromString:@"<CustomView />"];

    assertThat(view, isA([CustomView class]));
}

- (void)testCreatesCustomViewWithSubviews
{
    InterfaceBuilder *interfaceBuilder = [[InterfaceBuilder alloc] init];

    UIView *view = [interfaceBuilder buildFromString:@"<CustomView> <UIButton /> </CustomView>"];

    assertThat([view.subviews lastObject], isA([UIButton class]));
}

#pragma mark - Unhappy flows
- (void)testBadInput
{
    InterfaceBuilder *interfaceBuilder = [[InterfaceBuilder alloc] init];

    UIView *view = [interfaceBuilder buildFromString:@"Not correct input"];

    assertThat(view, nilValue());
}

- (void)testNilInput
{
    InterfaceBuilder *interfaceBuilder = [[InterfaceBuilder alloc] init];

    UIView *view = [interfaceBuilder buildFromString:nil];

    assertThat(view, nilValue());
}

- (void)testRootElementUnknownClass
{
    InterfaceBuilder *interfaceBuilder = [[InterfaceBuilder alloc] init];

    UIView *view = [interfaceBuilder buildFromString:@"<SomeUnknownView />"];

    assertThat(view, nilValue());
}

- (void)testNestedElementUnknownClass
{
    InterfaceBuilder *interfaceBuilder = [[InterfaceBuilder alloc] init];

    UIView *view = [interfaceBuilder buildFromString:@"<UIView> <SomeUnknownView /> </UIView>"];

    assertThat(view, nilValue());
}

- (void)testElementIsNotUIViewSubclass
{
    InterfaceBuilder *interfaceBuilder = [[InterfaceBuilder alloc] init];

    UIView *view = [interfaceBuilder buildFromString:@"<NSString> <UIView /> </NSString>"];

    assertThat(view, nilValue());
}

@end
