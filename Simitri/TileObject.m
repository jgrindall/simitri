//
//  TransObject.m
//  Symmetry
//
//  Created by John on 28/05/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "TileObject_Protected.h"
#import "GeomUtils.h"

@implementation TileObject

- (id) initWithXCoord: (int) xcoord withYCoord:(int) ycoord withTransIndex:(NSInteger) transIndex withFullTrans:(CGAffineTransform) fullTrans{
	self = [super init];
	if(self){
		_xcoord = xcoord;
		_ycoord = ycoord;
		_transIndex = transIndex;
		_fullTrans = fullTrans;
	}
	return self;
}

- (BOOL) equals:(TileObject *)trans{
	return [GeomUtils CGAffMatched:self.fullTrans with:trans.fullTrans];
}

- (CGPoint) getBasicPoint:(CGPoint)p{
	return CGPointApplyAffineTransform(p, self.fullTrans);
}

- (NSString*) description{
	return [NSString stringWithFormat:@"TObj %ld %ld %ld %@", (long)self.xcoord, (long)self.ycoord, (long)self.transIndex, NSStringFromCGAffineTransform(self.fullTrans)];
}

@end
