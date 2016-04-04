//
//  PrevFileController.h
//  Symmetry
//
//  Created by John on 25/06/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PYesNoMenuResponder.h"

@interface PrevFileController : UIViewController <PYesNoMenuResponder>

- (id) initWithUrl:(NSURL*)url;

@end
