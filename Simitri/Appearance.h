//
//  Appearance.h
//  Symmetry
//
//  Created by John on 26/05/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Colors.h"
#import <UIKit/UIKit.h>

@interface Appearance : NSObject

typedef enum  {
	SYMM_FONT_SIZE_V_SMALL = 12,
	SYMM_FONT_SIZE_SMALL = 14,
	SYMM_FONT_SIZE_BUTTON = 17,
	SYMM_FONT_SIZE_MED = 15,
	SYMM_FONT_SIZE_LARGE = 22,
	SYMM_FONT_SIZE_NAV = 29
} SymmFontSizes;

+ (void) applyStylesInWindow:(UIWindow*) window;
+ (void) flatToolbar:(UIToolbar*) toolbar;
+ (void) styleCollectionView:(UICollectionView*) collectionView;
+ (void) styleStepper:(UIStepper*) stepper;
+ (UIButton*) flatButtonWithLabel:(NSString*) label withIcon:(NSString*) icon withTheme:(FlatButtonThemes)theme withSize:(CGSize)size;
+ (UIButton*) flatTabButtonWithLabel:(NSString*) label withIcon:(NSString*) icon withSize:(CGSize)size;
+ (NSShadow*) defaultShadow;
+ (UILabel*) labelWithFontSize:(SymmFontSizes)s;
+ (UITextView*) editableTextViewWithFontSize:(SymmFontSizes)s;
+ (UITextView*) textViewWithFontSize:(SymmFontSizes)s;
+ (UIFont*) fontOfSize:(SymmFontSizes)s;
+ (NSDictionary*) navTextAttributes;
@end
