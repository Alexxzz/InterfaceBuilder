#import <Foundation/Foundation.h>
#import "InterfaceBuilder.h"

@interface PluginDummy : NSObject <InterfaceBuilderPluginProtocol>
@end

@interface PluginSpy: NSObject <InterfaceBuilderPluginProtocol>
@property (nonatomic, strong) UIView *view;
@property (nonatomic, strong) Class viewClass;
@property (nonatomic, strong) NSDictionary *params;
@end

