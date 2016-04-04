//
//  FilesViewController.h
//  Symmetry
//
//  Created by John on 19/05/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AContainerViewController_Protected.h"
#import "PDrawingAnimator.h"

@interface TemplateScreenController : AContainerViewController <PDrawingAnimator>

- (void)tplChosen;
- (void)egChosen;
- (void)infoChosen;

@end
