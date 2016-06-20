#import <XCTest/XCTest.h>

#import <OCHamcrest/OCHamcrest.h>

#import "InterfaceBuilder.h"
#import "XMLInterfaceParser.h"
#import "FrameLayoutPlugin.h"
#import "UIView+FrameMutators.h"


@interface FrameLayoutPluginTest : XCTestCase
@end

@implementation FrameLayoutPluginTest

#pragma mark - Helpers
- (InterfaceBuilder *)createBuilderWithInterfaceString:(NSString *)string
{
    XMLInterfaceParser *parser = [[XMLInterfaceParser alloc] initWithString:string];
    InterfaceBuilder *interfaceBuilder = [[InterfaceBuilder alloc] initWithInterfaceParser:parser];
    return interfaceBuilder;
}

#pragma mark - Tests
- (void)testSettingFrameParameter_width
{
    CGFloat width = 42;

    FrameLayoutPlugin *frameLayoutPlugin = [[FrameLayoutPlugin alloc] init];
    NSString *viewStr = [NSString stringWithFormat:@"<UIView frame_layout:width='%f.0'/>", width];
    InterfaceBuilder *interfaceBuilder = [self createBuilderWithInterfaceString:viewStr];
    [interfaceBuilder addPlugin:frameLayoutPlugin];

    UIView *view = [interfaceBuilder build];

    assertThatFloat(view.frame.size.width, equalToFloat(width));
}

- (void)testSettingFrameParameter_height
{
    CGFloat height = 42;

    FrameLayoutPlugin *frameLayoutPlugin = [[FrameLayoutPlugin alloc] init];
    NSString *viewStr = [NSString stringWithFormat:@"<UIView frame_layout:height='%f.0'/>", height];
    InterfaceBuilder *interfaceBuilder = [self createBuilderWithInterfaceString:viewStr];
    [interfaceBuilder addPlugin:frameLayoutPlugin];

    UIView *view = [interfaceBuilder build];

    assertThatFloat(view.frame.size.height, equalToFloat(height));
}

- (void)testSettingFrameParameter_x
{
    CGFloat x = 42;

    FrameLayoutPlugin *frameLayoutPlugin = [[FrameLayoutPlugin alloc] init];
    NSString *viewStr = [NSString stringWithFormat:@"<UIView frame_layout:x='%f.0'/>", x];
    InterfaceBuilder *interfaceBuilder = [self createBuilderWithInterfaceString:viewStr];
    [interfaceBuilder addPlugin:frameLayoutPlugin];

    UIView *view = [interfaceBuilder build];

    assertThatFloat(view.frame.origin.x, equalToFloat(x));
}

- (void)testSettingFrameParameter_y
{
    CGFloat y = 42;

    FrameLayoutPlugin *frameLayoutPlugin = [[FrameLayoutPlugin alloc] init];
    NSString *viewStr = [NSString stringWithFormat:@"<UIView frame_layout:y='%f.0'/>", y];
    InterfaceBuilder *interfaceBuilder = [self createBuilderWithInterfaceString:viewStr];
    [interfaceBuilder addPlugin:frameLayoutPlugin];

    UIView *view = [interfaceBuilder build];

    assertThatFloat(view.frame.origin.y, equalToFloat(y));
}

- (void)testSettingFrameParameter_centerX
{
    CGFloat x = 42;

    FrameLayoutPlugin *frameLayoutPlugin = [[FrameLayoutPlugin alloc] init];
    NSString *viewStr = [NSString stringWithFormat:@"<UIView frame_layout:centerX='%f.0'/>", x];
    InterfaceBuilder *interfaceBuilder = [self createBuilderWithInterfaceString:viewStr];
    [interfaceBuilder addPlugin:frameLayoutPlugin];

    UIView *view = [interfaceBuilder build];

    assertThatFloat(view.centerX, equalToFloat(x));
}

- (void)testSettingFrameParameter_centerY
{
    CGFloat y = 42;

    FrameLayoutPlugin *frameLayoutPlugin = [[FrameLayoutPlugin alloc] init];
    NSString *viewStr = [NSString stringWithFormat:@"<UIView frame_layout:centerY='%f.0'/>", y];
    InterfaceBuilder *interfaceBuilder = [self createBuilderWithInterfaceString:viewStr];
    [interfaceBuilder addPlugin:frameLayoutPlugin];

    UIView *view = [interfaceBuilder build];

    assertThatFloat(view.centerY, equalToFloat(y));
}

@end