//
//
//  Symmetry
//
//  Created by John on 17/05/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "AlphaLayer_Protected.h"
#import "SymmNotifications.h"
#import "Colors.h"
#import "ADrawer_Protected.h"
#import "ADrawer.h"
#import "DisplayUtils.h"
#import "ImageUtils.h"

@interface AlphaLayer ()

@property UIImage* fgImage;
@property UIImage* bgImage;
@property UIImage* mainImage;

@end

@implementation AlphaLayer

void patternAlphaCallback (void* info, CGContextRef context);
static const CGPatternCallbacks callbacks = {0, &patternAlphaCallback, NULL};

- (void) load:(DrawingObject*) obj{
	[super load:obj];
}

- (void) setImageOverlays:(UIImage*) fgImage andBg:(UIImage*)bgImage{
	self.bgImage = bgImage;
	self.fgImage = fgImage;
	[self update];
}

- (void) makeMainImage{
	BOOL c = [DisplayUtils createContextWithSize:self.drawer.basicRect.size];
	if(c){
		CGContextRef context = UIGraphicsGetCurrentContext();
		if(context){
			if(self.bgImage && self.fgImage){
				[self.bgImage drawAtPoint:CGPointZero];
				[self.fgImage drawAtPoint:CGPointZero];
			}
			self.mainImage = [ImageUtils optimize:UIGraphicsGetImageFromCurrentImageContext()];
		}
		UIGraphicsEndImageContext();
	}
}

- (void) update{
	[self makeMainImage];
	if(self.mainImage && self.drawingObject){
		[self setNeedsDisplay];
	}
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
		CGContextRestoreGState(context);
	}
}

void patternAlphaCallback (void* info, CGContextRef context) {
	UIImage* img = (__bridge UIImage*)info;
	if(img) {
		CGContextDrawImage(context, CGRectMake(0,0, img.size.width, img.size.height), img.CGImage);
	}
}

- (void)dealloc{
	self.mainImage = nil;
	self.fgImage = nil;
	self.bgImage = nil;
}

@end

