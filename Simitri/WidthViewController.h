//
//  WidthViewController.h
//  Symmetry
//
//  Created by John on 22/05/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WidthIndicator.h"
#import "PWidthView.h"

@interface WidthViewController : UIViewController <PWidthView>

- (id) initWithWidth:(NSInteger)width;

@end
