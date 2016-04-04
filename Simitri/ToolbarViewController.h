//
//  ToolbarViewController.h
//  Symmetry
//
//  Created by John on 26/05/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Colors.h"

@interface ToolbarViewController : UIViewController

- (UIButton*) addButtonWithLabel:(NSString*)label clickSelector:(SEL)sel withTrailingSpace:(BOOL) tSpc withLeadingSpace:(BOOL)lSpc withSize:(CGSize)size withIcon:(NSString*) icon withTheme:(FlatButtonThemes)theme;
- (UIButton*) addTabButtonWithLabel:(NSString*)label clickSelector:(SEL)sel withNum:(NSInteger)num withIcon:(NSString*) icon withTheme:(FlatButtonThemes)theme;
- (void) enableButtonAtIndex:(NSInteger)i enabled:(BOOL)enable;
@end
