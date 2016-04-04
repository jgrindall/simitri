//
//  ADeleteableCell.h
//  Symmetry
//
//  Created by John on 20/05/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADeleteableCell : UICollectionViewCell

@property (nonatomic) BOOL isZoomed;
@property (nonatomic) BOOL isAnimating;
@property (nonatomic) BOOL isHighlighted;
@property (nonatomic) BOOL isDeleteShown;
@property UIButton* delButton;

- (void) update;
- (void) teardown;

@end
