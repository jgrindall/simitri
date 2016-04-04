//
//  UIColor+Utils.h
//  Symmetry
//
//  Created by John on 01/06/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Utils)

- (BOOL) isWhite;

+ (UIColor*) getGray:(float) f;
+ (UIColor*) getGray:(float) f withAlpha:(float)a;
- (BOOL) equals:(UIColor*)color;
+ (UIColor *) colorFromHexCode:(NSString *)hexString;
+ (UIColor *)alphaColor:(UIColor *)c;

@end
