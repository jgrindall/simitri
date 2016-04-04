//
//  Polygon.h
//  PathRect
//
//  Created by John on 22/05/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Polygon : NSObject

@property NSArray* points;


- (BOOL) containsPoint:(CGPoint) point;
- (id) initWithPoints:(NSArray*) points;
- (Polygon*) applyTransform:(CGAffineTransform) t;
- (UIBezierPath*) toBezPath;
- (CGPoint) getCOM;
- (float) getInRadius;

@end
