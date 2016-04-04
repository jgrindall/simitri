//
//  Line.m
//  Symmetry
//
//  Created by John on 16/05/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "Line.h"
#import "Colors.h"
#import "DrawingConfig.h"

@interface Line ()

@property CGPoint endPoint;
@property CGPoint prevEndPoint;

@end

@implementation Line
{
	CGMutablePathRef _wholePath;
	CGMutablePathRef _path;
}

- (id) initWithColor: (UIColor*) color withWidth :(NSInteger) width withAlpha:(NSNumber*)alpha{
	self = [super init];
	if(self){
		_width = width;
		_alpha = alpha;
		_color = color;
		_count = 1;
		_path = CGPathCreateMutable();
		_wholePath = CGPathCreateMutable();
	}
	return self;
}

- (void) setPath:(CGMutablePathRef) p{
	
}

- (void) setWholePath:(CGMutablePathRef) w{
	
}

- (CGMutablePathRef) getPath{
	return _path;
}

- (CGMutablePathRef) getWhole{
	return _wholePath;
}

- (void) cached{
	[self initPathAt:self.endPoint];
}

- (void) startAtPoint:(CGPoint) p{
	[self initPathAt:p];
	CGPathMoveToPoint(_wholePath, NULL, p.x, p.y);
	self.count = 1;
}

- (void) initPathAt:(CGPoint)p{
	if (_path){
        CGPathRelease(_path);
        _path = NULL;
    }
	_path = CGPathCreateMutable();
	CGPathMoveToPoint(_path, NULL, p.x, p.y);
	self.prevEndPoint = p;
	self.endPoint = p;
}

- (void) addCurveToPoint:(CGPoint) p3 controlPoint1:(CGPoint)p1 controlPoint2: (CGPoint)p2{
	self.count++;
	CGPathAddCurveToPoint(_path, NULL, p1.x, p1.y, p2.x, p2.y, p3.x, p3.y);
	CGPathAddCurveToPoint(_wholePath, NULL,  p1.x, p1.y, p2.x, p2.y, p3.x, p3.y);
	self.prevEndPoint = self.endPoint;
	self.endPoint = p3;
}

- (void)encodeWithCoder:(NSCoder *)coder{
	CGPathRef persistentPath = CGPathCreateCopy(_wholePath);
	UIBezierPath * bezierPath = [UIBezierPath bezierPathWithCGPath:persistentPath];
    [coder encodeObject:bezierPath forKey:@"wholePath"];
	[coder encodeObject:self.color forKey:@"color"];
	[coder encodeObject:[NSNumber numberWithInteger:self.width] forKey:@"width"];
	CGPathRelease(persistentPath);
}

- (id)initWithCoder:(NSCoder *)aDecoder{
	self = [super init];
	if(self){
		UIBezierPath* bezierPath = (UIBezierPath*)[aDecoder decodeObjectForKey:@"wholePath"];
		if(!bezierPath){
			bezierPath = [UIBezierPath bezierPath];
		}
		_wholePath = CGPathCreateMutableCopy(bezierPath.CGPath);
		self.color = (UIColor*)[aDecoder decodeObjectForKey:@"color"];
		self.width = (NSInteger)[[aDecoder decodeObjectForKey:@"width"] integerValue];
	}
	return self;
}

- (void) dealloc{
	self.color = nil;
	if(_wholePath){
		CGPathRelease(_wholePath);
	}
	if(_path){
		CGPathRelease(_path);
	}
}

@end
