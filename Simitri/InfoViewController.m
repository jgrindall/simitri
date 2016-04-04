//
//  InfoViewController.m
//  Simitri
//
//  Created by John on 13/06/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "DrawingScreenController.h"
#import "InfoViewController.h"
#import "PDrawingAnimator.h"
#import "TransformUtils.h"
#import "LayoutConsts.h"
#import "DisplayUtils.h"
#import "AMathMarker.h"
#import "Appearance.h"
#import "ImageUtils.h"
#import "MarkerRow.h"
#import "SoundManager.h"

@interface InfoViewController ()

@property NSMutableArray* rows;
@property UIButton* closeButton;

@end

@implementation InfoViewController

- (void)viewDidLoad{
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor whiteColor];
	self.rows = [NSMutableArray array];
	[self addMarkers];
	[self addClose];
	[self layoutClose];
	[self layoutMarkers];
}

-  (void) addMarkers{
	[self addRot6];
	[self addRot4];
	[self addRot3];
	[self addRot2];
	[self addTrans];
	[self addRef];
	[self addGlideRef];
}

- (void) addClose{
	UIImage* iconImg = [ImageUtils iconWithName:@"multiply 2.png" andSize:CGSizeMake(30,30)];
	self.closeButton = [UIButton buttonWithType:UIButtonTypeSystem];
	self.closeButton.tintColor = [Colors symmGrayButtonColor];
	[self.closeButton setTitle:@" " forState:UIControlStateNormal];
	[self.closeButton setImage:iconImg forState:UIControlStateNormal];
	[self.closeButton addTarget:self action:@selector(clickClose) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:self.closeButton];
}

- (void) clickClose{
	[[SoundManager sharedInstance] playClick];
	[DisplayUtils bubbleActionFrom:self toProtocol:@protocol(PDrawingAnimator) withSelector:@"clickClose" withObject:nil];
}

- (void) layoutMarkers{
	UIView* v;
	NSLayoutConstraint* c1;
	NSLayoutConstraint* c2;
	NSLayoutConstraint* c3;
	NSLayoutConstraint* c4;
	for(int i = 0; i< self.rows.count; i++){
		v = (UIView*)self.rows[i];
		v.translatesAutoresizingMaskIntoConstraints = NO;
		c1 = [NSLayoutConstraint constraintWithItem:v attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:10 + LAYOUT_DEFAULT_MAKER_HEIGHT * i];
		c2 = [NSLayoutConstraint constraintWithItem:v attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
		c3 = [NSLayoutConstraint constraintWithItem:v attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
		c4 = [NSLayoutConstraint constraintWithItem:v attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:LAYOUT_DEFAULT_MAKER_HEIGHT];
		[self.view addConstraints:@[c1, c2, c3, c4]];
	}
}

- (void)didReceiveMemoryWarning{
	[super didReceiveMemoryWarning];
}

- (void) layoutClose{
	self.closeButton.translatesAutoresizingMaskIntoConstraints = NO;
	NSLayoutConstraint* c1 = [NSLayoutConstraint constraintWithItem:self.closeButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0];
	NSLayoutConstraint* c2 = [NSLayoutConstraint constraintWithItem:self.closeButton attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
	NSLayoutConstraint* c3 = [NSLayoutConstraint constraintWithItem:self.closeButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:30];
	NSLayoutConstraint* c4 = [NSLayoutConstraint constraintWithItem:self.closeButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:30];
	[self.view addConstraints:@[c1, c2, c3, c4]];
}

- (void) addRow:(AMathMarker*) marker withTransforms:(NSArray*) transforms withLabel:(NSString*) label{
	MarkerRow* r = [[MarkerRow alloc] initWithMarker:marker withTransforms:transforms withLabel:label];
	[self.rows addObject:r];
	[self.view addSubview:r];
}

- (void) addRot6{
	CGPoint centre = CGPointMake(LAYOUT_MATH_MARKER_SIZE/2, LAYOUT_MATH_MARKER_SIZE/2);
	NSMutableArray* transforms = [NSMutableArray array];
	[transforms addObject:[NSValue valueWithCGAffineTransform:CGAffineTransformIdentity]];
	[transforms addObject:[NSValue valueWithCGAffineTransform:[TransformUtils rotateAboutPoint:centre angle:M_PI/3]]];
	[transforms addObject:[NSValue valueWithCGAffineTransform:[TransformUtils rotateAboutPoint:centre angle:2*M_PI/3]]];
	[transforms addObject:[NSValue valueWithCGAffineTransform:[TransformUtils rotateAboutPoint:centre angle:3*M_PI/3]]];
	[transforms addObject:[NSValue valueWithCGAffineTransform:[TransformUtils rotateAboutPoint:centre angle:4*M_PI/3]]];
	[transforms addObject:[NSValue valueWithCGAffineTransform:[TransformUtils rotateAboutPoint:centre angle:5*M_PI/3]]];
	AMathMarker* mark = [AMathMarker getRotOrder346CentrePolygonWithOrigin:centre withP1:CGPointZero andAngle:M_PI/3 andOrder:6 andLength:[AMathMarker getDefaultLength]*0.7];
	[self addRow:mark withTransforms:[transforms copy] withLabel:@"Centre of rotation of order 6"];
}

- (void) addRot4{
	CGPoint centre = CGPointMake(LAYOUT_MATH_MARKER_SIZE/2, LAYOUT_MATH_MARKER_SIZE/2);
	NSMutableArray* transforms = [NSMutableArray array];
	[transforms addObject:[NSValue valueWithCGAffineTransform:CGAffineTransformIdentity]];
	[transforms addObject:[NSValue valueWithCGAffineTransform:[TransformUtils rotateAboutPoint:centre angle:M_PI/2]]];
	[transforms addObject:[NSValue valueWithCGAffineTransform:[TransformUtils rotateAboutPoint:centre angle:M_PI]]];
	[transforms addObject:[NSValue valueWithCGAffineTransform:[TransformUtils rotateAboutPoint:centre angle:3*M_PI/2]]];
	AMathMarker* mark = [AMathMarker getRotOrder346CentrePolygonWithOrigin:centre withP1:CGPointZero andAngle:M_PI/2 andOrder:4 andLength:[AMathMarker getDefaultLength]*0.7];
	[self addRow:mark withTransforms:[transforms copy] withLabel:@"Centre of rotation of order 4"];
}

- (void) addRot3{
	CGPoint centre = CGPointMake(LAYOUT_MATH_MARKER_SIZE/2, LAYOUT_MATH_MARKER_SIZE/2);
	NSMutableArray* transforms = [NSMutableArray array];
	[transforms addObject:[NSValue valueWithCGAffineTransform:CGAffineTransformIdentity]];
	[transforms addObject:[NSValue valueWithCGAffineTransform:[TransformUtils rotateAboutPoint:centre angle:2*M_PI/3]]];
	[transforms addObject:[NSValue valueWithCGAffineTransform:[TransformUtils rotateAboutPoint:centre angle:4*M_PI/3]]];
	AMathMarker* mark = [AMathMarker getRotOrder346CentrePolygonWithOrigin:centre withP1:CGPointZero andAngle:2*M_PI/3 andOrder:3 andLength:[AMathMarker getDefaultLength]*0.7];
	[self addRow:mark withTransforms:[transforms copy] withLabel:@"Centre of rotation of order 3"];
}

- (void) addRot2{
	NSMutableArray* transforms = [NSMutableArray array];
	CGPoint centre = CGPointMake(LAYOUT_MATH_MARKER_SIZE/2, LAYOUT_MATH_MARKER_SIZE/2);
	[transforms addObject:[NSValue valueWithCGAffineTransform:CGAffineTransformIdentity]];
	[transforms addObject:[NSValue valueWithCGAffineTransform:[TransformUtils rotateAboutPoint:centre angle:M_PI]]];
	AMathMarker* mark = [AMathMarker getRotOrder2CentrePolygonWithOrigin:centre withStartAngle:0 andAngle:2*M_PI andRadius:[AMathMarker getDefaultRot2Radius]*0.8 ];
	[self addRow:mark withTransforms:[transforms copy] withLabel:@"Centre of rotation of order 2"];
}

- (void) addRef{
	NSMutableArray* transforms = [NSMutableArray array];
	CGPoint p0 = CGPointMake(12, LAYOUT_MATH_MARKER_SIZE/2);
	[transforms addObject:[NSValue valueWithCGAffineTransform:CGAffineTransformIdentity]];
	AMathMarker* mark = [AMathMarker getLineOfReflectionWithP0:p0 withP1:CGPointMake(LAYOUT_MATH_MARKER_SIZE - 10, LAYOUT_MATH_MARKER_SIZE/2) withP3Angle:M_PI/2];
	[self addRow:mark withTransforms:[transforms copy] withLabel:@"Axis of reflection"];
}

- (void) addTrans{
	NSMutableArray* transforms = [NSMutableArray array];
	CGPoint centre = CGPointMake(LAYOUT_MATH_MARKER_SIZE/2, LAYOUT_MATH_MARKER_SIZE/2);
	[transforms addObject:[NSValue valueWithCGAffineTransform:CGAffineTransformIdentity]];
	AMathMarker* mark = [AMathMarker getTranslationWithOrigin:centre withP1:CGPointMake(LAYOUT_MATH_MARKER_SIZE, centre.y) withMiddle:centre withScale:0.65 withMove:NO];
	[self addRow:mark withTransforms:[transforms copy] withLabel:@"Translation"];
}

- (void) addGlideRef{
	NSMutableArray* transforms = [NSMutableArray array];
	CGPoint centre = CGPointMake(LAYOUT_MATH_MARKER_SIZE/2, LAYOUT_MATH_MARKER_SIZE/2);
	[transforms addObject:[NSValue valueWithCGAffineTransform:CGAffineTransformIdentity]];
	AMathMarker* mark = [AMathMarker getGlideRefWithOrigin:centre withP1:CGPointMake(LAYOUT_MATH_MARKER_SIZE, centre.y) withMiddle:centre withScale:0.65 withMove:NO];
	[self addRow:mark withTransforms:[transforms copy] withLabel:@"Glide reflection"];
}

- (void) enableButtons:(NSArray*) enable{
	
}

-  (void) dealloc{
	[self.closeButton removeTarget:self action:@selector(clickClose) forControlEvents:UIControlEventTouchUpInside];
}

@end
