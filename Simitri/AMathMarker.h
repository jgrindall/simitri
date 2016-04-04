//
//  MathMarker.h
//  Simitri
//
//  Created by John on 13/06/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AMathMarker : NSObject

@property UIBezierPath* path;
@property UIColor* color;


+ (AMathMarker*) getRotOrder346CentrePolygonWithOrigin:(CGPoint) p withP1:(CGPoint)p1 andAngle:(float) theta andOrder:(NSInteger)order andLength:(NSInteger)len;
+ (AMathMarker*) getRotOrder2CentrePolygonWithOrigin:(CGPoint) p withStartAngle:(float) theta0 andAngle:(float)angle andRadius:(float)len;
+ (AMathMarker*) getLineOfReflectionWithP0:(CGPoint) p0 withP1:(CGPoint)p1 withP3Angle:(float)p3Angle;
+ (AMathMarker*) getTranslationWithOrigin:(CGPoint) p withP1:(CGPoint)p1 withMiddle:(CGPoint)middle withScale:(float)scale withMove:(BOOL)move;
+ (AMathMarker*) getGlideRefWithOrigin:(CGPoint) p withP1:(CGPoint)p1 withMiddle:(CGPoint)middle withScale:(float)scale withMove:(BOOL)move;
+ (AMathMarker*) getPartialRotCentrePolygonWithOrigin:(CGPoint) p withP1:(CGPoint)p1 andAngle:(float) theta andOrder:(int) order andLength:(NSInteger)len withFrac:(float)f;
+ (NSInteger) getDefaultLength;
+ (NSInteger) getDefaultRot2Radius;

+ (UIColor*) colorForRef;
+ (UIColor*) colorForOrder:(NSInteger)order;

@end
