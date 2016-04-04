//
//  APageDataProvider.h
//  Symmetry
//
//  Created by John on 30/05/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APageContentViewController.h"

@interface APageDataProvider : NSObject <UIPageViewControllerDataSource>

@property (nonatomic) NSArray* dataArray;
@property NSInteger myIndex;
@property Class pageClass;

- (id)initWithPageClass:(Class)pageClass;
- (APageContentViewController*)viewControllerAtIndex:(NSUInteger)index;
- (NSUInteger)indexOfViewController:(UIViewController *)viewController;

@end
