//
//  AnimationUtils.h
//  Symmetry
//
//  Created by John on 20/05/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Colors.h"

@interface AnimationUtils : NSObject

+ (void) addZoomTo:(UIView*) cell;
+ (void) addWiggleTo:(UIView*) cell;
+ (void) addZoomAndWiggleTo:(UIView*) cell;
+ (void) flashButton:(UIButton*) button withTheme:(FlatButtonThemes) theme withDelay0:(float) delay0 withDelay1:(float)delay1 withCallback:(void(^)(BOOL success))callback;
+ (void) flashLabel:(UILabel*) button withTheme:(FlatButtonThemes) theme withDelay0:(float) delay0 withDelay1:(float)delay1 withCallback:(void(^)(BOOL success))callback;
+ (void) bounceAnimateView:(UIView*) view from:(float) fromPos to:(float) toPos withKeyPath:(NSString*) keyPath withKey:(NSString*) key withDelegate:(id)delegate withDuration:(float)duration withImmediate:(BOOL)immediate;
@end
