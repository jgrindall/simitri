//
//  PVController.m
//  PageVCTesting
//
//  Created by John on 23/05/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "TemplateFileViewController.h"
#import "TemplateDataProvider.h"
#import "APagedViewController_Protected.h"
#import "SymmNotifications.h"

@interface APagedViewController ()

@end

@implementation APagedViewController


- (id)initWithTransitionStyle:(UIPageViewControllerTransitionStyle)style navigationOrientation:(UIPageViewControllerNavigationOrientation)navigationOrientation options:(NSDictionary *)options withDataProvider:(APageDataProvider*) dataProvider{
	self = [super initWithTransitionStyle:style navigationOrientation:navigationOrientation options:options];
	if(self){
		self.dataProvider = dataProvider;
	}
	return self;
}

- (NSInteger) getNumberOfPages{
	return self.dataProvider.dataArray.count;
}

- (void) pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed{
	UIViewController* page = [self.viewControllers objectAtIndex:0];
	self.dataProvider.myIndex = [self.dataProvider indexOfViewController:page];
}

- (NSInteger) getSelectedIndex{
	return self.dataProvider.myIndex;
}

- (void) setPageDataArray:(NSArray*)data{
	self.dataProvider.dataArray = data;
	[self reloadData];
	[self.view setNeedsDisplay];
}

- (void)didReceiveMemoryWarning{
	[super didReceiveMemoryWarning];
}

- (void)prevPage{
	NSInteger i = [self getSelectedIndex];
	if(i > 0 ){
		[self flipToPage:(i - 1) withDirection:UIPageViewControllerNavigationDirectionReverse];
	}
}

- (void)nextPage{
	NSInteger i = [self getSelectedIndex];
	if(i < self.dataProvider.dataArray.count - 1 ){
		[self flipToPage:(i + 1) withDirection:UIPageViewControllerNavigationDirectionForward];
	}
}

- (void)flipToPage:(NSInteger)i withDirection:(UIPageViewControllerNavigationDirection)d{
	UIViewController* v0 = [self.dataProvider viewControllerAtIndex:i];
	self.dataProvider.myIndex = i;
	[self setViewControllers:[NSArray arrayWithObjects:v0, nil] direction:d animated:YES completion:NULL];
}

- (void)viewDidLoad{
    [super viewDidLoad];
	self.delegate = self;
	[self reloadData];
}

- (void) viewDidAppear:(BOOL)animated{
	[super viewDidAppear:animated];
	[self reloadData];
}

- (UIPageViewControllerSpineLocation)pageViewController:(UIPageViewController *)pageViewController spineLocationForInterfaceOrientation:(UIInterfaceOrientation)orientation{
	if (UIInterfaceOrientationIsPortrait(orientation)) {
	    UIViewController *currentViewController = self.viewControllers[0];
	    [self setViewControllers:@[currentViewController] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
	    self.doubleSided = NO;
	    return UIPageViewControllerSpineLocationMin;
	}
	id currentViewController = self.viewControllers[0];
	NSArray *viewControllers = nil;
	NSUInteger indexOfCurrentViewController = [self.dataProvider indexOfViewController:currentViewController];
	if (indexOfCurrentViewController == 0 || indexOfCurrentViewController % 2 == 0) {
	    UIViewController* nextViewController = [self.dataProvider pageViewController:self viewControllerAfterViewController:currentViewController];
	    viewControllers = @[currentViewController, nextViewController];
	}
	else {
	    UIViewController* previousViewController = [self.dataProvider pageViewController:self viewControllerBeforeViewController:currentViewController];
	    viewControllers = @[previousViewController, currentViewController];
	}
	[self setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
	return UIPageViewControllerSpineLocationMid;
}

- (void) reloadData{
	self.dataSource = nil;
	self.dataSource = self.dataProvider;
	UIViewController* startingViewController = [self.dataProvider viewControllerAtIndex:0];
	if(startingViewController){
		[self setViewControllers:@[startingViewController] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
	}
}

@end

