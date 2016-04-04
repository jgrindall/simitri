//
//  TemplateConfig.h
//  Symmetry
//
//  Created by John on 23/06/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TemplateConfig : NSObject

+ (TemplateConfig*) sharedInstance;

- (void) setShowMathConfig:(BOOL)show;
- (BOOL) getShowMathConfig;

@end
