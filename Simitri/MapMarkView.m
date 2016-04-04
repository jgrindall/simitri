//
//  MapMarkView.m
//  Simitri
//
//  Created by John on 12/06/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "MapMarkView.h"
#import "UIColor+Utils.h"

@implementation MapMarkView

- (id)init{
    self = [super init];
    if (self) {
		self.backgroundColor = [UIColor clearColor];
		self.clipsToBounds = NO;
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
	NSInteger s = [MapMarkView defaultSize];
	rect = CGRectMake(0, 0, s, s);
	CGContextRef context = UIGraphicsGetCurrentContext();
	if(context){
		CGContextSetShouldAntialias(context, YES);
		CGContextSetFillColorWithColor(context, [UIColor getGray:0.25].CGColor);
		CGContextAddEllipseInRect(context, CGRectInset(rect, 1, 1));
		CGContextFillPath(context);
	}
}

+ (NSInteger) defaultSize{
	return 15;
}


@end
