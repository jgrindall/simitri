//
//  WidthCircle.m
//  Symmetry
//
//  Created by John on 04/06/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "WidthCircle.h"
#import "UIColor+Utils.h"
#import "Colors.h"

@interface WidthCircle()

@end

@implementation WidthCircle

- (id)init{
    self = [super init];
    if (self) {
		self.backgroundColor = [UIColor clearColor];
		self.clipsToBounds = NO;
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetShouldAntialias(context, YES);
	CGContextSetFillColorWithColor(context, [Colors symmGrayTextColor].CGColor);
	CGContextAddEllipseInRect(context, CGRectInset(rect, 1, 1));
	CGContextFillPath(context);
}


@end
