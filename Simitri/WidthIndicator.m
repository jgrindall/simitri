//
//  WidthIndicator.m
//  Symmetry
//
//  Created by John on 22/05/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "WidthIndicator.h"
#import "SymmNotifications.h"
#import "AnimationUtils.h"
#import "WidthCircle.h"

@interface WidthIndicator()

@property float width;
@property float prevWidth;
@property WidthCircle* widthCircle;

@end

@implementation WidthIndicator

- (id)initWithWidth:(NSInteger)width{
    self = [super init];
    if (self) {
		self.width = width;
		self.prevWidth = self.width;
		self.widthCircle = [[WidthCircle alloc] init];
		[self addSubview:self.widthCircle];
	}
    return self;
}

- (void) drawRect:(CGRect)rect{
	[self positionCircle:1];
	[self.widthCircle setNeedsDisplay];
}

- (void) positionCircle:(float) scale{
	float w = self.width*scale;
	self.widthCircle.frame = CGRectIntegral(CGRectMake(self.frame.size.width/2 - w, self.frame.size.height/2 - w, 2*w, 2*w));
}

- (void) changeWidth:(float)width{
	float scale ;
	self.prevWidth = self.width;
	self.width = width;
	if(self.width > self.prevWidth){
		scale = 1.2;
	}
	else{
		scale = 0.8;
	}
	[UIView animateWithDuration:0.06 animations:^{
		[self positionCircle:scale];
	} completion:^(BOOL finished) {
		[UIView animateWithDuration:0.1 animations:^{
			[self positionCircle:1];
		} completion:^(BOOL finished) {
			//
		}];
	}];
	[self.widthCircle setNeedsDisplay];
}

- (void) dealloc{
	[self.widthCircle removeFromSuperview];
	self.widthCircle = nil;
}

@end
