//
//  MapView.h
//  Simitri
//
//  Created by John on 12/06/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MapView : UIView

- (void) mark:(CGPoint) p withLabel:(NSString*) name;
- (void) refresh;

@end
