//
//  ImageUtils.m
//  Symmetry
//
//  Created by John on 10/06/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "ImageUtils.h"
#import "UIColor+Utils.h"
#import "DisplayUtils.h"
#import "UIImage+Resize.h"
#import "UIImage+Resize.h"
#import "UIImage+RoundedCorner.h"
#import "Appearance.h"
#import "UIColor+Utils.h"
#import "LaunchOptions.h"

@interface ImageUtils()

@end

@implementation ImageUtils

static NSMutableDictionary* imageCache;

static CGFloat edgeSizeFromCornerRadius(CGFloat cornerRadius) {
    return cornerRadius * 2 + 1;
}

+ (void) emptyCache{
	[imageCache removeAllObjects];
	imageCache = nil;
	imageCache = [NSMutableDictionary dictionary];
}

+ (UIImage*) optimize:(UIImage*) src{
	float q = [[LaunchOptions sharedInstance] getImgQuality];
	return [UIImage imageWithData:UIImageJPEGRepresentation(src, q) scale:[UIScreen mainScreen].scale];
}

+ (UIImage*) loadImageFromCacheWithKey:(NSString*) filename{
	if(!imageCache){
		imageCache = [NSMutableDictionary dictionary];
		return nil;
	}
	else{
		return [imageCache objectForKey:filename];
	}
}

+ (UIImage*) loadImageNamed:(NSString *)filename{
	UIImage* cached = [ImageUtils loadImageFromCacheWithKey:filename];
	if(cached){
		return cached;
	}
	else{
		UIImage* img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:filename ofType:nil]];
		[imageCache setValue:img forKey:filename];
		return img;
	}
}

+ (UIImage*) iconWithName:(NSString*) name andSize:(CGSize)size andColor:(UIColor*)color{
	UIImage* origImage = [ImageUtils loadImageNamed:name];
	UIImage* clrImg = [ImageUtils imageWithOverlayColor:origImage withColor:color];
	UIImage* sizedImage = [clrImg resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:size interpolationQuality:kCGInterpolationDefault];
	return sizedImage;
}

+ (UIImage*) compositeTopImage:(UIImage*) top withBottomImage:(UIImage*) bottom andSize:(CGSize)size atPoint:(CGPoint)point{
	UIImage* comp;
	BOOL c = [DisplayUtils createContextWithSize:size];
	if(c){
		[bottom drawAtPoint:point];
		[top drawAtPoint:CGPointZero];
		comp = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
	}
	return comp;
}

+ (UIImage *)imageWithColor:(UIColor *)color cornerRadius:(CGFloat)cornerRadius {
	CGFloat minEdgeSize = edgeSizeFromCornerRadius(cornerRadius);
    CGRect rect = CGRectMake(0, 0, minEdgeSize, minEdgeSize);
    UIImage* image;
	UIImage* resized;
	UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius];
    roundedRect.lineWidth = 0;
	BOOL c = [DisplayUtils createContextWithSize:rect.size];
	if(c){
		CGContextRef buffer = UIGraphicsGetCurrentContext();
		if(buffer){
			CGContextSetFillColorWithColor(buffer, color.CGColor);
			CGContextAddPath(buffer, roundedRect.CGPath);
			CGContextFillPath(buffer);
		}
		image = UIGraphicsGetImageFromCurrentImageContext();
		resized = [image resizableImageWithCapInsets:UIEdgeInsetsMake(cornerRadius, cornerRadius, cornerRadius, cornerRadius)];
		UIGraphicsEndImageContext();
	}
    return resized;
}

+ (UIImage*) iconWithName:(NSString*) name andSize:(CGSize)size andColor:(UIColor*)color andShadowColor:(UIColor*)shadowColor{
	int d = 2;
	CGSize smallerSize = CGSizeMake(size.width - d, size.height - d);
	UIImage* topImage = [ImageUtils iconWithName:name andSize:smallerSize andColor:color];
	UIImage* bottomImage = [ImageUtils iconWithName:name andSize:smallerSize andColor:shadowColor];
	return [ImageUtils compositeTopImage:topImage withBottomImage:bottomImage andSize:size atPoint:CGPointMake(d, d)];
}

+ (UIImage*) shadowIconWithName:(NSString*) name andSize:(CGSize)size {
	return [ImageUtils shadowIconWithName:name andSize:size andColor:[Colors symmGrayButtonColor]];
}

+ (UIImage*) shadowIconWithName:(NSString*) name andSize:(CGSize)size andColor:(UIColor*)color{
	return [ImageUtils iconWithName:name andSize:size andColor:color andShadowColor:[Colors symmGrayTextShadowColor]];
}

+ (UIImage*) iconWithName:(NSString*) name andSize:(CGSize)size{
	return [ImageUtils iconWithName:name andSize:size andColor:[Colors symmGrayButtonColor]];
}

+ (UIImage*) disabledIconWithName:(NSString*) name andSize:(CGSize)size{
	return [ImageUtils iconWithName:name andSize:size andColor:[Colors symmGrayTextDisabledColor]];
}

+ (UIImage*) shadowImage:(CGSize)size withCurlX:(int)cx withCurlY:(int)cy{
	UIImage* shadow;
	BOOL c = [DisplayUtils createContextWithSize:size];
	if(c){
		CGContextRef context = UIGraphicsGetCurrentContext();
		if(context){
			CGMutablePathRef ref = CGPathCreateMutable();
			CGPathMoveToPoint(ref, NULL, 0, size.height - cy);
			CGPathAddLineToPoint(ref, NULL, cx, size.height);
			CGPathAddQuadCurveToPoint(ref, NULL, size.width/2, size.height - 2*cy, size.width - cx, size.height);
			CGPathAddLineToPoint(ref, NULL, size.width, size.height - cy);
			CGPathCloseSubpath(ref);
			CGContextSetFillColorWithColor(context, [UIColor grayColor].CGColor);
			CGContextAddPath(context, ref);
			CGContextFillPath(context);
			shadow = UIGraphicsGetImageFromCurrentImageContext();
			CGPathRelease(ref);
		}
		UIGraphicsEndImageContext();
	}
	return [ImageUtils blur:shadow];
}

+ (UIImage*) blur:(UIImage*)src {
	if(!src){
		return nil;
	}
	UIImage* result = src;
	int num = 1;
	for(int i = 1; i<= num; i++){
		result = [ImageUtils imageWithGaussianBlur9:result];
	}
	return result;
}

+ (UIImage*)imageWithGaussianBlur9:(UIImage*)src {
	if(!src){
		return nil;
	}
	float weight[5] = {0.2270270270, 0.1945945946, 0.1216216216, 0.0540540541, 0.0162162162};
	UIImage *horizBlurredImage;
	UIImage *blurredImage;
	BOOL c = [DisplayUtils createContextWithSize:src.size];
	if(c){
		[src drawInRect:CGRectMake(0, 0, src.size.width, src.size.height) blendMode:kCGBlendModePlusLighter alpha:weight[0]];
		for (int x = 1; x < 5; ++x) {
			[src drawInRect:CGRectMake(x, 0, src.size.width, src.size.height) blendMode:kCGBlendModePlusLighter alpha:weight[x]];
			[src drawInRect:CGRectMake(-x, 0, src.size.width, src.size.height) blendMode:kCGBlendModePlusLighter alpha:weight[x]];
		}
		horizBlurredImage = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
	}
	c = [DisplayUtils createContextWithSize:src.size];
	if(c){
		[horizBlurredImage drawInRect:CGRectMake(0, 0, src.size.width, src.size.height) blendMode:kCGBlendModePlusLighter alpha:weight[0]];
		for (int y = 1; y < 5; ++y) {
			[horizBlurredImage drawInRect:CGRectMake(0, y, src.size.width, src.size.height) blendMode:kCGBlendModePlusLighter alpha:weight[y]];
			[horizBlurredImage drawInRect:CGRectMake(0, -y, src.size.width, src.size.height) blendMode:kCGBlendModePlusLighter alpha:weight[y]];
		}
		blurredImage = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
	}
	return blurredImage;
}

+ (UIImage *)imageByApplyingAlpha:(UIImage*) src withAlpha:(CGFloat) alpha {
	UIImage *newImage;
	BOOL c = [DisplayUtils createContextWithSize:src.size];
	if(c){
		CGContextRef ctx = UIGraphicsGetCurrentContext();
		CGRect area = CGRectMake(0, 0, src.size.width, src.size.height);
		CGContextScaleCTM(ctx, 1, -1);
		CGContextTranslateCTM(ctx, 0, -area.size.height);
		CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
		CGContextSetAlpha(ctx, alpha);
		CGContextDrawImage(ctx, area, src.CGImage);
		newImage = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
	}
	return newImage;
}

+ (UIImage *)imageWithOverlayColor:(UIImage*)src withColor:(UIColor *)color{
	CGRect rect = CGRectMake(0.0f, 0.0f, src.size.width, src.size.height);
	UIImage *image;
	BOOL c = [DisplayUtils createContextWithSize:src.size];
	if(c){
		CGContextRef context = UIGraphicsGetCurrentContext();
		[src drawAtPoint:CGPointZero];
		CGContextSetBlendMode(context, kCGBlendModeSourceIn);
		CGContextSetFillColorWithColor(context, color.CGColor);
		CGContextFillRect(context, rect);
		image = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
	}
	return image;
}

+ (UIImage*) flipImage:(UIImage*) img{
	UIImage* flipped;
	BOOL c = [DisplayUtils createContextWithSize:img.size];
	if(c){
		CGContextRef ctx = UIGraphicsGetCurrentContext();
		CGRect area = CGRectMake(0, 0, img.size.width, img.size.height);
		CGContextDrawImage(ctx, area, img.CGImage);
		flipped = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
	}
	return flipped;
}

@end
