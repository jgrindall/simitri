

#import "HelpDataProvider.h"
#import "HelpPageViewController.h"

@interface HelpDataProvider()

@end

@implementation HelpDataProvider

- (id)initWithPageClass:(Class)pageClass{
    self = [super initWithPageClass:pageClass];
    if (self) {
		self.dataArray = [[NSArray alloc] initWithObjects:@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"11", @"12", @"13", @"14", @"15", @"16", nil];
	}
    return self;
}

@end
