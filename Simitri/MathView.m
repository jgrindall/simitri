//
//  MathView.m
//  Simitri
//
//  Created by John on 14/06/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "MathView_Protected.h"
#import "SymmNotifications.h"
#import "Colors.h"
#import "ADrawer_Protected.h"
#import "ADrawer.h"
#import "DisplayUtils.h"
#import "PDrawingAnimator.h"
#import "ImageUtils.h"

@interface MathView()

@property UIImage* mathImage;

@end

@implementation MathView

void patternMathCallback (void* info, CGContextRef context);
static const CGPatternCallbacks callbacks = {0, &patternMathCallback, NULL};

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) load:(DrawingObject*) obj{
	[super load:obj];
	self.mathImage = self.drawer.mathImage;
	[self setNeedsDisplay];
}

- (void) drawRect:(CGRect)rect{
	CGContextRef context = UIGraphicsGetCurrentContext();
	if(context){
		CGFloat alpha = 1;
		CGContextSaveGState(context);
		CGColorSpaceRef patternSpace = CGColorSpaceCreatePattern(NULL);
		CGContextSetFillColorSpace(context, patternSpace);
		CGColorSpaceRelease(patternSpace);
		CGPatternRef pattern = CGPatternCreate((__bridge void *)(self.mathImage), self.drawer.basicRect, self.mathTransform, self.drawer.basicRect.size.width, self.drawer.basicRect.size.height, kCGPatternTilingConstantSpacing, true, &callbacks);
		CGContextSetFillPattern(context, pattern, &alpha);
		CGContextFillRect(context, rect);
		CGPatternRelease(pattern);
		CGContextRestoreGState(context);
	}
}

void patternMathCallback (void* info, CGContextRef context) {
	UIImage* img = (__bridge UIImage*)info;
	if(img) {
		CGContextDrawImage(context, CGRectMake(0,0, img.size.width, img.size.height), img.CGImage);
	}
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	UITouch *touch = [touches anyObject];
	CGPoint p = [touch locationInView:self];
	id pointVal = [NSValue valueWithCGPoint:p];
	[DisplayUtils bubbleActionFrom:self toProtocol:@protocol(PDrawingAnimator) withSelector:@"clickMathPoint:" withObject:pointVal];
}

- (void)dealloc{
	self.mathImage = nil;
	[[NSNotificationCenter defaultCenter] removeObserver:self name:SYMM_NOTIF_BG_CHANGE_COLOR object:nil];
}


@end
