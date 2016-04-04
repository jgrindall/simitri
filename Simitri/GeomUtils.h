//
//  GeomUtils.h
//  Symmetry
//
//  Created by John on 23/05/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface GeomUtils : NSObject

+ (BOOL) pointMatched:(CGPoint) p0 with:(CGPoint) p1;
+ (float) distFrom:(CGPoint) p0 to:(CGPoint) p1;
+ (BOOL) CGAffMatched:(CGAffineTransform) t0 with:(CGAffineTransform) t1;
+ (CGPoint) pointFrom:(CGPoint)p towards:(CGPoint) endPoint withLength:(float) len;
+ (int) getClosestTo:(CGPoint)p inArray:(NSArray*) array withTolerance:(float)tol;
+ (void) addCompTransforms:(CGAffineTransform) t followedBy:(CGAffineTransform) s followedBy:(CGAffineTransform)u into:(NSMutableArray*)array;
+ (void) addCompTransforms:(CGAffineTransform) t followedBy:(CGAffineTransform) s followedBy:(CGAffineTransform)u followedBy:(CGAffineTransform)v into:(NSMutableArray*)array;
+ (void) addCompTransforms:(CGAffineTransform) t followedBy:(CGAffineTransform) s followedBy:(CGAffineTransform)u followedBy:(CGAffineTransform)v followedBy:(CGAffineTransform)w into:(NSMutableArray*)array;
+ (void) addCompTransform:(CGAffineTransform) t followedBy:(CGAffineTransform) s into:(NSMutableArray*)array;
+ (void) addTransform:(CGAffineTransform) t into:(NSMutableArray*)array;
+ (CGPoint) makeLengthForVector:(CGPoint)v toLength:(float)len;
+ (CGPoint) midPointOf:(CGPoint)p0 with:(CGPoint)p1;
+ (CGPoint) fracAlongLineFrom:(CGPoint)p0 to:(CGPoint)p1 withFrac:(float)f;
+ (UIBezierPath*) demoAnglesWithCentre:(CGPoint)centre withSize:(float)d;
+ (UIBezierPath*) demoSpiralWithCentre:(CGPoint)centre withSize:(float)d;
+ (UIBezierPath*) demoUsWithCentre:(CGPoint)centre withSize:(float)d;
+ (UIBezierPath*) demoLoopWithCentre:(CGPoint)centre withSize:(float)d;
+ (UIBezierPath*) demoStarWithCentre:(CGPoint)centre withSize:(float)d;
+ (float) minDistLineFrom:(CGPoint)centre toLineWithP0:(CGPoint)p0 andP1:(CGPoint)p1;
+ (CGRect) getFrameForImageWidth:(float) w andHeight:(float)h inRect:(CGSize)size;
@end
