//
//  PVController.h
//  PageVCTesting
//
//  Created by John on 23/05/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FileManagerDelegate.h"
#import "APageDataProvider.h"

@interface APagedViewController : UIPageViewController <UIPageViewControllerDelegate, UIScrollViewDelegate, UIGestureRecognizerDelegate>

- (id)initWithTransitionStyle:(UIPageViewControllerTransitionStyle)style navigationOrientation:(UIPageViewControllerNavigationOrientation)navigationOrientation options:(NSDictionary *)options withDataProvider:(APageDataProvider*) dataProvider;
- (NSInteger) getSelectedIndex;
- (NSInteger) getNumberOfPages;
- (void) setPageDataArray:(NSArray *)data;
- (void) flipToPage:(NSInteger)i withDirection:(UIPageViewControllerNavigationDirection)d;
- (void) prevPage;
- (void) nextPage;

@end
