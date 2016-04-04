//
//  APageDataProvider.m
//  Symmetry
//
//  Created by John on 30/05/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "APageDataProvider.h"
#import "APageContentViewController_Protected.h"
#import "SymmNotifications.h"

@implementation APageDataProvider

- (id)initWithPageClass:(Class)pageClass{
    self = [super init];
    if (self) {
		self.pageClass = pageClass;
		self.myIndex = 0;
		// two default pages to start with, must be two different values
		self.dataArray = [[NSArray alloc] initWithObjects:@"0", @"1", nil];
	}
    return self;
}

- (APageContentViewController *)viewControllerAtIndex:(NSUInteger)index{
	if (([self.dataArray count] == 0) || (index >= [self.dataArray count])) {
        return nil;
    }
	APageContentViewController* pageViewController = [[self.pageClass alloc] init];
	pageViewController.dataObject = self.dataArray[index];
	return pageViewController;
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController{
	return self.dataArray.count;
}

- (NSInteger) presentationIndexForPageViewController:(UIPageViewController *)pageViewController{
	return 0;
}

- (NSUInteger)indexOfViewController:(UIViewController*)viewController{
	APageContentViewController* controller = (APageContentViewController*)viewController;
	return [self.dataArray indexOfObject:controller.dataObject];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
	NSUInteger index = [self indexOfViewController:viewController];
	self.myIndex = index;
	if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    NSUInteger index = [self indexOfViewController:viewController];
	self.myIndex = index;
	if (index == NSNotFound) {
        return nil;
    }
    index++;
    if (index == [self.dataArray count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

- (void) dealloc{
	self.dataArray = nil;
	self.pageClass = nil;
}

@end
