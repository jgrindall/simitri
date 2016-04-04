//
//  ColorCell.m
//  Symmetry
//
//  Created by John on 15/05/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "ColorCell.h"
#import "UIColor+Utils.h"
#import "ImageUtils.h"

@interface ColorCell ()

@property float zoom;
@property UIImage* tick;
@property UIImage* tick2;
@property CGSize imgSize;
@end

@implementation ColorCell

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _zoom = 0.2;
		_imgSize = CGSizeMake(32, 32);
		_tick = [ImageUtils iconWithName:@"right_upsidedown.png" andSize:_imgSize andColor:[UIColor whiteColor]];
		_tick2 = [ImageUtils iconWithName:@"right_upsidedown.png" andSize:_imgSize andColor:[UIColor getGray:0.75]];
		self.clipsToBounds = NO;
    }
    return self;
}

- (void) prepareForReuse{
	[self.layer removeAllAnimations];
}

- (void) deselectMe{
	[self setNeedsDisplay];
}

- (void) selectMe{
	[self.layer removeAllAnimations];
	[UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
		self.transform = CGAffineTransformMakeScale(1 + 2*self.zoom, 1 + 2*self.zoom);
	} completion:^(BOOL finished) {
		[UIView animateWithDuration:0.05 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
			self.transform = CGAffineTransformMakeScale(1 + self.zoom, 1 + self.zoom);
		} completion:^(BOOL finished) {
			[self setNeedsDisplay];
		}];
	}];
}

- (void)drawRect:(CGRect)rect{
	[super drawRect:rect];
	self.transform = CGAffineTransformIdentity;
    CGContextRef context = UIGraphicsGetCurrentContext();
	if([self.color isWhite]){
		CGContextSetLineWidth(context, 1);
		CGContextSetStrokeColorWithColor(context, [UIColor getGray:0.7].CGColor);
	}
	else{
		CGContextSetLineWidth(context, 0);
		CGContextSetStrokeColorWithColor(context, [UIColor clearColor].CGColor);
	}
	CGMutablePathRef ref = CGPathCreateMutable();
	CGContextSetFillColorWithColor(context, [self color].CGColor);
	CGRect cellArea = self.bounds;
	UIBezierPath* roundedRect = [UIBezierPath bezierPathWithRoundedRect: cellArea cornerRadius: 10];
	CGAffineTransform trans;
	if(self.isSelected){
		trans = CGAffineTransformMakeScale(1, 1);
		self.alpha = 1;
	}
	else{
		int d = cellArea.size.width*self.zoom/2;
		trans = CGAffineTransformConcat(CGAffineTransformMakeScale(1 - self.zoom, 1 - self.zoom), CGAffineTransformMakeTranslation(d, d));
		self.alpha = 0.85;
	}
	CGPathAddPath(ref, &trans, roundedRect.CGPath);
	CGContextAddPath(context, ref);
	CGContextFillPath(context);
	CGContextAddPath(context, ref);
	CGContextStrokePath(context);
	if(self.isSelected){
		if([self.color isWhite]){
			CGContextDrawImage(context, CGRectMake((cellArea.size.width - 32)/2, (cellArea.size.height - 32)/2, 32, 32), self.tick2.CGImage);
		}
		else{
			CGContextDrawImage(context, CGRectMake((cellArea.size.width - 32)/2, (cellArea.size.height - 32)/2, 32, 32), self.tick.CGImage);
		}
	}
	CGPathRelease(ref);
}

- (void) dealloc{
	self.tick = nil;
	self.tick2 = nil;
}

@end
