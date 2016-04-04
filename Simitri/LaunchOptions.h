//
//  LaunchOptions.h
//  Simitri
//
//  Created by John on 21/06/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LaunchOptions : NSObject

+ (LaunchOptions*) sharedInstance;

- (BOOL) getIsKids;
- (void) setIsKids:(BOOL)isKids;
- (float) getImgQuality;
- (void) decreaseImgQuality;

@end
