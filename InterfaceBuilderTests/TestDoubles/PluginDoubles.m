#import "PluginDoubles.h"


@implementation PluginDummy
- (void)interfaceBuilder:(InterfaceBuilder *)interfaceBuilder
            didBuildView:(UIView *)view
             ofClassName:(NSString *)className
          withAttributes:(NSDictionary *)attributes
{ }
@end

@implementation PluginSpy
- (void)interfaceBuilder:(InterfaceBuilder *)interfaceBuilder
            didBuildView:(UIView *)view
             ofClassName:(NSString *)className
          withAttributes:(NSDictionary *)attributes
{
    self.view = view;
    self.viewClass = NSClassFromString(className);
    self.params = attributes;
}
@end
