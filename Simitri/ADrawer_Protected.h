//
//  ADrawer_Protected.h
//  Symmetry
//
//  Created by John on 18/05/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "ADrawer.h"
#import "Polygon.h"
#import "AMathMarker.h"

@interface ADrawer ()


@property NSArray* polyArray;
@property Polygon* basicPolygon;
@property NSArray* basicPoints;
@property CGSize screenSize;
@property CGAffineTransform flipTransform;
@property NSArray* transforms;
@property NSArray* mathMarkers;
@property CGPoint centreOfMass;
@property float inRadius;

- (NSArray*) getTransformations;
- (NSArray*) getTheBasicPoints;
- (Polygon*) getTheBasicPolygon;
- (CGRect) getBasicRectangle;
- (UIImage*) getTheGridImage;
- (UIImage*) getTheMathImage;
- (UIImage*) getTheDemoImage;
- (NSArray*) getMathPolygons;
- (NSArray*) getBasicMathMarkers;

- (NSInteger) polygonIndexForPoint:(CGPoint)p dx:(int*) dx dy:(int*) dy;
- (CGPoint) pointMapIntoBasicRect:(CGPoint)p dx:(int*) dx dy:(int*) dy;
- (NSArray*) getMathTransformBasicCentres;
- (TransformPair*) getMathTransformForIndex:(NSInteger) i withCentre:(CGPoint) centre atTime:(float)t;

@end

