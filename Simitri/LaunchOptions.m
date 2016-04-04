//
//  FileManager.m
//  Symmetry
//
//  Created by John on 19/05/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "LaunchOptions.h"

@interface LaunchOptions ()
@property BOOL isKidsApp;
@property float quality;
@end

@implementation LaunchOptions

- (id) init{
	self = [super init];
	if(self){
		self.quality = 0.85;
	}
	return self;
}

+ (id)sharedInstance {
    static LaunchOptions* loader = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        loader = [[self alloc] init];
    });
    return loader;
}

- (BOOL) getIsKids{
	return self.isKidsApp;
}

- (void) setIsKids:(BOOL)isKids{
	self.isKidsApp = isKids;
}

- (float)getImgQuality{
	return self.quality;
}

- (void)decreaseImgQuality{
	self.quality = MAX(self.quality*0.85, 0.5);
}


@end
