#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol InterfaceParserProtocol;
@class InterfaceBuilder;

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

@protocol InterfaceBuilderPluginProtocol <NSObject>
- (void)interfaceBuilder:(InterfaceBuilder *)interfaceBuilder
            didBuildView:(UIView *)view
             ofClassName:(NSString *)className
          withAttributes:(NSDictionary *)attributes;
//
//- (void)interfaceBuilder:(InterfaceBuilder *)interfaceBuilder
//           didFinishWith:(UIView *)view;
@end

@interface InterfaceBuilder : NSObject
- (instancetype)initWithInterfaceParser:(id<InterfaceParserProtocol>)parser;

- (UIView *)build;

- (void)addPlugin:(id <InterfaceBuilderPluginProtocol>)plugin;
- (BOOL)containsPlugin:(id <InterfaceBuilderPluginProtocol>)plugin;

- (void)removePlugin:(id <InterfaceBuilderPluginProtocol>)plugin;
@end
