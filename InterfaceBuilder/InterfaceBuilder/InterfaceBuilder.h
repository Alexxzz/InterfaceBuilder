#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//
//@protocol InterfaceReaderProtocol
//- (void)read;
//@end


@interface InterfaceBuilder : NSObject
- (UIView *)buildFromString:(NSString *)string;
@end