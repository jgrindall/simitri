//
//  TransformPair.m
//  Symmetry
//
//  Created by John on 23/06/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "TransformPair.h"

@implementation TransformPair

- (id) init{
	self = [super init];
	if(self){
		self.is3d = NO;
		self.ca3dTransform = CATransform3DIdentity;
		self.affineTransform = CGAffineTransformIdentity;
	}
	return self;
}

- (id) initWithCA:(CATransform3D) ca withCG:(CGAffineTransform) cg{
	self = [super init];
	if(self){
		self.is3d = NO;
		self.ca3dTransform = ca;
		self.affineTransform = cg;
	}
	return self;
}

- (id) initWithCA:(CATransform3D) ca withCG:(CGAffineTransform) cg is3d:(BOOL)is3d{
	self = [super init];
	if(self){
		self.is3d = is3d;
		self.ca3dTransform = ca;
		self.affineTransform = cg;
	}
	return self;
}

@end
