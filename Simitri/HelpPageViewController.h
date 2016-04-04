
//  Created by John on 22/05/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APageContentViewController_Protected.h"
#import "AHelpContentsViewController.h"

@interface HelpPageViewController : APageContentViewController

+ (AHelpContentsViewController*) getControllerForIndex:(NSInteger)i;

@end
