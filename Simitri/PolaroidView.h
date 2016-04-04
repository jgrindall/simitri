//
//  PolaroidView.h
//  Symmetry
//
//  Created by John on 27/06/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PolaroidView : UIView

- (id) initWithFrame:(CGRect)frame hasDes:(BOOL)hasDes;
- (void) loadImage:(UIImage*) img withDescription:(NSString*) desc;

@end
