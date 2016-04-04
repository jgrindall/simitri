//
//  AContainerViewController_Protected.h
//  Symmetry
//
//  Created by John on 20/05/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "AContainerViewController.h"

@interface AContainerViewController ()

- (void) addChildInto:(UIView*) container withController:(UIViewController*) controller;
- (void) removeChildFrom:(UIView*) container withController:(UIViewController*) controller;

@end
