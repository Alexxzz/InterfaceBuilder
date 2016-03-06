#import <Foundation/Foundation.h>
#import "InterfaceBuilder.h"

@interface XMLInterfaceParser : NSObject <InterfaceParserProtocol>
@property (nonatomic, weak) id<InterfaceParserDelegate> delegate;
@property (nonatomic, readonly) NSError *error;

- (instancetype)initWithData:(NSData *)data;
- (instancetype)initWithString:(NSString *)string;

@end