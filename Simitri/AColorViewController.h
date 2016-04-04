//
//  ColorViewController.h
//  Symmetry
//
//  Created by John on 19/05/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PColorView.h"

@interface AColorViewController : UICollectionViewController <PColorView>

- (id)initWithCollectionViewLayout:(UICollectionViewLayout*) layout withCellIdent:(NSString*)ident withCellClass:(Class)class withColor:(NSInteger)color;

@end
