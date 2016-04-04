//
//  PolView.m
//  PolTest
//
//  Created by John on 27/06/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "PolaroidView.h"
#import "ImageUtils.h"
#import "DisplayUtils.h"
#import "UIColor+Utils.h"
#import "Appearance.h"
#import "GeomUtils.h"

@interface PolaroidView()

@property UIImage* img;
@property NSString* desc;
@property UIImageView* imgView;
@property UITextView* label;
@property BOOL hasDes;
@property CGRect contentFrame;

@end

@implementation PolaroidView

{
	float borderWidth;
	float cornerRadius;
	float shadowHeight;
	float textHeight;
}

static UIImage* blurImg = nil;

- (id) initWithFrame:(CGRect)frame hasDes:(BOOL)hasDes{
	self = [super initWithFrame:frame];
	if(self){
		self.hasDes = hasDes;
		self.backgroundColor = [UIColor clearColor];
		_imgView = [[UIImageView alloc] init];
		_imgView.contentMode = UIViewContentModeScaleAspectFit;
		[self addSubview:_imgView];
		if(hasDes){
			_label = [Appearance textViewWithFontSize:SYMM_FONT_SIZE_SMALL];
			_label.textAlignment = NSTextAlignmentCenter;
			[_label setText:_desc];
			[self addSubview:_label];
		}
	}
	return self;
}

- (void) layoutSubviews{
	[super layoutSubviews];
	[self getFrameForRect:self.frame];
	[self setNeedsDisplay];
}

- (void) loadImage:(UIImage*) img withDescription:(NSString*) desc{
	self.img = img;
	self.imgView.image = img;
	self.desc = desc;
	if(self.label){
		self.label.text = desc;
	}
	borderWidth = MAX(floorf(MAX(img.size.width, img.size.height)/120) * 5, 5);
	cornerRadius = 10;
	shadowHeight = borderWidth/3;
	textHeight = 45;
	[self getFrameForRect:self.frame];
	[self setNeedsDisplay];
}

- (float) getContentWidth{
	float contentWidth = self.img.size.width + 2*borderWidth;
	return contentWidth;
}

- (float) getContentHeight{
	float contentHeight = self.img.size.height + 2*borderWidth + shadowHeight;
	if(self.hasDes){
		contentHeight += textHeight;
	}
	return  contentHeight;
}

- (void) getFrameForRect:(CGRect)rect{
	float contentWidth = [self getContentWidth];
	float contentHeight = [self getContentHeight];
	self.contentFrame = [GeomUtils getFrameForImageWidth:contentWidth andHeight:contentHeight inRect:rect.size];
}

- (void) drawRect:(CGRect)rect{
	if(self.img){
		[self getFrameForRect:self.frame];
		[self layoutImage];
		[self layoutLabel];
		CGContextRef ref = UIGraphicsGetCurrentContext();
		if(ref){
			CGRect whiteRect = CGRectMake(self.contentFrame.origin.x, self.contentFrame.origin.y, self.contentFrame.size.width, self.contentFrame.size.height - shadowHeight);
			CGRect blurRect = CGRectMake(self.contentFrame.origin.x, self.contentFrame.origin.y + self.contentFrame.size.height - shadowHeight, self.contentFrame.size.width, shadowHeight);
			UIImage* blur = [PolaroidView getBlurImg];
			[blur drawInRect:blurRect];
			UIBezierPath* white = [UIBezierPath bezierPathWithRoundedRect:whiteRect cornerRadius:cornerRadius];
			CGContextSetFillColorWithColor(ref,[UIColor whiteColor].CGColor);
			CGContextAddPath(ref, white.CGPath);
			CGContextFillPath(ref);
		}
	}
}

+ (UIImage*) getBlurImg{
	if(!blurImg){
		float shadowHeight = 8;
		float w = 242;
		CGSize size = CGSizeMake(w, shadowHeight);
		BOOL c = [DisplayUtils createContextWithSize:size];
		if(c){
			CGContextRef ref = UIGraphicsGetCurrentContext();
			if(ref){
				UIBezierPath* blur = [UIBezierPath bezierPath];
				[blur moveToPoint:CGPointMake(0, 0)];
				[blur addLineToPoint:CGPointMake(shadowHeight, shadowHeight)];
				[blur addQuadCurveToPoint:CGPointMake(w/2, 0) controlPoint:CGPointMake(shadowHeight, 0)];
				[blur addQuadCurveToPoint:CGPointMake(w - shadowHeight, shadowHeight) controlPoint:CGPointMake(w - shadowHeight, 0)];
				[blur addLineToPoint:CGPointMake(w, 0)];
				[blur addLineToPoint:CGPointMake(0, 0)];
				CGContextSetFillColorWithColor(ref, [UIColor getGray:0.6 withAlpha:0.7].CGColor);
				CGContextAddPath(ref, blur.CGPath);
				CGContextFillPath(ref);
				blurImg = UIGraphicsGetImageFromCurrentImageContext();
				blurImg = [ImageUtils blur:blurImg];
			}
			UIGraphicsEndImageContext();
		}
	}
	return blurImg;
}

- (void) layoutImage{
	float w = self.contentFrame.size.width - 2*borderWidth;
	float h = self.img.size.height*(w/self.img.size.width);
	self.imgView.frame = CGRectIntegral(CGRectMake(self.contentFrame.origin.x + borderWidth, self.contentFrame.origin.y + borderWidth, w, h));
}

- (void) layoutLabel{
	if(self.label){
		float w = self.contentFrame.size.width - 2*borderWidth;
		self.label.frame = CGRectIntegral(CGRectMake(self.contentFrame.origin.x + borderWidth, self.contentFrame.origin.y + self.contentFrame.size.height - shadowHeight - textHeight, w, textHeight));
	}
}

- (void) dealloc{
	self.imgView.image = nil;
	[self.imgView removeFromSuperview];
	self.imgView = nil;
	self.img = nil;
	if(self.label){
		[self.label removeFromSuperview];
		self.label = nil;
	}
}

@end


