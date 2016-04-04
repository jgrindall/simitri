//
//  AlbumButtonsBg.m
//  Symmetry
//
//  Created by John on 09/06/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "RoundRectBg.h"
#import "Colors.h"

@interface RoundRectBg()

@property UIColor* clr;

@end

@implementation RoundRectBg

- (id)initWithFrame:(CGRect)frame withColor:(UIColor*) clr{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
		self.clr = clr;
    }
    return self;
}

- (id)initWithColor:(UIColor*) clr{
	self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
		self.clr = clr;
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
	UIBezierPath* path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:10];
	CGContextRef ref = UIGraphicsGetCurrentContext();
	if(ref){
		CGContextAddPath(ref, path.CGPath);
		CGContextSetFillColorWithColor(ref, self.clr.CGColor);
		CGContextFillPath(ref);
	}
}


@end
