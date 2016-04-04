//
//  ADeleteableController_Protected.h
//  Symmetry
//
//  Created by John on 20/05/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "ADeleteableController.h"

@interface ADeleteableController ()

@property BOOL editing;
@property NSInteger selected;

- (UICollectionViewCell*) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath withIdentifier:(NSString *)ident withClass:(__unsafe_unretained Class)class;
- (void) performDelete:(NSIndexPath*) path;

@end
