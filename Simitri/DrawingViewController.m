//
//  DrawingViewController.m
//  Symmetry
//
//  Created by John on 19/05/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "DrawingViewController.h"
#import "DrawingDocument.h"
#import "SymmNotifications.h"
#import "PatternDrawingView.h"
#import "BackgroundView.h"
#import "LayoutConsts.h"
#import "ADrawer.h"
#import "DisplayUtils.h"
#import "MathView.h"
#import "AlphaLayer.h"

@interface DrawingViewController ()

@property AbstractDrawingView* drawingView;
@property BackgroundView* backgroundView;
@property AlphaLayer* alphaView;
@property MathView* mathView;
@property NSArray* alphaConstraints;

@end

@implementation DrawingViewController

- (void)viewDidLoad{
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor clearColor];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(performUndo) name:SYMM_NOTIF_PERFORM_UNDO object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(performRedo) name:SYMM_NOTIF_PERFORM_REDO object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(performClr) name:SYMM_NOTIF_PERFORM_CLR object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(performInfo:) name:SYMM_NOTIF_PERFORM_INFO object:nil];
	self.drawingView = [[PatternDrawingView alloc] initWithFrame:self.view.frame];
	self.backgroundView = [[BackgroundView alloc] initWithFrame:self.view.frame];
	self.mathView = [[MathView alloc] initWithFrame:self.view.frame];
	[self.view addSubview:self.backgroundView];
	[self.view addSubview:self.drawingView];
	[self.view addSubview:self.mathView];
	[self.mathView show:NO];
	[self layoutAll];
}

- (void) performInfo:(NSNotification*) notification{
	BOOL infoShown = [[((NSDictionary*)notification.userInfo) valueForKey:@"infoShown"] boolValue];
	if(!infoShown){
		[self.mathView show:YES];
	}
	else{
		[self.mathView show:NO];
	}
}

- (void) addAlpha{
	self.alphaView = [[AlphaLayer alloc] initWithFrame:self.view.frame];
	[self.view addSubview:self.alphaView];
	[self.alphaView load:self.drawingObject];
	UIImage* fg = [self.drawingView getImageForOverlay];
	UIImage* bg = [self.backgroundView getImageForOverlay];
	[self.alphaView setImageOverlays:fg andBg:bg];
	self.alphaView.alpha = [ADrawingLayer getAlphaForAlphaLayer];
	[self.view sendSubviewToBack:self.alphaView];
	self.alphaView.translatesAutoresizingMaskIntoConstraints = NO;
	NSLayoutConstraint* c1 = [NSLayoutConstraint constraintWithItem:self.alphaView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0];
	NSLayoutConstraint* c2 = [NSLayoutConstraint constraintWithItem:self.alphaView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
	NSLayoutConstraint* c3 = [NSLayoutConstraint constraintWithItem:self.alphaView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
	NSLayoutConstraint* c4 = [NSLayoutConstraint constraintWithItem:self.alphaView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
	self.alphaConstraints = @[c1, c2, c3, c4];
	[self.view addConstraints:self.alphaConstraints];
	[self updateViewConstraints];
}

- (void) beginAnimate{
	[super beginAnimate];
	[self addAlpha];
	self.drawingView.alpha = [ADrawingLayer getAlphaForAlphaLayer];
	[self.backgroundView show:NO];
	[self.mathView show:NO];
}

- (void) startAnimate{
	[super startAnimate];
}

-  (void) clickMathPoint:(id)pVal{
	CGPoint p = [pVal CGPointValue];
	self.animPoint = p;
	if(self.animLink){
		[self stopAnimateWithFade:NO];
	}
	[self startAnimate];
}

- (void) removeAlpha{
	if(self.alphaView){
		[self.view removeConstraints:self.alphaConstraints];
		[self.alphaView removeFromSuperview];
		self.alphaView = nil;
		self.alphaConstraints = nil;
	}
}

- (void) stopAnimDone{
	[self removeAlpha];
	self.drawingView.alpha = 1;
	[self.drawingView resetGeometry];
	[self.backgroundView show:YES];
	[self.mathView show:YES];
	[self.mathView resetGeometry];
}

- (void)didReceiveMemoryWarning{
	[super didReceiveMemoryWarning];
	if(self.drawingView){
		[self.drawingView memoryWarning];
	}
	if(self.view && !self.view.window){
		[self cleanUpView];
	}
}

- (void) cleanUpView{
	[self stopAnimDone];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:SYMM_NOTIF_PERFORM_UNDO object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:SYMM_NOTIF_PERFORM_REDO object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:SYMM_NOTIF_PERFORM_CLR object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:SYMM_NOTIF_PERFORM_INFO object:nil];
	[self.backgroundView removeFromSuperview];
	[self.drawingView removeFromSuperview];
	[self.mathView removeFromSuperview];
	self.mathView = nil;
	self.backgroundView = nil;
	self.drawingView = nil;
	self.drawingObject = nil;
	[self.view removeFromSuperview];
	self.view = nil;
}

- (void) stopAnimateWithFade:(BOOL)fade{
	[super stopAnimateWithFade:fade];
	if(fade){
		[UIView animateWithDuration:0.66 animations:^{
			self.drawingView.alpha = 1;
		} completion:^(BOOL finished) {
			[self stopAnimDone];
		}];
	}
	else{
		[self stopAnimDone];
	}
}

- (void) updateViewsWithTrans:(TransformPair*)trans{
	[self.drawingView tick:trans];
}

- (DrawingObject*) getDrawingObject{
	return self.drawingObject;
}

- (void) loadDrawingObject:(DrawingObject*) obj{
	[super loadDrawingObject:obj];
	[self.drawingView load:obj];
	[self.backgroundView load:obj];
	[self.mathView load:obj];
}

- (void) onRotate{
	[self.drawingView setNeedsDisplay];
	[self.backgroundView setNeedsDisplay];
	[self.mathView setNeedsDisplay];
}

- (void) layoutAll{
	[self layoutDraw];
	[self layoutBg];
	[self layoutMath];
}

- (void) layoutMath{
	self.mathView.translatesAutoresizingMaskIntoConstraints = NO;
	NSLayoutConstraint* c1 = [NSLayoutConstraint constraintWithItem:self.mathView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0];
	NSLayoutConstraint* c2 = [NSLayoutConstraint constraintWithItem:self.mathView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
	NSLayoutConstraint* c3 = [NSLayoutConstraint constraintWithItem:self.mathView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
	NSLayoutConstraint* c4 = [NSLayoutConstraint constraintWithItem:self.mathView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
	[self.view addConstraints:@[c1, c2, c3, c4]];
}

- (void) layoutDraw{
	self.drawingView.translatesAutoresizingMaskIntoConstraints = NO;
	NSLayoutConstraint* c1 = [NSLayoutConstraint constraintWithItem:self.drawingView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0];
	NSLayoutConstraint* c2 = [NSLayoutConstraint constraintWithItem:self.drawingView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
	NSLayoutConstraint* c3 = [NSLayoutConstraint constraintWithItem:self.drawingView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
	NSLayoutConstraint* c4 = [NSLayoutConstraint constraintWithItem:self.drawingView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
	[self.view addConstraints:@[c1, c2, c3, c4]];
}

- (void) layoutBg{
	self.backgroundView.translatesAutoresizingMaskIntoConstraints = NO;
	NSLayoutConstraint* c1 = [NSLayoutConstraint constraintWithItem:self.backgroundView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0];
	NSLayoutConstraint* c2 = [NSLayoutConstraint constraintWithItem:self.backgroundView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
	NSLayoutConstraint* c3 = [NSLayoutConstraint constraintWithItem:self.backgroundView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
	NSLayoutConstraint* c4 = [NSLayoutConstraint constraintWithItem:self.backgroundView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
	[self.view addConstraints:@[c1, c2, c3, c4]];
}

- (void) performUndo{
	[[self drawingView] undo];
}

- (void) performRedo{
	[[self drawingView] redo];
}

- (void) performClr{
	[[self drawingView] clear];
}

- (UIImage*) getLargeThumb{
	return [self getImage:CGSizeMake(LAYOUT_FILE_THUMB_LARGE_SIZE, LAYOUT_FILE_THUMB_LARGE_SIZE)];
}

- (UIImage*) getMedThumb{
	return [self getImage:CGSizeMake(LAYOUT_FILE_THUMB_MED_SIZE, LAYOUT_FILE_THUMB_MED_SIZE)];
}

- (UIImage*) getThumb{
	return [self getImage:CGSizeMake(LAYOUT_FILE_THUMB_SIZE, LAYOUT_FILE_THUMB_SIZE)];
}

- (NSArray*) getThumbs{
	NSMutableArray* thumbs = [NSMutableArray array];
	[thumbs addObject:[self getThumb]];
	[thumbs addObject:[self getMedThumb]];
	[thumbs addObject:[self getLargeThumb]];
	return [thumbs copy];
}

- (UIImage*) getImage:(CGSize)size{
	UIImage* snapshot;
	BOOL c = [DisplayUtils createContextWithSize:size];
	if(c){
		CGContextRef buffer = UIGraphicsGetCurrentContext();
		if(buffer){
			[self.backgroundView.layer drawInContext:buffer];
			[self.drawingView.layer drawInContext:buffer];
			snapshot = UIGraphicsGetImageFromCurrentImageContext();
		}
		UIGraphicsEndImageContext();
	}
	return snapshot;
}

- (void) dealloc{
	[self cleanUpView];
}

@end
