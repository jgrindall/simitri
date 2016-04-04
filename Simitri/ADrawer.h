//
//  ADrawer.h
//  Symmetry
//
//  Created by John on 18/05/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Polygon.h"
#import "TileObject.h"
#import "TransformPair.h"
#import <UIKit/UIKit.h>

@interface ADrawer : NSObject

@property UIImage* gridImage;
@property NSArray* flippedTransforms;
@property CGRect basicRect;
@property UIImage* mathImage;
@property UIImage* demoImage;

- (id) initWithScreenSize:(CGSize)screenSize withDrawerNum:(NSInteger)drawerNum;
- (TileObject*) getTrans:(CGPoint)p;
- (TransformPair*) getMathTransformForPoint:(CGPoint) p atTime:(float)t;

@end
