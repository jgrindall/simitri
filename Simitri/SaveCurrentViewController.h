//
//  SaveCurrentViewController.h
//  Symmetry
//
//  Created by John on 09/06/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PYesNoMenuResponder.h"

@interface SaveCurrentViewController : UIViewController <PYesNoMenuResponder>

- (id) initWithNewFile:(BOOL)newFile;

@end
