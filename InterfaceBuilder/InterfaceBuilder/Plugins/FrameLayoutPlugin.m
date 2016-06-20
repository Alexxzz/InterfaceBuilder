#import "FrameLayoutPlugin.h"
#import "UIView+FrameMutators.h"

NSString * const FrameLayoutPluginHeightAttribute = @"frame_layout:height";
NSString * const FrameLayoutPluginWidthAttribute = @"frame_layout:width";
NSString * const FrameLayoutPluginXAttribute = @"frame_layout:x";
NSString * const FrameLayoutPluginYAttribute = @"frame_layout:y";
NSString * const FrameLayoutPluginCenterXAttribute = @"frame_layout:centerX";
NSString * const FrameLayoutPluginCenterYAttribute = @"frame_layout:centerY";

@implementation FrameLayoutPlugin

- (void)interfaceBuilder:(InterfaceBuilder *)interfaceBuilder
            didBuildView:(UIView *)view
             ofClassName:(NSString *)className
          withAttributes:(NSDictionary *)attributes
{
    NSNumber *height = attributes[FrameLayoutPluginHeightAttribute];
    if (height) {
        view.height = height.floatValue;
    }

    NSNumber *width = attributes[FrameLayoutPluginWidthAttribute];
    if (width) {
        view.width = width.floatValue;
    }

    NSNumber *x = attributes[FrameLayoutPluginXAttribute];
    if (x) {
        view.x = x.floatValue;
    }

    NSNumber *y = attributes[FrameLayoutPluginYAttribute];
    if (y) {
        view.y = y.floatValue;
    }

    NSNumber *centerX = attributes[FrameLayoutPluginCenterXAttribute];
    if (centerX) {
        view.centerX = centerX.floatValue;
    }

    NSNumber *centerY = attributes[FrameLayoutPluginCenterYAttribute];
    if (centerY) {
        view.centerY = centerY.floatValue;
    }
}

@end