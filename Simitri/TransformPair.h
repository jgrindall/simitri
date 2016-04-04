//
//  TransformPair.h
//  Symmetry
//
//  Created by John on 23/06/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TransformPair : NSObject

@property CGAffineTransform affineTransform;
@property CATransform3D ca3dTransform;
@property BOOL is3d;

- (id) initWithCA:(CATransform3D) ca withCG:(CGAffineTransform) cg is3d:(BOOL)is3d;
- (id) initWithCA:(CATransform3D) ca withCG:(CGAffineTransform) cg;

@end
