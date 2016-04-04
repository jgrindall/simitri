//
//  AnimViewController.m
//  Symmetry
//
//  Created by John on 23/06/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "AnimViewController_Protected.h"
#import "TransformPair.h"
#import "SymmNotifications.h"

@interface AnimViewController ()

@end

@implementation AnimViewController

static int maxAnimTime = 50;
static int frameRate = 3;

- (void)viewDidLoad{
    [super viewDidLoad];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopAnimEvent) name:SYMM_NOTIF_STOP_ANIM object:nil];
}

- (void) stopAnimEvent{
	if(self.animLink){
		[self stopAnimateWithFade:NO];
	}
}

- (void) cleanUpView{
	[[NSNotificationCenter defaultCenter] removeObserver:self name:SYMM_NOTIF_STOP_ANIM object:nil];
	[self.view removeFromSuperview];
	self.view = nil;
}

- (void)didReceiveMemoryWarning{
	[super didReceiveMemoryWarning];
	if(self.view && !self.view.window){
		[self cleanUpView];
	}
}

- (void) startAnimate{
	self.animTime = 0;
	self.animLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(tick)];
	[self.animLink setFrameInterval:frameRate];
	[self.animLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void) loadDrawingObject:(DrawingObject*) obj{
	self.drawingObject = obj;
}

- (void) tick{
	float time = (float)self.animTime/maxAnimTime;
	TransformPair* trans = [self.drawingObject.drawer getMathTransformForPoint:self.animPoint atTime:time];
	if(!trans){
		[self stopAnimateWithFade:NO];
	}
	else{
		if(self.animTime == 0){
			[self beginAnimate];
		}
		[self updateViewsWithTrans:trans];
		self.animTime ++;
		if(self.animTime == maxAnimTime + 1){
			[self stopAnimateWithFade:YES];
		}
	}
}

- (void) beginAnimate{
	
}

- (void) updateViewsWithTrans:(TransformPair*) trans{
	
}

- (void) stopAnimateWithFade:(BOOL)fade{
	if(self.animLink){
		[self.animLink removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
	}
	self.animLink = nil;
}

- (void) clickMathPoint:(id)pVal{
	
}

- (void)dealloc{
	[self cleanUpView];
}

@end
