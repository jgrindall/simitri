//
//  TemplateMenuControllerViewController.m
//  Symmetry
//
//  Created by John on 30/05/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "ToolbarController.h"
#import "DisplayUtils.h"
#import "ToolbarTabViewController.h"
#import "SoundManager.h"

@interface ToolbarController ()

@property NSArray* buttons;
@property NSArray* icons;
@property NSMutableArray* buttonViews;

@end

@implementation ToolbarController

- (id) initWithButtons:(NSArray*) buttons andIcons:(NSArray*) icons{
	self = [super init];
	if(self){
		_buttons = buttons;
		if(_buttons.count>=5){
			NSLog(@"too many!");
		}
		_icons = icons;
		_buttonViews = [NSMutableArray array];
	}
	return self;
}

- (void) addItems{
	SEL sel;
	for (int i = 0; i<self.buttons.count; i++) {
		sel = NSSelectorFromString([NSString stringWithFormat:@"click%d",i]);
		UIButton* b = [self addTabButtonWithLabel:self.buttons[i] clickSelector:sel withNum:self.buttons.count withIcon:self.icons[i] withTheme:FlatButtonThemeTab];
		[self.buttonViews addObject:b];
	}
}

- (void)didReceiveMemoryWarning{
	[super didReceiveMemoryWarning];
}

- (void) highlightButton:(NSInteger)i{
	for (int j = 0; j<self.buttons.count ; j++) {
		UIButton* b = (UIButton*)self.buttonViews[j];
		if(i==j){
			dispatch_async(dispatch_get_main_queue(), ^{
				[b setHighlighted:YES];
			});
		}
		else{
			dispatch_async(dispatch_get_main_queue(), ^{
				[b setHighlighted:NO];
			});
		}
	}
	
}

- (void) click:(NSInteger)i{
	[[SoundManager sharedInstance] playClick];
	[DisplayUtils bubbleActionFrom:self toClass:[ToolbarTabViewController class] withSelector:@"buttonChosen:" withObject:[NSNumber numberWithInteger:i]];
}

- (void) click0{
	[self click:0];
}

- (void) click1{
	[self click:1];
}

- (void) click2{
	[self click:2];
}

- (void) click3{
	[self click:3];
}

- (void) dealloc{
	SEL sel;
	for (int i = 0; i < self.buttons.count; i++) {
		sel = NSSelectorFromString([NSString stringWithFormat:@"click%d",i]);
		UIButton* b = (UIButton*)self.buttonViews[i];
		[b removeTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
		[b removeFromSuperview];
	}
	self.buttons = nil;
	[self.buttonViews removeAllObjects];
	self.buttonViews = nil;
}

@end


