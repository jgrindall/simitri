//
//  FileCell.m
//  Symmetry
//
//  Created by John on 20/05/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "FileCell.h"
#import "TilesCollectionController.h"
#import "DisplayUtils.h"
#import "AnimationUtils.h"
#import "ADeleteableController.h"
#import "UIColor+Utils.h"
#import "ImageUtils.h"
#import "LayoutConsts.h"
#import "PolaroidView.h"

@interface FileCell()

@property UIView* imageView;

@end

@implementation FileCell

static UIImage* addNewImg = nil;
@synthesize image = _image;
@synthesize isAddNew = _isAddNew;

- (void)prepareForReuse{
	[super prepareForReuse];
	[self.imageView removeFromSuperview];
	self.imageView = nil;
	_isAddNew = NO;
}

- (void) setIsZoomed:(BOOL)isZoomed{
	if(self.isAddNew){
		super.isZoomed = NO;
	}
	else{
		super.isZoomed = isZoomed;
	}
}

- (void) setIsDeleteShown:(BOOL)isDeleteShown{
	if(self.isAddNew){
		super.isDeleteShown = NO;
	}
	else{
		super.isDeleteShown = isDeleteShown;
	}
}

- (void) setIsHighlighted:(BOOL)isHighlighted{
	if(self.isAddNew){
		super.isHighlighted = NO;
	}
	else{
		super.isHighlighted = isHighlighted;
	}
}

- (void) setIsAnimating:(BOOL)isAnimating{
	if(self.isAddNew){
		super.isAnimating = NO;
	}
	else{
		super.isAnimating = isAnimating;
	}
}

-  (void) setImage:(UIImage *)img{
	_image = img;
	[self update];
}

+ (UIImage*) getAddNewImg{
	if(!addNewImg){
		CGSize size = CGSizeMake(LAYOUT_FILE_THUMB_SIZE, LAYOUT_FILE_THUMB_SIZE);
		BOOL c = [DisplayUtils createContextWithSize:size];
		if(c){
			CGContextRef context = UIGraphicsGetCurrentContext();
			if(context){
				CGSize tickSize= CGSizeMake(80, 80);
				CGRect tickRect = CGRectMake((LAYOUT_FILE_THUMB_SIZE - tickSize.width)/2, (LAYOUT_FILE_THUMB_SIZE - tickSize.height)/2, tickSize.width, tickSize.height);
				UIImage* plus = [ImageUtils iconWithName:@"plus.png" andSize:tickSize];
				CGContextDrawImage(context, tickRect, plus.CGImage);
				CGFloat dashPhase = 0.0;
				CGFloat dashLengths[] = {7.0, 7.0};
				CGContextSetLineDash(context, dashPhase, dashLengths, 2);
				CGRect r = CGRectInset( CGRectMake(0, 0, size.width, size.height), 10, 10);
				UIBezierPath* roundRect = [UIBezierPath bezierPathWithRoundedRect: r cornerRadius: 20];
				CGContextAddPath(context, roundRect.CGPath);
				CGContextSetStrokeColorWithColor(context, [Colors symmGrayButtonColor].CGColor);
				CGContextSetLineWidth(context, 5);
				CGContextStrokePath(context);
				addNewImg = UIGraphicsGetImageFromCurrentImageContext();
			}
			UIGraphicsEndImageContext();
		}
	}
	return addNewImg;
}

- (void) setIsAddNew:(BOOL)isAddNew{
	_isAddNew = isAddNew;
	if(isAddNew){
		self.isZoomed = NO;
		self.isHighlighted = NO;
		self.isDeleteShown = NO;
		self.isAnimating = NO;
	}
	[self update];
}

-  (void) addImageView{
	if(self.imageView){
		[self.imageView removeFromSuperview];
		self.imageView = nil;
	}
	if(self.isAddNew){
		self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
	}
	else{
		self.imageView = [[PolaroidView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) hasDes:NO];
	}
	[self addSubview:self.imageView];
}

- (void) setImages{
	if(self.isAddNew){
		((UIImageView*)self.imageView).image = [FileCell getAddNewImg];
	}
	else if(self.image){
		[(PolaroidView*)(self.imageView) loadImage:self.image withDescription:@"Des"];
	}
}

- (void) update{
	[super update];
	[self addImageView];
	[self setImages];
	[self bringSubviewToFront:self.delButton];
}

- (void) teardown{
	[super teardown];
}

- (void) dealloc{
	[super teardown];
	[self.imageView removeFromSuperview];
	self.imageView = nil;
}

@end
