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


@interface InterfaceBuilderTests : XCTestCase

@end

@implementation InterfaceBuilderTests

//- (void)testReadInterfaceFormASource
//{
//    id<InterfaceReaderProtocol> interfaceReader = [[XMLInterfaceReader alloc] init];
//
//    InterfaceBuilder *interfaceBuilder = [[InterfaceBuilder alloc] initWithInterfaceReader:interfaceReader];
//
//    id interface = interfaceBuilder.build();
//
//    assertThat(interface, notNilValue());
//}

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

    UIView *view = [interfaceBuilder buildFromString:@"<UIView> <UILabel /> </UIView>"];

    assertThat([view.subviews firstObject], isA([UILabel class]));
}

@end
