//
//  Line.h
//  Symmetry
//
//  Created by John on 16/05/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ADrawer_Protected.h"

@interface Line : NSObject <NSCoding>

@property UIColor* color;
@property NSNumber* alpha;
@property NSInteger width;
@property NSInteger count;

- (id) initWithColor:(UIColor*) color withWidth:(NSInteger) width withAlpha:(NSNumber*)alpha;
- (void) startAtPoint:(CGPoint) p0;
- (void) addCurveToPoint:(CGPoint) p3 controlPoint1:(CGPoint)p1 controlPoint2:(CGPoint)p2;
- (void) cached;
- (CGMutablePathRef) getPath;
- (CGMutablePathRef) getWhole;

@end
