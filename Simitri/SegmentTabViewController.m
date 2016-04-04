//
//  FlexiTabViewController.m
//  FileManager
//
//  Created by John on 26/05/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "SegmentTabViewController.h"
#import "Appearance.h"
#import "PFileViewer.h"
#import "LayoutConsts.h"

@interface SegmentTabViewController ()

@property UISegmentedControl * segments;
@property NSArray* leftImages;
@property NSArray* rightImages;

@end

@implementation SegmentTabViewController
{
	int segWidth;
}

- (id) initWithTitles:(NSArray*)titles{
	if (self) {
		segWidth = 60;
		_leftImages = titles[0];
		_rightImages = titles[1];
	}
	return self;
}

- (void) showSegments:(BOOL) show{
	[self.segments setHidden:!show];
}

- (void)didReceiveMemoryWarning{
	[super didReceiveMemoryWarning];
}

- (void)viewDidLoad{
    [super viewDidLoad];
	[self addSeg];
	[self showSegments:NO];
	[self layoutSeg];
	[self showChild:0];
}

- (void) layoutContainer{
	self.container.translatesAutoresizingMaskIntoConstraints = NO;
	NSLayoutConstraint* c1 = [NSLayoutConstraint constraintWithItem:self.container attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:LAYOUT_TAB_HEIGHT];
	NSLayoutConstraint* c2 = [NSLayoutConstraint constraintWithItem:self.container attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
	NSLayoutConstraint* c3 = [NSLayoutConstraint constraintWithItem:self.container attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
	NSLayoutConstraint* c4 = [NSLayoutConstraint constraintWithItem:self.container attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
	[self.view addConstraints:@[c1, c2, c3, c4]];
}

- (void) addSeg{
	self.segments = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"1", @"2", nil]];
	self.segments.tintColor = [UIColor clearColor];
	[self.segments setWidth:segWidth forSegmentAtIndex:0];
	[self.segments setWidth:segWidth forSegmentAtIndex:1];
	[self.segments addTarget:self action:@selector(selectedSegment) forControlEvents:UIControlEventValueChanged];
	[self.view addSubview:self.segments];
	[self showButtons:0];
}

- (void) layoutSeg{
	self.segments.translatesAutoresizingMaskIntoConstraints = NO;
	NSLayoutConstraint* c1 = [NSLayoutConstraint constraintWithItem:self.segments attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0];
	NSLayoutConstraint* c2 = [NSLayoutConstraint constraintWithItem:self.segments attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
	NSLayoutConstraint* c3 = [NSLayoutConstraint constraintWithItem:self.segments attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:2*segWidth];
	NSLayoutConstraint* c4 = [NSLayoutConstraint constraintWithItem:self.segments attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:LAYOUT_TAB_HEIGHT];
	[self.view addConstraints:@[c1, c2, c3, c4]];
}

- (void) showButtons:(NSInteger)sel{
	UIImage* leftImage;
	UIImage* rightImage;
	if(sel == 0){
		leftImage = self.leftImages[0];
		rightImage = self.rightImages[1];
	}
	else{
		leftImage = self.leftImages[1];
		rightImage = self.rightImages[0];
	}
	[self.segments setImage:[leftImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forSegmentAtIndex:0];
	[self.segments setImage:[rightImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forSegmentAtIndex:1];
}

- (NSInteger) getSelectedIndex{
	UIViewController<PFileViewer>* child = (UIViewController<PFileViewer>*)self.currentChildController;
	return [child getSelectedIndex];
}

- (void)selectedSegment {
	NSInteger sel = [self.segments selectedSegmentIndex];
	[self showButtons:sel];
	[self showChild:sel];
}

- (void) showChild:(NSInteger)childIndex {
	[super showChild:childIndex];
	self.segments.selectedSegmentIndex = childIndex;
}

- (void) dealloc{
	[self.segments removeTarget:self action:@selector(selectedSegment) forControlEvents:UIControlEventValueChanged];
	self.leftImages = nil;
	self.rightImages = nil;
	[self.segments removeFromSuperview];
	self.segments = nil;
}

@end
