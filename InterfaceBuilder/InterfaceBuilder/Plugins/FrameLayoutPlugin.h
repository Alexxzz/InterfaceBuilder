#import <Foundation/Foundation.h>
#import "InterfaceBuilder.h"

/*
 * frame_layout:height
 */
FOUNDATION_EXPORT NSString * const FrameLayoutPluginHeightAttribute;

/*
 * frame_layout:width
 */
FOUNDATION_EXPORT NSString * const FrameLayoutPluginWidthAttribute;

/*
 * frame_layout:x
 */
FOUNDATION_EXPORT NSString * const FrameLayoutPluginXAttribute;

/*
 * frame_layout:y
 */
FOUNDATION_EXPORT NSString * const FrameLayoutPluginYAttribute;

/*
 * frame_layout:centerX
 */
FOUNDATION_EXPORT NSString * const FrameLayoutPluginCenterXAttribute;

/*
 * frame_layout:centerY
 */
FOUNDATION_EXPORT NSString * const FrameLayoutPluginCenterYAttribute;

@interface FrameLayoutPlugin : NSObject <InterfaceBuilderPluginProtocol>
- (void)interfaceBuilder:(InterfaceBuilder *)interfaceBuilder
            didBuildView:(UIView *)view
             ofClassName:(NSString *)className
          withAttributes:(NSDictionary *)attributes;
@end