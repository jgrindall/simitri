//
//  FileCell.h
//  Symmetry
//
//  Created by John on 20/05/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADeleteableCell.h"

@interface FileCell : ADeleteableCell

@property (nonatomic) UIImage* image;
@property (nonatomic) BOOL isAddNew;

+ (UIImage*) getAddNewImg;

@end
