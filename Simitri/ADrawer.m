//
//  ADrawer.m
//  Symmetry
//
//  Created by John on 18/05/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "ADrawer_Protected.h"
#import "Line.h"
#import "Colors.h"
#import "Polygon.h"
#import "TransformUtils.h"
#import "DisplayUtils.h"
#import "GeomUtils.h"
#import "AMathMarker.h"
#import "ImageUtils.h"
#import "LayoutConsts.h"

@interface ADrawer ()

@property NSInteger drawerNum;
@property NSInteger animIndex;
@property CGPoint animCentre;

@end

@implementation ADrawer

- (id) initWithScreenSize:(CGSize)screenSize withDrawerNum:(NSInteger)drawerNum{
	self = [super init];
	if(self){
		_drawerNum = drawerNum;
		_screenSize = screenSize;
		_basicPoints = [self getTheBasicPoints];
		_basicRect = [self getBasicRectangle];
		_basicPolygon = [self getTheBasicPolygon];
		_transforms = [self getTransformations];
		_flipTransform = [self getFlip];
		_flippedTransforms = [self getFlippedTransformations];
		_polyArray = [self getPolygons];
		_gridImage = [ImageUtils flipImage:[self getTheGridImage]];
		_mathMarkers = [self getBasicMathMarkers];
		_mathImage = [ImageUtils flipImage:[self getTheMathImage]];
		_centreOfMass = [self.basicPolygon getCOM];
		_inRadius = [self.basicPolygon getInRadius] * 0.9;
		_demoImage = [ImageUtils flipImage:[self getTheDemoImage]];
	}
	return self;
}

- (NSArray*) getBasicMathMarkers{
	return nil;
}

- (Polygon*) getTheBasicPolygon{
	return [[Polygon alloc] initWithPoints:self.basicPoints];
}

- (CGRect) getBasicRectangle{
	return CGRectZero;
}

- (CGAffineTransform) getFlip{
	return [TransformUtils reflectInHorizontalLineWithC:self.basicRect.size.height/2];
}

- (TransformPair*) getMathTransformForPoint:(CGPoint) p atTime:(float)t{
	if(t == 0){
		int dx;
		int dy;
		CGPoint mappedPoint = [self pointMapIntoBasicRect:p dx:&dx dy:&dy];
		NSArray* centres = [self getMathTransformBasicCentres];
		self.animIndex = [GeomUtils getClosestTo:mappedPoint inArray:centres withTolerance:LAYOUT_ANIM_CLICK_TOLERANCE];
		if(self.animIndex >= 0){
			CGPoint centre = [centres[self.animIndex] CGPointValue];
			self.animCentre = CGPointMake(centre.x + dx * self.basicRect.size.width, centre.y + dy * self.basicRect.size.height);
		}
	}
	if(self.animIndex >= 0){
		return [self getMathTransformForIndex:self.animIndex withCentre:self.animCentre atTime:t];
	}
	return nil;
}

- (NSArray*) getFlippedTransformations{
	NSMutableArray* array = [NSMutableArray array];
	for (id t in self.transforms) {
		CGAffineTransform trans = [t CGAffineTransformValue];
		CGAffineTransform flipTrans = CGAffineTransformConcat(trans, self.flipTransform);
		[array addObject:[NSValue valueWithCGAffineTransform:flipTrans]];
	}
	return [array copy];
}

- (TransformPair*) getMathTransformForIndex:(NSInteger) i withCentre:(CGPoint) centre atTime:(float)t{
	return [[TransformPair alloc] init];
}

- (NSArray*) getMathPolygons{
	return nil;
}

- (UIImage*) getTheMathImage{
	UIImage* mathImage;
	int i;
	BOOL c = [DisplayUtils createContextWithSize:self.basicRect.size];
	if(c){
		CGContextRef context = UIGraphicsGetCurrentContext();
		if(context){
			for(i = 0; i < self.mathMarkers.count; i++){
				AMathMarker* marker = [self.mathMarkers objectAtIndex:i];
				CGMutablePathRef ref = CGPathCreateMutable();
				for (id transObj in self.transforms) {
					CGAffineTransform trans = [transObj CGAffineTransformValue];
					CGPathAddPath(ref, &trans, marker.path.CGPath);
				}
				CGContextSetFillColorWithColor(context, marker.color.CGColor);
				CGContextAddPath(context, ref);
				CGContextFillPath(context);
				CGPathRelease(ref);
				
			}
			mathImage = UIGraphicsGetImageFromCurrentImageContext();
		}
		UIGraphicsEndImageContext();
	}
	return mathImage;
}

- (UIBezierPath*) getDemoPath{
	int types[17] = {0, 1, 2, 0, 3, 0, 1, 2, 3, 0, 2, 1, 0, 3, 2, 1, 0};
	int m = types[self.drawerNum];
	if(m == 0){
		return [GeomUtils demoSpiralWithCentre:self.centreOfMass withSize:self.inRadius];
	}
	else if(m==1){
		return [GeomUtils demoAnglesWithCentre:self.centreOfMass withSize:self.inRadius];
	}
	else if(m==2){
		return [GeomUtils demoUsWithCentre:self.centreOfMass withSize:self.inRadius];
	}
	else if(m==3){
		return [GeomUtils demoLoopWithCentre:self.centreOfMass withSize:self.inRadius];
	}
	else{
		return [GeomUtils demoStarWithCentre:self.centreOfMass withSize:self.inRadius];
	}
}

- (UIImage*) getTheDemoImage{
	UIImage* demoImage;
	BOOL c = [DisplayUtils createContextWithSize:self.basicRect.size];
	if(c){
		CGContextRef context = UIGraphicsGetCurrentContext();
		if(context){
			[Colors defaultBgColorForIndex:self.drawerNum];
			UIColor* bgColor = [Colors defaultBgColorForIndex:self.drawerNum];
			UIColor* fgColor = [Colors defaultFgColorForIndex:self.drawerNum];
			CGContextSetFillColorWithColor(context, bgColor.CGColor);
			CGContextFillRect(context, self.basicRect);
			UIBezierPath* swirl = [self getDemoPath];
			CGMutablePathRef path = CGPathCreateMutable();
			for (id transObj in self.transforms) {
				CGAffineTransform trans = [transObj CGAffineTransformValue];
				CGPathAddPath(path, &trans, swirl.CGPath);
			}
			CGContextSetStrokeColorWithColor(context, fgColor.CGColor);
			CGContextSetLineCap(context, kCGLineCapRound);
			CGContextSetLineWidth(context, 10);
			CGContextAddPath(context, path);
			CGContextStrokePath(context);
			demoImage = UIGraphicsGetImageFromCurrentImageContext();
			CGPathRelease(path);
		}
		UIGraphicsEndImageContext();
	}
	return demoImage;
}

- (UIImage*) getTheGridImage{
	CGRect rect = self.basicRect;
	CGMutablePathRef ref = CGPathCreateMutable();
	for(int i = 0;i < self.polyArray.count; i++){
		Polygon* poly = self.polyArray[i];
		CGPathAddPath(ref, NULL, [poly toBezPath].CGPath);
	}
	UIImage* gridImage;
	BOOL c = [DisplayUtils createContextWithSize:rect.size];
	if(c){
		CGContextRef context = UIGraphicsGetCurrentContext();
		if(context){
			CGContextSetShouldAntialias(context, YES);
			UIColor* clr = [Colors getGridColor];
			CGContextAddPath(context, ref);
			CGContextSetLineWidth(context, 1.0);
			CGContextSetStrokeColorWithColor(context, clr.CGColor);
			CGContextDrawPath(context, kCGPathStroke);
			gridImage = UIGraphicsGetImageFromCurrentImageContext();
		}
		UIGraphicsEndImageContext();
	}
	CGPathRelease(ref);
	return gridImage;
}

- (NSArray*) getTheBasicPoints{
	return nil;
}

- (NSArray*) getPolygons{
	NSMutableArray* polyArray = [NSMutableArray array];
	for (id t in self.transforms) {
		CGAffineTransform affineT = [t CGAffineTransformValue];
		[polyArray addObject:[self.basicPolygon applyTransform:affineT]];
	}
	return [polyArray copy];
}

- (NSArray*) getTransformations{
	return nil;
}

- (NSInteger) basicTransForPoint:(CGPoint) p {
	for (int i = 0; i< self.polyArray.count; i++){
		Polygon* poly = [self.polyArray objectAtIndex:i];
		if([poly containsPoint:p]){
			return i;
		}
	}
	return -1;
}

- (NSInteger) polygonIndexForPoint:(CGPoint)p dx:(int*) dx dy:(int*) dy{
	CGPoint mappedPoint = [self pointMapIntoBasicRect:p dx:dx dy:dy];
	return [self basicTransForPoint:mappedPoint];
}

- (CGPoint) pointMapIntoBasicRect:(CGPoint)p dx:(int*) dx dy:(int*) dy{
	float px = p.x;
	float py = p.y;
	int x = 0;
	int y = 0;
	while(px > self.basicRect.size.width){
		px -= self.basicRect.size.width;
		x++;
	}
	while (py > self.basicRect.size.height){
		py -= self.basicRect.size.height;
		y++;
	}
	*dx = x;
	*dy = y;
	return CGPointMake(px, py);
}

- (TileObject*) getTrans:(CGPoint)p{
	int dx;
	int dy;
	CGPoint mappedPoint = [self pointMapIntoBasicRect:p dx:&dx dy:&dy];
	NSInteger transIndex = [self basicTransForPoint:mappedPoint];
	CGAffineTransform fullTrans = CGAffineTransformConcat([self.transforms[transIndex] CGAffineTransformValue], CGAffineTransformMakeTranslation(self.basicRect.size.width*dx, self.basicRect.size.height*dy));
	fullTrans = CGAffineTransformInvert(fullTrans);
	TileObject* trans = [[TileObject alloc] initWithXCoord:dx withYCoord:dy withTransIndex:transIndex withFullTrans:fullTrans];
	return trans;
}

- (NSArray*) getMathTransformBasicCentres{
	return nil;
}

- (void) dealloc{
	self.gridImage = nil;
	self.transforms = nil;
	self.flippedTransforms = nil;
	self.polyArray = nil;
	self.basicPolygon = nil;
	self.basicPoints = nil;
	self.mathImage = nil;
	self.demoImage = nil;
}

@end
