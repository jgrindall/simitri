//
//  TransObject.h
//  Symmetry
//
//  Created by John on 28/05/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TileObject : NSObject

- (id) initWithXCoord: (int) xcoord withYCoord:(int) ycoord withTransIndex:(NSInteger) transIndex withFullTrans:(CGAffineTransform) fullTrans;

- (BOOL) equals:(TileObject*) trans;

- (CGPoint) getBasicPoint:(CGPoint)p;

@end
