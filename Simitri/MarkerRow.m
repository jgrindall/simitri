//
//  MarkerImage.m
//  Simitri
//
//  Created by John on 15/06/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "MarkerRow.h"
#import "Appearance.h"
#import "LayoutConsts.h"
#import "MarkerImage.h"

@interface MarkerRow()

@property MarkerImage* img;
@property UILabel* label;

@end

@implementation MarkerRow

- (id) initWithMarker:(AMathMarker*) m withTransforms:(NSArray*) transforms withLabel:(NSString*)label{
	self = [super init];
	if(self){
		//self.img = [[MarkerImage alloc] initWithMarker:m withTransforms:transforms];
		//self.label = [Appearance labelWithFontSize:SYMM_FONT_SIZE_SMALL];
		//self.label.text = label;
		//[self addSubview:self.label];
		if(arc4random_uniform(2) < 1){
			self.backgroundColor = [UIColor redColor];
		}
		else{
			self.backgroundColor = [UIColor greenColor];
		}
		//[self addSubview:self.img];
		//[self layoutImg];
		//[self layoutLabel];
	}
	return self;
}

- (void) layoutLabel{
	self.label.translatesAutoresizingMaskIntoConstraints = NO;
	NSLayoutConstraint* c1 = [NSLayoutConstraint constraintWithItem:self.label attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0];
	NSLayoutConstraint* c2 = [NSLayoutConstraint constraintWithItem:self.label attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
	NSLayoutConstraint* c3 = [NSLayoutConstraint constraintWithItem:self.label attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1 constant:LAYOUT_MATH_MARKER_SIZE + 5];
	NSLayoutConstraint* c4 = [NSLayoutConstraint constraintWithItem:self.label attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
	[self addConstraints:@[c1, c2, c3, c4]];
}

- (void) layoutImg{
	self.img.translatesAutoresizingMaskIntoConstraints = NO;
	NSLayoutConstraint* c1 = [NSLayoutConstraint constraintWithItem:self.img attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0];
	NSLayoutConstraint* c2 = [NSLayoutConstraint constraintWithItem:self.img attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:LAYOUT_MATH_MARKER_SIZE];
	NSLayoutConstraint* c3 = [NSLayoutConstraint constraintWithItem:self.img attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
	NSLayoutConstraint* c4 = [NSLayoutConstraint constraintWithItem:self.img attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:LAYOUT_MATH_MARKER_SIZE];
	[self addConstraints:@[c1, c2, c3, c4]];
}


@end
