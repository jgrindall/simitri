//
//  TemplateConfig.m
//  Symmetry
//
//  Created by John on 23/06/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "TemplateConfig.h"
#import "SymmNotifications.h"

@interface TemplateConfig()

@property BOOL showMath;

@end

@implementation TemplateConfig

+ (id)sharedInstance {
    static TemplateConfig* config = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        config = [[self alloc] init];
    });
    return config;
}

- (void) setShowMathConfig:(BOOL)show{
	self.showMath = show;
	NSNumber* showNumber = [NSNumber numberWithBool:show];
	[[NSNotificationCenter defaultCenter] postNotificationName:SYMM_NOTIF_SHOW_TPL_INFO object:nil userInfo:@{@"show":showNumber}];
}

- (BOOL) getShowMathConfig{
	return self.showMath;
}

@end







