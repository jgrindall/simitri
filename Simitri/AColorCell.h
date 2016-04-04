//
//  AColorCell.h
//  Symmetry
//
//  Created by John on 29/05/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum  {
	AColorCellPositionFirst = 0,
	AColorCellPositionMiddle,
	AColorCellPositionLast
} AColorCellPosition;

@interface AColorCell : UICollectionViewCell

- (void) selectMe;
- (void) deselectMe;

@end
