//
//  Colors.h
//  Symmetry
//
//  Created by John on 19/05/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Colors : NSObject

typedef enum  {
	FlatButtonThemeDefault = 0,
	FlatButtonThemePositive,
	FlatButtonThemeDanger,
	FlatButtonThemeTab
} FlatButtonThemes;

+ (UIColor*) getColor:(NSInteger)i;
+ (UIColor*) getGridColor;
+ (NSArray*) getAllForeground;
+ (NSArray*) getAllBackground;
+ (UIColor*) defaultFgColorForIndex:(NSInteger)i;
+ (UIColor*) defaultBgColorForIndex:(NSInteger)i;
+ (NSInteger) defaultFgColorIndexForIndex:(NSInteger)i;
+ (NSInteger) defaultBgColorIndexForIndex:(NSInteger)i;
+ (NSInteger) defaultWidthForIndex:(NSInteger)i;
+ (NSInteger) indexForFgColor:(UIColor*) color;
+ (NSInteger) indexForBgColor:(UIColor*) color;

+ (UIColor*) getColorForTheme:(FlatButtonThemes) f;
+ (UIColor*) symmGrayBgColor;
+ (UIColor*) symmGrayTextColor;
+ (UIColor*) symmGrayButtonColor;
+ (UIColor*) symmGrayTextDisabledColor;
+ (UIColor*) symmGrayTextShadowColor;

@end


