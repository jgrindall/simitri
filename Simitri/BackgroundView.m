//
//
//  Symmetry
//
//  Created by John on 17/05/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "BackgroundView_Protected.h"
#import "SymmNotifications.h"
#import "Colors.h"
#import "ADrawer_Protected.h"
#import "ADrawer.h"
#import "DisplayUtils.h"
#import "ImageUtils.h"

@interface BackgroundView ()

@property UIImage* mainImage;
@property UIImage* bgImage;

@end

@implementation BackgroundView

void patternBgCallback (void* info, CGContextRef context);
static const CGPatternCallbacks callbacks = {0, &patternBgCallback, NULL};


- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeBgColor:) name:SYMM_NOTIF_BG_CHANGE_COLOR object:nil];
    }
    return self;
}

- (void) load:(DrawingObject*) obj{
	[super load:obj];
	[self makeBgImage:obj.bgColor];
	[self update];
}

- (void) makeBgImage:(UIColor*)clr{
	BOOL c = [DisplayUtils createContextWithSize:self.drawer.basicRect.size];
	if(c){
		CGContextRef buffer = UIGraphicsGetCurrentContext();
		if(buffer){
			CGContextSetFillColorWithColor(buffer, [clr CGColor]);
			CGContextFillRect(buffer, self.drawer.basicRect);
			self.bgImage = UIGraphicsGetImageFromCurrentImageContext();
		}
		UIGraphicsEndImageContext();
	}
}

- (UIImage*) getImageForOverlay{
	return self.mainImage;
}

- (void) changeBgColor:(NSNotification*) notification{
	UIColor* val = (UIColor*)[((NSDictionary*)notification.userInfo) valueForKey:@"bgColor"];
	self.drawingObject.bgColor = val;
	[self makeBgImage:val];
	[self update];
}

- (void) update{
	[self makeMainImage];
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
		CGContextRestoreGState(context);
	}
}

void patternBgCallback (void* info, CGContextRef context) {
	UIImage* img = (__bridge UIImage*)info;
	if(img) {
		CGContextDrawImage(context, CGRectMake(0,0, img.size.width, img.size.height), img.CGImage);
	}
}

- (void) makeMainImage{
	BOOL c = [DisplayUtils createContextWithSize:self.drawer.basicRect.size];
	if(c){
		CGContextRef context = UIGraphicsGetCurrentContext();
		if(context){
			if(self.bgImage){
				[self.bgImage drawAtPoint:CGPointZero];
			}
			if(self.drawer.gridImage){
				[self.drawer.gridImage drawAtPoint:CGPointZero];
			}
			self.mainImage = UIGraphicsGetImageFromCurrentImageContext();
		}
		UIGraphicsEndImageContext();
	}
}

- (void)dealloc{
	self.mainImage = nil;
	self.bgImage = nil;
	[[NSNotificationCenter defaultCenter] removeObserver:self name:SYMM_NOTIF_BG_CHANGE_COLOR object:nil];
}

@end

