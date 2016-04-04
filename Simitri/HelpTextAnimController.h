//
//  HelpTextAnimController.h
//  Simitri
//
//  Created by John on 18/06/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "AHelpContentsViewController.h"

@interface HelpTextAnimController : AHelpContentsViewController

- (id) initWithText:(NSString*)text withDrawerNum:(NSInteger)drawerNum;

- (void) touch:(UITouch*) anyObject;

@end
