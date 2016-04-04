//
//  UIColor+Utils.m
//  Symmetry
//
//  Created by John on 01/06/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "UIColor+Utils.h"
#import "DisplayUtils.h"
#import "Colors.h"

@implementation UIColor (Utils)

- (BOOL) isWhite{
	return [self equals:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]];
}

+ (UIColor*) getGray:(float) f{
	return [UIColor getGray:f withAlpha:1];
}

+ (UIColor*) getGray:(float) f withAlpha:(float)a{
	return [UIColor colorWithRed:f green:f blue:f alpha:a];
}

- (BOOL) equals:(UIColor*)color{
	float tolerance = 0.01;
	const CGFloat* componentColors1 = CGColorGetComponents(self.CGColor);
	const CGFloat* componentColors2 = CGColorGetComponents(color.CGColor);
	float dr = componentColors1[0] - componentColors2[0];
	if(dr<0){
		dr = -dr;
	}
	if(dr > tolerance){
		return NO;
	}
	float dg = componentColors1[1] - componentColors2[1];
	if(dg<0){
		dg = -dg;
	}
	if(dg > tolerance){
		return NO;
	}
	float db = componentColors1[2] - componentColors2[2];
	if(db<0){
		db = -db;
	}
	if(db > tolerance){
		return NO;
	}
	float da = componentColors1[3] - componentColors2[3];
	if(da<0){
		da = -da;
	}
	if(da > tolerance){
		return NO;
	}
	return YES;
}

+ (UIColor *) colorFromHexCode:(NSString *)hexString {
    NSString *cleanString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    if ([cleanString length] == 3) {
        cleanString = [NSString stringWithFormat:@"%@%@%@%@%@%@",
                       [cleanString substringWithRange:NSMakeRange(0, 1)],[cleanString substringWithRange:NSMakeRange(0, 1)],
                       [cleanString substringWithRange:NSMakeRange(1, 1)],[cleanString substringWithRange:NSMakeRange(1, 1)],
                       [cleanString substringWithRange:NSMakeRange(2, 1)],[cleanString substringWithRange:NSMakeRange(2, 1)]];
    }
    if([cleanString length] == 6) {
        cleanString = [cleanString stringByAppendingString:@"ff"];
    }
    
    unsigned int baseValue;
    [[NSScanner scannerWithString:cleanString] scanHexInt:&baseValue];
    
    float red = ((baseValue >> 24) & 0xFF)/255.0f;
    float green = ((baseValue >> 16) & 0xFF)/255.0f;
    float blue = ((baseValue >> 8) & 0xFF)/255.0f;
    float alpha = ((baseValue >> 0) & 0xFF)/255.0f;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

+ (UIColor *)alphaColor:(UIColor *)c{
    CGFloat r, g, b, a;
    [c getRed:&r green:&g blue:&b alpha:&a];
	return [UIColor colorWithRed:r green:g blue:b alpha:0.3];
}

@end
