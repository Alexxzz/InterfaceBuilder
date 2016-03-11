#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol InterfaceParserProtocol;

@protocol InterfaceParserDelegate <NSObject>
- (void)interfaceParser:(id <InterfaceParserProtocol>)parser
        didStartViewWithClassString:(NSString *)class
        attributes:(NSDictionary *)attributes;
- (void)interfaceParser:(id<InterfaceParserProtocol>)parser didEndViewWithClassString:(NSString *)class;
@end

@protocol InterfaceParserProtocol <NSObject>
@property (nonatomic, weak) id<InterfaceParserDelegate> delegate;
@property (nonatomic, readonly) NSError *error;
- (void)parse;
- (void)abortParsing;
@end

@interface InterfaceBuilder : NSObject
- (instancetype)initWithInterfaceParser:(id<InterfaceParserProtocol>)parser;
- (UIView *)build;
@end
