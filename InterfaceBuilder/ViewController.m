#import "ViewController.h"
#import "InterfaceBuilder.h"
#import "XMLInterfaceParser.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)loadView
{
    InterfaceBuilder *builder = [self createBuilderWithInterfaceString:@
            "<UIView>"
                "<UILabel text='Hello World!!!' x='20' y='100' width='200' height='30' />"
            "</UIView>"
    ];
    self.view = [builder build];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
}

- (InterfaceBuilder *)createBuilderWithInterfaceString:(NSString *)string
{
    XMLInterfaceParser *parser = [[XMLInterfaceParser alloc] initWithString:string];
    InterfaceBuilder *interfaceBuilder = [[InterfaceBuilder alloc] initWithInterfaceParser:parser];
    return interfaceBuilder;
}

@end
