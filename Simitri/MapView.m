//
//  MapView.m
//  Simitri
//
//  Created by John on 12/06/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "MapView.h"
#import "MapMarkView.h"
#import "LayoutConsts.h"
#import "Appearance.h"
#import "LayoutConsts.h"
#import "DisplayUtils.h"
#import "GeoService.h"
#import "UIColor+Utils.h"
#import "ImageUtils.h"
#import "GeomUtils.h"

@interface MapView()
@property UIImageView* imgView;
@property UILabel* label;
@property MapMarkView* markView;
@property CGPoint xyPosition;
@property CGPoint geoLocation;
@property NSString* country;
@end

@implementation MapView

- (id)init{
    self = [super init];
    if (self) {
		self.backgroundColor = [UIColor clearColor];
		[self addAll];
		[self layoutImg];
    }
    return self;
}

- (void) addAll{
	self.imgView = [[UIImageView alloc] init];
	self.markView = [[MapMarkView alloc] init];
	self.label = [[UILabel alloc] init];
	self.label.font = [Appearance fontOfSize:SYMM_FONT_SIZE_V_SMALL];
	self.label.textColor = [UIColor getGray:0.0];
	self.label.backgroundColor = [UIColor whiteColor];
	self.label.textAlignment = NSTextAlignmentCenter;
	self.label.alpha = 1.0;
	self.geoLocation = CGPointZero;
	[self addSubview:self.imgView];
	[self addSubview:self.markView];
	[self addSubview:self.label];
	self.imgView.contentMode = UIViewContentModeScaleAspectFit;
	self.imgView.image = [ImageUtils loadImageNamed:@"world.png"];
}


- (void) layoutSubviews{
	[super layoutSubviews];
	[self refresh];
}

- (CGPoint) getPointFromLatLong:(CGPoint)p{
	CGRect imageFrame = [GeomUtils getFrameForImageWidth:(float)LAYOUT_WORLD_WIDTH andHeight:(float)LAYOUT_WORLD_HEIGHT inRect:self.frame.size];
	int cx = imageFrame.origin.x + imageFrame.size.width/2;
	int cy = imageFrame.origin.y + imageFrame.size.height/2;
	int x = cx + (p.y / 180) * imageFrame.size.width/2;
	int y = cy - (p.x / 90) * imageFrame.size.height/2;
	return CGPointMake(x, y);
}

- (void) positionCircle:(float) scale{
	float w = [MapMarkView defaultSize]*scale;
	CGRect rect = CGRectMake(self.xyPosition.x - w/2, self.xyPosition.y - w/2, w, w);
	self.markView.frame = rect;
	[self.markView setNeedsDisplay];
	CGRect labelFrame = CGRectMake(rect.origin.x - (LAYOUT_MAP_LABEL_WIDTH - rect.size.width)/2, rect.origin.y - LAYOUT_MAP_LABEL_HEIGHT, LAYOUT_MAP_LABEL_WIDTH, LAYOUT_MAP_LABEL_HEIGHT);
	labelFrame = [DisplayUtils fitFrame:labelFrame inView:self];
	self.label.frame = CGRectIntegral(labelFrame);
}

- (void) refresh{
	[self.layer removeAllAnimations];
	self.label.text = self.country;
	self.xyPosition = [self getPointFromLatLong:self.geoLocation];
	[self positionCircle:0];
	[UIView animateWithDuration:0.25 animations:^{
		[self positionCircle:1];
	} completion:^(BOOL finished) {
		
	}];
}

-  (void) mark:(CGPoint) p withLabel:(NSString*) name{
	self.geoLocation = p;
	self.country = name;
	[self refresh];
}

- (void) layoutImg{
	self.imgView.translatesAutoresizingMaskIntoConstraints = NO;
	NSLayoutConstraint* c1 = [NSLayoutConstraint constraintWithItem:self.imgView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0];
	NSLayoutConstraint* c2 = [NSLayoutConstraint constraintWithItem:self.imgView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
	NSLayoutConstraint* c3 = [NSLayoutConstraint constraintWithItem:self.imgView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
	NSLayoutConstraint* c4 = [NSLayoutConstraint constraintWithItem:self.imgView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
	[self addConstraints:@[c1, c2, c3, c4]];
}

- (void) dealloc{
	self.imgView.image = nil;
	[self.imgView removeFromSuperview];
	self.imgView = nil;
	[self.markView removeFromSuperview];
	self.markView = nil;
}

@end
