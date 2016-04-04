//
//
//  Symmetry
//
//  Created by John on 17/05/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "AbstractDrawingView_Protected.h"
#import "ADrawer.h"
#import "SymmNotifications.h"
#import "Polygon.h"
#import "TileObject.h"
#import "Colors.h"
#import "DrawingConfig.h"

@interface AbstractDrawingView ()

@property TileObject* tileTransformObj;

@end


@implementation AbstractDrawingView

NSInteger const SYMM_MAX_UNDO_STACK = 16;

@synthesize drawingObject = _drawingObject;

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeColor:) name:SYMM_NOTIF_CHANGE_COLOR object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeWidth:) name:SYMM_NOTIF_CHANGE_WIDTH object:nil];
		self.multipleTouchEnabled = NO;
		self.exclusiveTouch = YES;
    }
    return self;
}

- (void) makeLineImageWithWhole:(BOOL) useWhole{
	
}

- (UIImage*) getImageForOverlay{
	return nil;
}

- (void) memoryWarning{
	
}

- (void) load:(DrawingObject*) obj{
	[super load:obj];
	self.currentTop = self.drawingObject.lines.count - 1;
	if(self.currentTop >= 0){
		self.currentLine = [self.drawingObject.lines objectAtIndex:self.currentTop];
	}
	else{
		self.currentLine = nil;
	}
	[self updateButtons];
	[[NSNotificationCenter defaultCenter] postNotificationName:SYMM_NOTIF_FILE_SAVE_SUCCESS object:nil];
}

- (void) changeColor:(NSNotification*) notification{
	UIColor* val = (UIColor*)[((NSDictionary*)notification.userInfo) valueForKey:@"color"];
	self.drawingObject.color = val;
}

- (void) changeWidth:(NSNotification*) notification{
	int w = [notification.object intValue];
	self.drawingObject.width = w;
}

- (void) undo{
	self.currentTop--;
	self.currentLine = [self getLineAtIndex:self.currentTop];
	[self redrawAll];
	[self updateButtons];
	[[NSNotificationCenter defaultCenter] postNotificationName:SYMM_NOTIF_FILE_CHANGED object:nil];
}

- (void) clear{
	[self.drawingObject clear];
	self.currentLine = nil;
	self.currentTop = -1;
	[self updateButtons];
	[[NSNotificationCenter defaultCenter] postNotificationName:SYMM_NOTIF_FILE_CHANGED object:nil];
}

- (void) redo{
	self.currentTop++;
	self.currentLine = [self getLineAtIndex:self.currentTop];
	[self redrawAll];
	[self updateButtons];
	[[NSNotificationCenter defaultCenter] postNotificationName:SYMM_NOTIF_FILE_CHANGED object:nil];
}

- (void) updateButtons{
	NSInteger top = [self.drawingObject.lines count] - 1;
	BOOL undoEnabled = (self.currentTop >= 0);
	BOOL redoEnabled = (self.currentTop < top);
	[[NSNotificationCenter defaultCenter] postNotificationName:SYMM_NOTIF_ENABLE_UNDO object:[NSNumber numberWithBool:undoEnabled]];
	[[NSNotificationCenter defaultCenter] postNotificationName:SYMM_NOTIF_ENABLE_REDO object:[NSNumber numberWithBool:redoEnabled]];
}

- (Line*) getLineAtIndex:(NSInteger) i{
	if(i == -1){
		return nil;
	}
	return [self.drawingObject.lines objectAtIndex:i];
}

- (BOOL) atTop{
	NSUInteger count = [self.drawingObject.lines count];
	return (self.currentTop == count - 1);
}

- (void) removeLineAtIndex:(NSInteger)i{
	if(i >= 0 && i < self.drawingObject.lines.count){
		[self.drawingObject.lines removeObjectAtIndex:i];
	}
}

- (void) clearTop{
	if(self.drawingObject.lines.count >= 1){
		while(![self atTop] && self.drawingObject.lines.count >= 1){
			NSInteger i = self.drawingObject.lines.count - 1;
			[self removeLineAtIndex:i];
		}
	}
}

- (void) checkOverflow{
	
}

- (void) lineAdded{
	[[NSNotificationCenter defaultCenter] postNotificationName:SYMM_NOTIF_FILE_CHANGED object:nil];
}

- (CGPoint) getAvg:(int) i0 with:(int) i1{
	CGPoint p0 = bezPts[i0];
	CGPoint p1 = bezPts[i1];
	float newX = (p0.x + p1.x)/2.0;
	float newY = (p0.y + p1.y)/2.0;
	return CGPointMake(newX, newY);
}

- (void) setPoint:(CGPoint) p at:(NSUInteger) i{
	bezPts[i] = p;
}

- (void) redrawAll{
	
}

- (BOOL) insidePolyAtPoint:(CGPoint) p{
	// are we still in the polygon we started in?
	TileObject* newTrans = [self.drawer getTrans:p];
	return [newTrans equals:self.tileTransformObj];
}

- (CGPoint) getBasicPt:(CGPoint)p{
	// map mouse point to one inside the basic polygon
	CGPoint basic = [self.tileTransformObj getBasicPoint:p];
	return basic;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	UITouch *touch = [touches anyObject];
	CGPoint p = [touch locationInView:self];
	self.tileTransformObj = [self.drawer getTrans:p];
	[self startDrawingAt:[self getBasicPt:p]];
}

- (void) startDrawingAt:(CGPoint)p{
	[self clearTop];
	[self checkOverflow];
	Line* line = [[Line alloc] initWithColor:self.drawingObject.color withWidth:self.drawingObject.width withAlpha:self.drawingObject.alpha];
	[self.drawingObject.lines addObject:line];
	self.currentLine = line;
	self.currentTop++;
	ctr = 0;
	[self setPoint:p at:0];
	[self.currentLine startAtPoint:p];
	[self lineAdded];
}

- (void) movedToPoint:(CGPoint)p{
	ctr++;
	[self setPoint:[self getBasicPt:p] at: ctr];
	if (ctr == 4){
		[self setPoint:[self getAvg:2 with:4] at: 3];
		[self.currentLine addCurveToPoint:bezPts[3] controlPoint1:bezPts[1] controlPoint2:bezPts[2]];
		[self setPoint:bezPts[3] at: 0];
		[self setPoint:bezPts[4] at: 1];
		ctr = 1;
		[self drawLinesWithBackground:YES];
	}
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
	UITouch *touch = [touches anyObject];
	CGPoint p = [touch locationInView:self];
	if([self insidePolyAtPoint:p]){
		[self movedToPoint:p];
	}
}

- (void) drawLinesWithBackground:(BOOL)background{
	// override
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	[self saveImage];
	[self updateButtons];
}

- (void) saveImage{
	
}

- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
	[self touchesEnded:touches withEvent:event];
}

- (void) dealloc{
	self.drawer = nil;
	self.currentLine = nil;
	self.tileTransformObj = nil;
	[[NSNotificationCenter defaultCenter] removeObserver:self name:SYMM_NOTIF_CHANGE_COLOR object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:SYMM_NOTIF_CHANGE_WIDTH object:nil];
}

@end
