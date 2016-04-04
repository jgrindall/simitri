
//  AnimationUtils.m
//  Symmetry
//
//  Created by John on 20/05/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "AnimationUtils.h"
#import "Appearance.h"
#import "UIColor+Utils.h"
#import "SKBounceAnimation.h"

#define kWiggleBounceY 3.0f
#define kWiggleBounceDuration 0.15
#define kWiggleBounceDurationVariance 0.025
#define kWiggleRotateAngle 0.02f
#define kWiggleRotateDuration 0.2
#define kWiggleRotateDurationVariance 0.02
#define kAlpha 0.6

@implementation AnimationUtils

+ (void) addZoomTo:(UIView*) cell{
	[UIView animateWithDuration:0 animations:^{
		cell.transform = CGAffineTransformMakeScale(1.1, 1.1);
		cell.alpha=kAlpha;
	}];
}

+ (void) addZoomAndWiggleTo:(UIView*) cell{
	[UIView animateWithDuration:0 animations:^{
		[cell.layer addAnimation:[AnimationUtils rotationAnimation] forKey:@"rotation"];
		[cell.layer addAnimation:[AnimationUtils bounceAnimation] forKey:@"bounce"];
		cell.transform = CGAffineTransformMakeScale(1.1, 1.1);
		cell.alpha = kAlpha;
	}];
}

+ (void) addWiggleTo:(UIView*) cell{
	[UIView animateWithDuration:0 animations:^{
		[cell.layer addAnimation:[AnimationUtils rotationAnimation] forKey:@"rotation"];
		[cell.layer addAnimation:[AnimationUtils bounceAnimation] forKey:@"bounce"];
		cell.transform = CGAffineTransformIdentity;
		cell.alpha = 1.0;
	}];
}

+(CAAnimation*)rotationAnimation {
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.values = @[@(-kWiggleRotateAngle), @(kWiggleRotateAngle)];
    animation.autoreverses = YES;
    animation.duration = [AnimationUtils randomizeInterval:kWiggleRotateDuration withVariance:kWiggleRotateDurationVariance];
    animation.repeatCount = HUGE_VALF;
    return animation;
}

+(CAAnimation*)bounceAnimation {
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.y"];
    animation.values = @[@(kWiggleBounceY), @(0.0)];
    animation.autoreverses = YES;
    animation.duration = [AnimationUtils randomizeInterval:kWiggleBounceDuration withVariance:kWiggleBounceDurationVariance];
    animation.repeatCount = HUGE_VALF;
    return animation;
}

+(NSTimeInterval)randomizeInterval:(NSTimeInterval)interval withVariance:(double)variance {
    double random = (arc4random_uniform(1000) - 500.0) / 500.0;
    return interval + variance * random;
}

+ (void) flashButton:(UIButton*) button withTheme:(FlatButtonThemes) theme withDelay0:(float) delay0 withDelay1:(float)delay1 withCallback:(void(^)(BOOL success))callback{
	UILabel *label;
	for (NSObject *view in button.subviews) {
		if ([view isKindOfClass:[UILabel class]]) {
			label = (UILabel *)view;
			break;
		}
	}
	if(label){
		[AnimationUtils flashLabel:label withTheme:theme withDelay0:delay0 withDelay1:delay1 withCallback:callback];
	}
}

+ (void) flashLabel:(UILabel*) label withTheme:(FlatButtonThemes) theme withDelay0:(float) delay0 withDelay1:(float)delay1 withCallback:(void(^)(BOOL success))callback{
	[AnimationUtils colorizeLabelForAWhile:label withColor:[Colors getColorForTheme:theme] withDelay0:delay0 withDelay1:delay1 inTime:0.3 outTime:0.5 withCallback:callback];
}

+ (void) bounceAnimateView:(UIView*) view from:(float) fromPos to:(float) toPos withKeyPath:(NSString*) keyPath withKey:(NSString*) key withDelegate:(id)delegate withDuration:(float)duration withImmediate:(BOOL)immediate{
	[view.layer removeAllAnimations];
	NSNumber* finalValue = [NSNumber numberWithFloat:toPos];
	if(!immediate){
		SKBounceAnimation *bounceAnimation = [SKBounceAnimation animationWithKeyPath:keyPath];
		bounceAnimation.delegate = delegate;
		bounceAnimation.fromValue = [NSNumber numberWithFloat:fromPos];
		bounceAnimation.toValue = finalValue;
		bounceAnimation.duration = duration;
		bounceAnimation.numberOfBounces = 3;
		bounceAnimation.stiffness = SKBounceAnimationStiffnessLight;
		bounceAnimation.shouldOvershoot = YES;
		[view.layer addAnimation:bounceAnimation forKey:key];
	}
	[view.layer setValue:finalValue forKeyPath:keyPath];
}

+(void)colorizeLabelForAWhile:(UILabel *)label withColor:(UIColor *)tempColor withDelay0:(float) delay0 withDelay1:(float)delay1 inTime:(float)t0 outTime:(float)t1 withCallback:(void (^)(BOOL))callback{
	UILabel *tempLabel = [[UILabel alloc] init];
    tempLabel.textColor = tempColor;
    tempLabel.font = label.font;
    tempLabel.alpha = 0;
    tempLabel.textAlignment = label.textAlignment;
    tempLabel.text = label.text;
    [label.superview addSubview:tempLabel];
    tempLabel.frame = label.frame;
	[UIView animateWithDuration:t0 delay:delay0 options:UIViewAnimationOptionCurveLinear animations:^{
		tempLabel.alpha = 1;
		label.alpha = 0;
		label.transform = CGAffineTransformMakeScale(1.05, 1.05);
	} completion:^(BOOL finished) {
		[UIView animateWithDuration:t1 delay:delay1 options:UIViewAnimationOptionCurveLinear animations:^{
			 label.alpha = 1;
			 tempLabel.alpha = 0;
			label.transform = CGAffineTransformMakeScale(1, 1);
		 }
		 completion:^(BOOL finished){
			 [tempLabel removeFromSuperview];
			 callback(YES);
		 }];
	}];
}

@end

