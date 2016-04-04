//
//  PatternDrawingView.m
//  Symmetry
//
//  Created by John on 28/05/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "PatternDrawingView.h"
#import "Colors.h"
#import "SymmNotifications.h"
#import "TransformUtils.h"
#import "DrawingConfig.h"
#import "DisplayUtils.h"
#import "ImageUtils.h"

@interface PatternDrawingView ()

@property UIImage* lineImage;
@property UIImage* mainImage;
@property NSMutableArray* preImages;
@property NSMutableArray* postImages;

@end

@implementation PatternDrawingView
{
	dispatch_queue_t drawingQueue;
}
void patternCallback (void* info, CGContextRef context);
static const CGPatternCallbacks callbacks = {0, &patternCallback, NULL};

- (id)initWithFrame:(CGRect)frame{
	self = [super initWithFrame:frame];
    if (self) {
		drawingQueue = dispatch_queue_create("drawingQueue", NULL);
		[self clearImages];
    }
    return self;
}

- (void) showMath:(BOOL) show{
	
}

- (UIImage*) getImageForOverlay{
	return self.mainImage;
}

- (void) removeLineAtIndex:(NSInteger)i{
	[super removeLineAtIndex:i];
	if(self.preImages.count > i){
		[self.preImages removeObjectAtIndex:i];
	}
	if(self.postImages.count > i){
		[self.postImages removeObjectAtIndex:i];
	}
}

- (void) clearImages{
	[self.preImages removeAllObjects];
	self.preImages = nil;
	[self.postImages removeAllObjects];
	self.postImages = nil;
	self.preImages = [NSMutableArray array];
	self.postImages = [NSMutableArray array];
}

- (void) load:(DrawingObject*) obj{
	[super load:obj];
	[self clearImages];
	if(self.drawingObject.lines.count >= 1){
		BOOL c = [DisplayUtils createContextWithSize:self.drawer.basicRect.size];
		if(c){
			CGContextRef buffer = UIGraphicsGetCurrentContext();
			if(buffer){
				[obj.baseImage drawAtPoint:CGPointZero];
				Line* line;
				NSInteger max = self.drawingObject.lines.count;
				for (int i = 0; i < max; i++) {
					line = self.drawingObject.lines[i];
					self.preImages[i] = UIGraphicsGetImageFromCurrentImageContext();
					[self addLineToBufferAndDraw:line andBuffer:buffer useWhole:YES];
					self.postImages[i] = UIGraphicsGetImageFromCurrentImageContext();
				}
				self.mainImage = UIGraphicsGetImageFromCurrentImageContext();
			}
			UIGraphicsEndImageContext();
		}
	}
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
		CGPatternRef pattern = CGPatternCreate((__bridge void *)(self.mainImage), self.drawer.basicRect, self.mathTransform, self.drawer.basicRect.size.width, self.drawer.basicRect.size.height, kCGPatternTilingConstantSpacing, true, &callbacks);
		CGContextSetFillPattern(context, pattern, &alpha);
		CGContextFillRect(context, rect);
		CGPatternRelease(pattern);
		CGContextRestoreGState (context);
	}
}

void patternCallback (void* info, CGContextRef context) {
	UIImage* img = (__bridge UIImage*)info;
	if(img) {
		CGContextDrawImage(context, CGRectMake(0,0, img.size.width, img.size.height), img.CGImage);
	}
}

- (void) addLineToBufferAndDraw:(Line*)line andBuffer:(CGContextRef) buffer useWhole:(BOOL)whole{
	CGMutablePathRef allPaths = CGPathCreateMutable();
	NSInteger max = self.drawer.flippedTransforms.count - 1;
	NSInteger width = line.width;
	CGContextSetStrokeColorWithColor(buffer, line.color.CGColor);
	CGContextSetLineJoin(buffer, kCGLineJoinRound);
	CGContextSetLineCap(buffer, kCGLineCapRound);
	BOOL antiAlias = (line.count <= DRAWING_CONFIG_ANTI_ALIAS);
	if(!antiAlias){
		if(width >= 6){
			width -= 2;
		}
		else if(width >= 4){
			width -= 1;
		}
	}
	for (int i = 0;i <= max; i++) {
		CGAffineTransform trans = [self.drawer.flippedTransforms[i] CGAffineTransformValue];
		if(whole){
			CGPathAddPath(allPaths, &trans, [line getWhole]);
		}
		else{
			CGPathAddPath(allPaths, &trans, [line getPath]);
		}
	}
	CGContextAddPath(buffer, allPaths);
	CGContextSetShouldAntialias(buffer, antiAlias);
	CGContextSetLineWidth(buffer, width);
	CGContextDrawPath(buffer, kCGPathStroke);
	CGPathRelease(allPaths);
}

- (void) memoryWarning{
	return;
	//NSLog(@"mw %d", self.drawingObject.lines.count);
	if(self.drawingObject.lines.count >= 1){
		self.drawingObject.baseImage = self.postImages[self.postImages.count - 1];
		//NSLog(@"self.drawingObject.lines.count %d", self.drawingObject.lines.count);
		while(self.drawingObject.lines.count >= 2){
			//NSLog(@"-  self.drawingObject.lines.count %d", self.drawingObject.lines.count);
			//NSLog(@"remove index 0");
			[self removeLineAtIndex:0];
			self.currentTop--;
		}
		[self updateButtons];
	}
}

- (void) checkOverflow{
	[super checkOverflow];
	NSInteger num = self.drawingObject.lines.count;
	if(num >= SYMM_MAX_UNDO_STACK){
		self.drawingObject.baseImage = self.postImages[num - SYMM_MAX_UNDO_STACK];
		while(self.drawingObject.lines.count >= SYMM_MAX_UNDO_STACK){
			[self removeLineAtIndex:0];
			self.currentTop--;
		}
	}
	[self updateButtons];
}

- (void) lineAdded{
	[super lineAdded];
	if(self.mainImage){
		self.preImages[self.currentTop] = self.mainImage;
	}
	else{
		self.preImages[self.currentTop] = [self emptyImage];
	}
	self.lineImage = nil;
}

- (UIImage*) emptyImage{
	UIImage* empty;
	BOOL c = [DisplayUtils createContextWithSize:self.drawer.basicRect.size];
	if(c){
		empty = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
	}
	return empty;
}

- (void) makeLineImage{
	BOOL c = [DisplayUtils createContextWithSize:self.drawer.basicRect.size];
	if(c){
		CGContextRef buffer = UIGraphicsGetCurrentContext();
		if(buffer){
			CGContextSetInterpolationQuality(buffer, kCGInterpolationLow);
			if(self.lineImage){
				[self.lineImage drawAtPoint:CGPointZero];
			}
			[self addLineToBufferAndDraw:self.currentLine andBuffer:buffer useWhole:NO];
			self.lineImage = UIGraphicsGetImageFromCurrentImageContext();
		}
		UIGraphicsEndImageContext();
	}
	[self.currentLine cached];
}

- (void) makeMainImage{
	[self makeLineImage];
	BOOL c = [DisplayUtils createContextWithSize:self.drawer.basicRect.size];
	if(c){
		CGContextRef ref = UIGraphicsGetCurrentContext();
		if(ref){
			if(self.mainImage){
				[self.mainImage drawAtPoint:CGPointZero];
			}
			[self.lineImage drawAtPoint:CGPointZero];
			self.mainImage = UIGraphicsGetImageFromCurrentImageContext();
		}
		UIGraphicsEndImageContext();
	}
	[self setNeedsDisplay];
}

- (void) drawLinesWithBackground:(BOOL)background{
	if(background){
		dispatch_async(drawingQueue, ^{
			[self makeMainImage];
		});
	}
	else{
		[self makeMainImage];
	}
	[self setNeedsDisplay];
}

- (void) saveImage{
	[super saveImage];
	//NSLog(@"saving, %d  %d  %@", self.currentTop, self.postImages.count, self.mainImage);
	if(!self.mainImage){
		self.mainImage = [[UIImage alloc] init];
	}
	if(self.mainImage && self.currentTop>=0){
		self.postImages[self.currentTop] = self.mainImage;
	}
}

- (void) clear{
	[super clear];
	[self clearImages];
	[self redrawAll];
}

- (void) redrawAll{
	if(self.currentTop>=0){
		self.mainImage = self.postImages[self.currentTop];
	}
	else if(self.currentTop == -1 && self.preImages.count >= 1){
		self.mainImage = self.preImages[0];
	}
	else{
		self.mainImage = nil;
	}
	self.lineImage = nil;
	[self setNeedsDisplay];
}

- (void) dealloc{
	self.lineImage = nil;
	self.mainImage = nil;
	[self.preImages removeAllObjects];
	[self.postImages removeAllObjects];
	self.postImages = nil;
	self.preImages = nil;
}

@end
