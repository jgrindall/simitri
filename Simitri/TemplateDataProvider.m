

#import "TemplateDataProvider.h"
#import "TemplatePageViewController.h"
#import "SymmNotifications.h"

@interface TemplateDataProvider()

@end

@implementation TemplateDataProvider

- (id)initWithPageClass:(Class)pageClass{
    self = [super initWithPageClass:pageClass];
    if (self) {
		NSArray* tpls = [[NSArray alloc] initWithObjects:@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"11", @"12", @"13", @"14", @"15", @"16", nil];
		self.dataArray = tpls;
	}
    return self;
}

- (void) dealloc{
	
}

@end
