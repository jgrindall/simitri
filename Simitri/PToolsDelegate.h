//
//  PToolsDelegate.h
//  Symmetry
//
//  Created by John on 08/06/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PToolsDelegate <NSObject>

- (void) setColor:(UIColor*)color;
- (void) setBgColor:(UIColor*)bgColor;
- (void) setWidth:(NSInteger)width;
- (void) hide;
- (void) show;

@end
