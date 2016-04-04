//
//  DisplayUtils.m
//  Symmetry
//
//  Created by John on 20/05/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "DisplayUtils.h"
#import <UIKit/UIKit.h>

@implementation DisplayUtils

+ (void) bubbleActionFrom:(UIResponder*) start toClass:(Class) class withSelector:(NSString*) selector withObject:(id) object{
	SEL sel = NSSelectorFromString(selector);
	UIResponder *responder = start;
	while (responder.nextResponder != nil){
		responder = responder.nextResponder;
		if ([responder isKindOfClass:class]) {
			break;
		}
	}
	if(responder && [responder respondsToSelector:sel]){
		IMP imp = [responder methodForSelector:sel];
		void (*func)(id, SEL, id) = (void*)imp;
		func(responder, sel, object);
	}
}

+ (void) bubbleActionFrom:(UIResponder*) start toProtocol:(Protocol*) protocol withSelector:(NSString*) selector withObject:(id) object{
	SEL sel = NSSelectorFromString(selector);
	UIResponder *responder = start;
	while (responder.nextResponder != nil){
		responder = responder.nextResponder;
		if ([responder conformsToProtocol:protocol]) {
			break;
		}
	}
	if(responder && [responder respondsToSelector:sel]){
		IMP imp = [responder methodForSelector:sel];
		void (*func)(id, SEL, id) = (void*)imp;
		func(responder, sel, object);
	}
}

+ (BOOL) createContextWithSize:(CGSize)size{
	if(size.width <= 0 || size.height <= 0){
		NSLog(@">>>>>>> NO! %f %f", size.width, size.height);
		return NO;
	}
	UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
	return YES;
}

+ (CGRect) fitFrame:(CGRect) frame inView:(UIView*) view{
	float newW = MIN(frame.size.width, view.frame.size.width);
	float newH = MIN(frame.size.height, view.frame.size.height);
	float newX = MIN(MAX(frame.origin.x,0), view.frame.size.width - newW);
	float newY = MIN(MAX(frame.origin.y,0), view.frame.size.height - newH);
	frame = CGRectMake(newX, newY, newW, newH);
	
	return frame;
}

@end
