//
//  HelpAnimViewController.m
//  Simitri
//
//  Created by John on 16/06/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "HelpAnimViewController.h"
#import "HelpAnimView.h"
#import "DrawingObject.h"
#import "SymmNotifications.h"
#import "Colors.h"

@interface HelpAnimViewController()

@property HelpAnimView* animView;
@property HelpAnimView* alphaView;
@property DrawingObject* obj;
@property BOOL showMath;
@property NSArray* alphaConstraints;

@end

@implementation HelpAnimViewController

 - (void) touch:(UITouch*)touch{
	if(self.showMath){
		CGPoint p = [touch locationInView:self.view];
		self.animPoint = p;
		if(self.animLink){
			[self stopAnimateWithFade:NO];
		}
		else{
			[self startAnimate];
		}
	}
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	UITouch* touch = [touches anyObject];
	[self touch:touch];
}

- (void) showMath:(BOOL) show{
	self.showMath = show;
	[self.animView showMath:show];
	[self.animView setNeedsDisplay];
	if(self.alphaView){
		[self.alphaView setNeedsDisplay];
	}
}

- (void) loadDrawingObject:(DrawingObject*) obj{
	UIColor* bg = [Colors defaultBgColorForIndex:obj.drawerNum];
	self.view.backgroundColor = bg;
	[super loadDrawingObject:obj];
	[self.animView load:obj];
}

- (void) viewWillDisappear:(BOOL)animated{
	[super viewWillDisappear:animated];
	
}

- (void) viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	[self stopAnimateWithFade:NO];
}

- (void)viewDidLoad{
    [super viewDidLoad];
	self.view.clipsToBounds = YES;
	self.animView = [[HelpAnimView alloc] initWithFrame:self.view.frame];
	self.view.backgroundColor = [UIColor clearColor];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDidRotate:) name:SYMM_NOTIF_DID_ROTATE object:nil];
	[self.view addSubview:self.animView];
	[self layoutAll];
}

- (void) addAlpha{
	if(!self.alphaView){
		self.alphaView = [[HelpAnimView alloc] initWithFrame:self.view.frame];
		[self.view addSubview:self.alphaView];
		[self.alphaView load:self.drawingObject];
		NSLayoutConstraint* c5 = [NSLayoutConstraint constraintWithItem:self.alphaView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0];
		NSLayoutConstraint* c6 = [NSLayoutConstraint constraintWithItem:self.alphaView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
		NSLayoutConstraint* c7 = [NSLayoutConstraint constraintWithItem:self.alphaView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
		NSLayoutConstraint* c8 = [NSLayoutConstraint constraintWithItem:self.alphaView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
		self.alphaConstraints = @[c5, c6, c7, c8];
		[self.view addConstraints:self.alphaConstraints];
		[self.view sendSubviewToBack:self.alphaView];
		self.alphaView.alpha = [ADrawingLayer getAlphaForAlphaLayer];
	}
}

-  (void) removeAlpha{
	if(self.alphaView){
		[self.view removeConstraints:self.alphaConstraints];
		[self.alphaView removeFromSuperview];
		self.alphaView = nil;
	}
}

- (void)didReceiveMemoryWarning{
	[super didReceiveMemoryWarning];
}

- (void) onDidRotate:(NSNotification*) notification{
	[self.animView setNeedsDisplay];
}

- (void) layoutAll{
	self.animView.translatesAutoresizingMaskIntoConstraints = NO;
	self.alphaView.translatesAutoresizingMaskIntoConstraints = NO;
	NSLayoutConstraint* c1 = [NSLayoutConstraint constraintWithItem:self.animView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0];
	NSLayoutConstraint* c2 = [NSLayoutConstraint constraintWithItem:self.animView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
	NSLayoutConstraint* c3 = [NSLayoutConstraint constraintWithItem:self.animView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
	NSLayoutConstraint* c4 = [NSLayoutConstraint constraintWithItem:self.animView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
	[self.view addConstraints:@[c1, c2, c3, c4]];
}

- (void) beginAnimate{
	[super beginAnimate];
	[self addAlpha];
	[self.view sendSubviewToBack:self.alphaView];
	[self.view bringSubviewToFront:self.animView];
	self.animView.alpha = [ADrawingLayer getAlphaForAlphaLayer];
}

- (void) startAnimate{
	[super startAnimate];
}

- (void) stopAnimDone{
	self.animView.alpha = 1;
	[self.animView resetGeometry];
	[self removeAlpha];
}

- (void) stopAnimateWithFade:(BOOL)fade{
	[super stopAnimateWithFade:fade];
	if(fade){
		[UIView animateWithDuration:1 animations:^{
			self.animView.alpha = 1;
		} completion:^(BOOL finished) {
			[self stopAnimDone];
			
		}];
	}
	else{
		[self stopAnimDone];
	}
}

- (void) updateViewsWithTrans:(TransformPair*)trans{
	[super updateViewsWithTrans:trans];
	[self.animView tick:trans];
}

- (void) dealloc{
	[self stopAnimateWithFade:NO];
	self.alphaConstraints = nil;
	[self.animView removeFromSuperview];
	[self removeAlpha];
	self.drawingObject = nil;
	self.animView = nil;
	[[NSNotificationCenter defaultCenter] removeObserver:self name:SYMM_NOTIF_DID_ROTATE object:nil];
}

@end
