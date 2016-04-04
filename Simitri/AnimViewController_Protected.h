//
//  AnimViewController_Protected.h
//  Symmetry
//
//  Created by John on 23/06/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "AnimViewController.h"
#import "TransformPair.h"
#import "DrawingObject.h"

@interface AnimViewController ()

@property CADisplayLink* animLink;
@property NSInteger animTime;
@property CGPoint animPoint;
@property DrawingObject* drawingObject;

- (void) tick;
- (void) updateViewsWithTrans:(TransformPair*) trans;
- (void) beginAnimate;

@end
