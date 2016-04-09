//
//  DisplayUtils.h
//  Symmetry
//
//  Created by John on 20/05/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DisplayUtils : NSObject

+ (void) bubbleActionFrom:(UIResponder*) start toClass:(Class) class withSelector:(NSString*) selector withObject:(id) object;
+ (void) bubbleActionFrom:(UIResponder*) start toProtocol:(Protocol*) protocol withSelector:(NSString*) selector withObject:(id) object;
+ (BOOL) createContextWithSize:(CGSize)size;
+ (CGRect) fitFrame:(CGRect) frame inView:(UIView*) view;
+ (void) applyConstraints:(UIView*) container withChild:(UIView*) child withConstraints:(NSArray*)cons;
@end
