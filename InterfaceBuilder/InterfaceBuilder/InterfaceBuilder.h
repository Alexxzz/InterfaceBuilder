#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface InterfaceBuilder : NSObject

- (UIView *)buildFromString:(NSString *)string;

@end