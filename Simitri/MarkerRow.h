//
//  MarkerImage.h
//  Simitri
//
//  Created by John on 15/06/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMathMarker.h"

@interface MarkerRow : UIView

- (id) initWithMarker:(AMathMarker*) m withTransforms:(NSArray*) transforms withLabel:(NSString*) label;

@end
