//
//  ADeleteableCell.m
//  Symmetry
//
//  Created by John on 20/05/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "ADeleteableCell.h"
#import "AnimationUtils.h"
#import "ImageUtils.h"
#import "UIColor+Utils.h"
#import "DisplayUtils.h"
#import "ADeleteableController.h"
#import "SoundManager.h"

@implementation ADeleteableCell

@synthesize isAnimating = _isAnimating;
@synthesize isDeleteShown = _isDeleteShown;
@synthesize isHighlighted = _isHighlighted;
@synthesize isZoomed = _isZoomed;

- (void)prepareForReuse{
	_isDeleteShown = NO;
	_isAnimating = NO;
	_isDeleteShown = NO;
	_isZoomed = NO;
	_isHighlighted = NO;
	[self teardown];
}

- (void) setIsZoomed:(BOOL)isZoomed{
	_isZoomed = isZoomed;
	[self update];
}

- (void) setIsAnimating:(BOOL)isAnimating{
	_isAnimating = isAnimating;
	[self update];
}

- (void) setIsHighlighted:(BOOL)isHighlighted{
	_isHighlighted = isHighlighted;
	[self update];
}

- (void) setIsDeleteShown:(BOOL)isDeleteShown{
	_isDeleteShown = isDeleteShown;
	[self update];
}

- (void) teardown{
	[self.layer removeAllAnimations];
	if(self.delButton){
		[self.delButton removeFromSuperview];
		[self.delButton removeTarget:self action:@selector(delClick) forControlEvents:UIControlEventTouchUpInside];
		self.delButton = nil;
	}
}

- (void) delClick{
	[[SoundManager sharedInstance] playClick];
	[DisplayUtils bubbleActionFrom:self toClass:[ADeleteableController class] withSelector:@"deleteClicked:" withObject:self];
}

- (void) addDelButton{
	if(!self.delButton){
		self.delButton = [UIButton buttonWithType:UIButtonTypeCustom];
		[self.delButton setTitle:@" " forState:UIControlStateNormal];
		int buttonSize = 30;
		UIImage* iconImg = [ImageUtils iconWithName:@"multiply 2.png" andSize:CGSizeMake(buttonSize,buttonSize) andColor:[UIColor getGray:0.75]];
		[self.delButton setImage:iconImg forState:UIControlStateNormal];
		self.delButton.frame = CGRectIntegral(CGRectMake(self.frame.size.width - 30, -5, 40, 40));
		[self.delButton addTarget:self action:@selector(delClick) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:self.delButton];
	}
}

- (void) update{
	[self teardown];
	[self addDelButton];
	if(_isHighlighted && _isAnimating){
		[AnimationUtils addZoomAndWiggleTo:self];
	}
	else if(_isAnimating){
		[AnimationUtils addWiggleTo:self];
	}
	else if(_isHighlighted){
		[AnimationUtils addZoomTo:self];
	}
	[self.delButton setHidden:!self.isDeleteShown];
}

- (void) dealloc{
	[self teardown];
}

@end
