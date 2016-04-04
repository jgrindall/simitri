//
//  ToolbarViewController.m
//  Symmetry
//
//  Created by John on 26/05/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "ToolbarViewController_Protected.h"
#import "Appearance.h"
#import "LayoutConsts.h"
#import "UIColor+Utils.h"

@interface ToolbarViewController ()

@end

@implementation ToolbarViewController

- (void) addItems{
	
}

- (void) layoutToolbar{
	self.toolBar.translatesAutoresizingMaskIntoConstraints = NO;
	NSLayoutConstraint* c1 = [NSLayoutConstraint constraintWithItem:self.toolBar attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0];
	NSLayoutConstraint* c2 = [NSLayoutConstraint constraintWithItem:self.toolBar attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
	NSLayoutConstraint* c3 = [NSLayoutConstraint constraintWithItem:self.toolBar attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
	NSLayoutConstraint* c4 = [NSLayoutConstraint constraintWithItem:self.toolBar attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
	[self.view addConstraints:@[c1, c2, c3, c4]];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.items = [[NSMutableArray alloc] init];
	self.toolBar =[[UIToolbar alloc] init];
	[self addItems];
	[self.view addSubview:self.toolBar];
	[Appearance flatToolbar:self.toolBar];
	[self layoutToolbar];
	[self updateItems];
}

- (void) updateItems{
	[self.toolBar setItems:self.items];
}

- (UIButton*) addButtonWithLabel:(NSString*)label clickSelector:(SEL)sel withTrailingSpace:(BOOL) tSpc withLeadingSpace:(BOOL)lSpc withSize:(CGSize)size withIcon:(NSString*) icon withTheme:(FlatButtonThemes)theme{
	if(size.width == CGSizeZero.width && size.height == CGSizeZero.height){
		size = CGSizeMake(LAYOUT_DEFAULT_BUTTON_WIDTH, LAYOUT_DEFAULT_BUTTON_HEIGHT);
	}
	UIButton* b = [Appearance flatButtonWithLabel:label withIcon:icon withTheme:theme withSize:size];
	UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithCustomView:b];
	[b addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem* flex1;
	UIBarButtonItem* flex2;
	if(lSpc){
		flex1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
		[self.items addObject:flex1];
	}
	[self.items addObject:item];
	if(tSpc){
		flex2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
		[self.items addObject:flex2];
	}
	return b;
}

- (void) viewWillLayoutSubviews{
	int count = 0;
	for (UIBarButtonItem* barButtonItem in self.items) {
		UIView* view = [barButtonItem valueForKey:@"view"];
		if(view) {
			count ++;
		}
	}
	if(count >= 1){
		float w = (self.view.bounds.size.width - 12*count) / count;
		int i = 0;
		for (UIBarButtonItem* barButtonItem in self.items) {
			UIView* view = [barButtonItem valueForKey:@"view"];
			if(view) {
				view.frame = CGRectIntegral(CGRectMake(i*w, 0, w, LAYOUT_DEFAULT_BUTTON_HEIGHT));
				i++;
			}
		}
	}
	[super viewWillLayoutSubviews];
}

- (void) enableButtonAtIndex:(NSInteger)i enabled:(BOOL)enable{
	
}

- (void)didReceiveMemoryWarning{
	[super didReceiveMemoryWarning];
}

- (UIButton*) addTabButtonWithLabel:(NSString*)label clickSelector:(SEL)sel withNum:(NSInteger)num withIcon:(NSString*) icon withTheme:(FlatButtonThemes)theme{
	CGSize size = CGSizeMake(100, LAYOUT_DEFAULT_BUTTON_HEIGHT);
	UIButton* b = [Appearance flatTabButtonWithLabel:label withIcon:icon withSize:size];
	UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithCustomView:b];
	[b addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
	[self.items addObject:item];
	return b;
}

- (void) dealloc{
	[self.items removeAllObjects];
	[self.toolBar setItems:self.items];
	self.items = nil;
	[self.toolBar removeFromSuperview];
	self.toolBar = nil;
}

@end
