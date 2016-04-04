//
//  SoundManager.h
//  Sounds
//
//  Created by John on 03/06/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SoundManager : NSObject

+ (id)sharedInstance;

- (void) playClick;
- (void) playSuccess;
- (void) playError;


@end
