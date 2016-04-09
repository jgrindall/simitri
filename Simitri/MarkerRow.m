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
		self.img = [[MarkerImage alloc] initWithMarker:m withTransforms:transforms];
		self.label = [Appearance labelWithFontSize:SYMM_FONT_SIZE_SMALL];
		self.label.text = label;
		self.label.frame = CGRectMake(LAYOUT_MATH_MARKER_SIZE, 14, LAYOUT_INFO_WIDTH, 20);
		[self addSubview:self.label];
		[self addSubview:self.img];
		self.img.frame = CGRectMake(0, 0, LAYOUT_MATH_MARKER_SIZE, LAYOUT_MATH_MARKER_SIZE);
	}
	return self;
}


@end
