//
//  SoundManager.m
//  Sounds
//
//  Created by John on 03/06/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "SoundManager.h"
#import <AudioToolbox/AudioToolbox.h>

@implementation SoundManager
{
	SystemSoundID clickId;
	SystemSoundID successId;
	SystemSoundID errorId;
}

+ (id)sharedInstance {
    static SoundManager* manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
		[manager setupAll];
    });
    return manager;
}

- (void) setupAll{
	NSURL* file1 = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"click" ofType:@"wav"]];
	CFURLRef click = (__bridge CFURLRef)file1;
	AudioServicesCreateSystemSoundID(click, &clickId);
	
	NSURL* file2 = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"success" ofType:@"wav"]];
	CFURLRef success = (__bridge CFURLRef)file2;
	AudioServicesCreateSystemSoundID(success, &successId);
	
	NSURL* file3 = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"error" ofType:@"wav"]];
	CFURLRef error = (__bridge CFURLRef)file3;
	AudioServicesCreateSystemSoundID(error, &errorId);
}

- (void) playClick{
	//AudioServicesPlaySystemSound(clickId);
}

- (void) playSuccess{
	//AudioServicesPlaySystemSound(successId);
}

- (void) playError{
	//AudioServicesPlaySystemSound(errorId);
}

@end

