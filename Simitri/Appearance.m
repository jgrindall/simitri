//
//  Appearance.m
//  Symmetry
//
//  Created by John on 26/05/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "Appearance.h"
#import "MyFilesScreenController.h"
#import "UIColor+Utils.h"
#import "DrawingViewController.h"
#import "AbstractDrawingView.h"
#import "ToolsBarViewController.h"
#import "WidthIndicator.h"
#import "WidthViewController.h"
#import "LayoutConsts.h"
#import "TilePopupViewController.h"
#import "SaveCurrentViewController.h"
#import "ImageUtils.h"
#import "Colors.h"
#import <CoreText/CoreText.h>

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)
@implementation Appearance

+ (void)applyStylesInWindow:(UIWindow*) window{
	[Appearance applyNavBarStyleInWindow:window];
	//[Appearance applyToolBarStyleInWindow:window];
	//[Appearance applyViewStyleInWindow:window];
	//window.tintColor = [Colors getColorForTheme:FlatButtonThemeDefault];
}

+ (NSDictionary*) navTextAttributes{
	UIColor* textColor = [Colors getColorForTheme:FlatButtonThemeDefault];
	UIFont* textFont = [Appearance fontOfSize:SYMM_FONT_SIZE_NAV];
	NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:textFont, NSFontAttributeName,  textColor, NSForegroundColorAttributeName, [Appearance defaultShadow], NSShadowAttributeName, nil];
	return  dic;
}

+ (void) applyNavBarStyleInWindow:(UIWindow*) window{
	UINavigationController* navigationController = (UINavigationController*) (window.rootViewController);
	UINavigationBar* bar = navigationController.navigationBar;
	//bar.titleTextAttributes = [Appearance navTextAttributes];
    //[bar setBackgroundImage:[ImageUtils imageWithColor:[Colors symmGrayBgColor] cornerRadius:0] forBarMetrics:UIBarMetricsDefault & UIBarMetricsCompact];
	//if ([bar respondsToSelector:@selector(setShadowImage:)]) {
       //[bar setShadowImage:[ImageUtils imageWithColor:[Colors symmGrayBgColor] cornerRadius:0]];
    //}
}

+ (void) applyToolBarStyleInWindow:(UIWindow*) window{
	[[UIToolbar appearance] setBackgroundColor:[UIColor whiteColor]];
}

+ (void) styleCollectionView:(UICollectionView*) collectionView{
	UIView *bgView = [[UIView alloc] init];
	bgView.backgroundColor = [UIColor whiteColor];
	[collectionView.backgroundView removeFromSuperview];
	collectionView.backgroundView = bgView;
}

+ (void) styleStepper:(UIStepper*) stepper{
	[stepper setIncrementImage:[ImageUtils iconWithName:@"plus.png" andSize:CGSizeMake(24, 24)] forState:UIControlStateNormal];
	[stepper setDecrementImage:[ImageUtils iconWithName:@"minus.png" andSize:CGSizeMake(24, 24)] forState:UIControlStateNormal];
	UIImage *normalImage = [ImageUtils imageWithColor:[UIColor clearColor] cornerRadius:0];
	UIImage *highlightedImage = [ImageUtils imageWithColor:[UIColor clearColor] cornerRadius:0];
	UIImage *disabledImage = [ImageUtils imageWithColor:[UIColor clearColor] cornerRadius:0];
	[stepper setBackgroundImage:normalImage forState:UIControlStateNormal];
	[stepper setBackgroundImage:highlightedImage forState:UIControlStateHighlighted];
	[stepper setBackgroundImage:disabledImage forState:UIControlStateDisabled];
	[stepper setDividerImage:[ImageUtils imageWithColor:[UIColor clearColor] cornerRadius:0] forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal];
	[stepper setDividerImage:[ImageUtils imageWithColor:[UIColor clearColor] cornerRadius:0] forLeftSegmentState:UIControlStateHighlighted rightSegmentState:UIControlStateNormal];
	[stepper setDividerImage:[ImageUtils imageWithColor:[UIColor clearColor] cornerRadius:0] forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateHighlighted];
}

+ (void) applyViewStyleInWindow:(UIWindow*) window{
	[[UILabel appearance] setBackgroundColor:[UIColor clearColor]];
	[[UITextView appearance] setBackgroundColor:[UIColor clearColor]];
	[[UICollectionView appearance] setBackgroundColor:[UIColor clearColor]];
	[[UIView appearanceWhenContainedIn:[UICollectionView class], nil] setBackgroundColor:[UIColor clearColor]];
	[[UIView appearanceWhenContainedIn:[UICollectionViewController class], nil] setBackgroundColor:[UIColor clearColor]];
	[[UIView appearanceWhenContainedIn:[DrawingViewController class], nil] setBackgroundColor:[UIColor clearColor]];
	[[UIView appearanceWhenContainedIn:[AbstractDrawingView class], nil] setBackgroundColor:[UIColor clearColor]];
	[[UIView appearanceWhenContainedIn:[UIPageControl class], nil] setBackgroundColor:[Colors symmGrayTextDisabledColor]];
	[[UIImageView appearance] setBackgroundColor:[UIColor clearColor]];
	[[UIPageControl appearance] setPageIndicatorTintColor:[Colors symmGrayTextDisabledColor]];
	[[UIPageControl appearance] setCurrentPageIndicatorTintColor:[Colors symmGrayButtonColor]];
	[[UIStepper appearance] setBackgroundColor:[UIColor clearColor]];
	[[UIView appearanceWhenContainedIn:[WidthIndicator class], nil] setBackgroundColor:[UIColor clearColor]];
	[[UIView appearanceWhenContainedIn:[WidthViewController class], nil] setBackgroundColor:[UIColor clearColor]];
	[[UIView appearanceWhenContainedIn:[TilePopupViewController class], nil] setBackgroundColor:[UIColor clearColor]];
	[[UIView appearanceWhenContainedIn:[UIPopoverController class], nil] setBackgroundColor:[UIColor clearColor]];
	NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:[Appearance fontOfSize:SYMM_FONT_SIZE_BUTTON], NSFontAttributeName,  [Colors symmGrayTextColor], NSForegroundColorAttributeName, [Appearance defaultShadow], NSShadowAttributeName, nil];
	NSDictionary* dic1 = [NSDictionary dictionaryWithObjectsAndKeys:[Appearance fontOfSize:SYMM_FONT_SIZE_BUTTON], NSFontAttributeName, [Colors getColorForTheme:FlatButtonThemeDefault], NSForegroundColorAttributeName, [Appearance defaultShadow], NSShadowAttributeName, nil];
	[[UIBarButtonItem appearance] setTitleTextAttributes:dic forState:UIControlStateNormal];
	[[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:dic1 forState:UIControlStateNormal];
}

+ (void) flatToolbar:(UIToolbar*) toolbar{
	toolbar.translucent = NO;
	toolbar.barTintColor = [UIColor whiteColor];
	toolbar.layer.borderWidth = 0;
	toolbar.layer.borderColor = [[UIColor clearColor] CGColor];
	[toolbar setClipsToBounds:YES];
}

+ (NSShadow*) defaultShadow{
	NSShadow* shadow = [[NSShadow alloc] init];
	shadow.shadowColor = [Colors symmGrayTextShadowColor];
    shadow.shadowBlurRadius = 3.0;
    shadow.shadowOffset = CGSizeMake(1.0, 1.0);
	return shadow;
}

+ (UIButton*) flatButtonWithLabel:(NSString*) label withIcon:(NSString*) icon withTheme:(FlatButtonThemes)theme withSize:(CGSize)size{
	if(theme == FlatButtonThemeTab){
		return [Appearance flatButtonWithLabel:label withHighlightColor:[Colors getColorForTheme:theme] withSize:size withFontSize:SYMM_FONT_SIZE_MED withCorner:0.0 withShadow:0.0 disableColor:[Colors symmGrayTextDisabledColor] activeColor:[Colors symmGrayTextDisabledColor] withIcon:icon withIconSize:CGSizeMake(LAYOUT_DEFAULT_ICON_SIZE, LAYOUT_DEFAULT_ICON_SIZE) withBg:[UIColor clearColor]];
	}
	else{
		return [Appearance flatButtonWithLabel:label withHighlightColor:[Colors getColorForTheme:theme] withSize:size withFontSize:SYMM_FONT_SIZE_MED withCorner:0.0 withShadow:0.0 disableColor:[Colors symmGrayTextDisabledColor] activeColor:[Colors symmGrayButtonColor] withIcon:icon withIconSize:CGSizeMake(LAYOUT_DEFAULT_ICON_SIZE, LAYOUT_DEFAULT_ICON_SIZE) withBg:[UIColor clearColor]];
	}
	
}

+ (UILabel*) labelWithFontSize:(SymmFontSizes)s{
	UILabel* label = [[UILabel alloc] init];
	label.font = [Appearance fontOfSize:s];
	label.textColor = [Colors symmGrayTextColor];
	label.backgroundColor = [UIColor clearColor];
	return label;
}

+ (UITextView*) editableTextViewWithFontSize:(SymmFontSizes)s{
	UITextView* text = [[UITextView alloc] init];
	text.font = [Appearance fontOfSize:s];
	text.textColor = [Colors symmGrayTextColor];
	text.backgroundColor = [UIColor whiteColor];
	text.editable = YES;
	return text;
}

+ (UITextView*) textViewWithFontSize:(SymmFontSizes)s{
	UITextView* text = [[UITextView alloc] init];
	text.font = [Appearance fontOfSize:s];
	text.textColor = [Colors symmGrayTextColor];
	text.backgroundColor = [UIColor clearColor];
	text.editable = NO;
	text.selectable = NO;
	return text;
}

+ (UIFont*) fontOfSize:(SymmFontSizes)s{
	static dispatch_once_t onceToken;
	NSString* fontName = @"Thonburi";
    dispatch_once(&onceToken, ^{
        NSURL* url = [[NSBundle mainBundle] URLForResource:fontName withExtension:@"ttf"];
		if(url){
			CFErrorRef error;
			CTFontManagerRegisterFontsForURL((__bridge CFURLRef)url, kCTFontManagerScopeNone, &error);
		}
    });
    return [UIFont fontWithName:fontName size:s];
}

+ (UIButton*) flatButtonWithLabel:(NSString*)label withHighlightColor:(UIColor*)highlightColor withSize:(CGSize) size withFontSize:(SymmFontSizes) fontSize withCorner:(float)corner withShadow:(float)shadow disableColor:(UIColor*)disClr activeColor:(UIColor*)activeColor withIcon:(NSString*)icon withIconSize:(CGSize)iconSize withBg:(UIColor*)bg{
	UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
	[button setTitle:label forState:UIControlStateNormal];
	button.titleLabel.text = label;
	button.titleLabel.font = [Appearance fontOfSize:fontSize];
	[button setTitleColor:activeColor forState:UIControlStateNormal];
	[button setTitleColor:disClr forState:UIControlStateDisabled];
	[button setTitleColor:highlightColor forState:UIControlStateHighlighted];
	//NSShadow* defaultShadow = [Appearance defaultShadow];
	//[button setTitleShadowColor:[defaultShadow shadowColor] forState:UIControlStateNormal];
	//[button setTitleShadowColor:[defaultShadow shadowColor] forState:UIControlStateDisabled];
	//[button setTitleShadowColor:[defaultShadow shadowColor] forState:UIControlStateHighlighted];
	//button.titleLabel.shadowOffset = [defaultShadow shadowOffset];
	button.backgroundColor = bg;
	if(icon){
		UIImage* iconImg = [ImageUtils iconWithName:icon andSize:iconSize andColor:activeColor];
		UIImage* iconImgHighlighted = [ImageUtils iconWithName:icon andSize:iconSize andColor:highlightColor];
		UIImage* iconImgDisabled = [ImageUtils disabledIconWithName:icon andSize:iconSize];
		[button setImage:iconImg forState:UIControlStateNormal];
		[button setImage:iconImgHighlighted forState:UIControlStateHighlighted];
		[button setImage:iconImgDisabled forState:UIControlStateDisabled];
	}
	[button setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
	return button;
}

+ (UIButton*) flatTabButtonWithLabel:(NSString*) label withIcon:(NSString*) icon withSize:(CGSize)size{
	return [Appearance flatButtonWithLabel:label withHighlightColor:[Colors getColorForTheme:FlatButtonThemeDefault] withSize:size withFontSize:18 withCorner:0 withShadow:0 disableColor:[Colors symmGrayBgColor] activeColor:[Colors symmGrayButtonColor] withIcon:icon withIconSize:CGSizeMake(LAYOUT_DEFAULT_ICON_SIZE, LAYOUT_DEFAULT_ICON_SIZE) withBg:[UIColor clearColor]];
}

@end
