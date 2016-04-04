//
//  ImageUtils.h
//  Symmetry
//
//  Created by John on 10/06/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface ImageUtils : NSObject

+ (UIImage*) iconWithName:(NSString*) name andSize:(CGSize)size andColor:(UIColor*)color;
+ (UIImage*) iconWithName:(NSString*) name andSize:(CGSize)size;
+ (UIImage*) disabledIconWithName:(NSString*) name andSize:(CGSize)size;
+ (UIImage*) compositeTopImage:(UIImage*) top withBottomImage:(UIImage*) bottom andSize:(CGSize)size atPoint:(CGPoint)point;
+ (UIImage*) iconWithName:(NSString*) name andSize:(CGSize)size andColor:(UIColor*)color andShadowColor:(UIColor*)shadowColor;
+ (UIImage*) shadowIconWithName:(NSString*) name andSize:(CGSize)size;
+ (UIImage*) shadowIconWithName:(NSString*) name andSize:(CGSize)size andColor:(UIColor*)color;
+ (UIImage*) imageByApplyingAlpha:(UIImage*) src withAlpha:(CGFloat) alpha;
+ (UIImage*) imageWithOverlayColor:(UIImage*) src withColor:(UIColor *)color;
+ (UIImage*) imageWithColor:(UIColor *)color cornerRadius:(CGFloat)cornerRadius;
+ (UIImage*) flipImage:(UIImage*) img;
+ (UIImage*) loadImageNamed:(NSString*) filename;
+ (UIImage*) optimize:(UIImage*) src;
+ (UIImage*) blur:(UIImage*)src;
+ (void) emptyCache;

@end
