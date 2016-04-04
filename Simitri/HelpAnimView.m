//
//  HelpAnimView.m
//  Simitri
//
//  Created by John on 12/06/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "HelpAnimView.h"
#import "ADrawer.h"
#import "Drawer_P6_236.h"
#import "TransformUtils.h"
#import "DisplayUtils.h"
#import "ImageUtils.h"

@interface HelpAnimView()

@property UIImage* mainImage;

@property BOOL showMath;

@end

@implementation HelpAnimView

void helpAnimCallback (void* info, CGContextRef context);
void helpReleaseCallback (void* info);
static const CGPatternCallbacks callbacks = {0, &helpAnimCallback, &helpReleaseCallback};

- (void) load:(DrawingObject*) obj{
	[super load:obj];
	[self update];
}

- (void) update{
	[self makeMainImage];
	[self setNeedsDisplay];
}

- (void) showMath:(BOOL)show{
	self.showMath = show;
	[self update];
}

- (void) makeMainImage{
	BOOL c = [DisplayUtils createContextWithSize:self.drawer.basicRect.size];
	if(c){
		CGContextRef context = UIGraphicsGetCurrentContext();
		if(context){
			if(self.drawer.demoImage){
				[self.drawer.demoImage drawAtPoint:CGPointZero];
			}
			if(self.showMath && self.drawer.mathImage){
				[self.drawer.mathImage drawAtPoint:CGPointZero];
			}
			if(self.showMath && self.drawer.gridImage){
				[self.drawer.gridImage drawAtPoint:CGPointZero];
			}
			self.mainImage = [ImageUtils optimize:UIGraphicsGetImageFromCurrentImageContext()];
		}
		UIGraphicsEndImageContext();
	}
}

- (void) drawRect:(CGRect)rect{
	CGContextRef context = UIGraphicsGetCurrentContext();
	if(context && self.mainImage){
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

void helpReleaseCallback (void* info) {
	info = nil;
}

void helpAnimCallback (void* info, CGContextRef context) {
	UIImage* img = (__bridge UIImage*)info;
	if(img) {
		CGContextDrawImage(context, CGRectMake(0,0, img.size.width, img.size.height), img.CGImage);
	}
}

- (void)dealloc{
	self.mainImage = nil;
	[self setNeedsDisplay];
}

@end


