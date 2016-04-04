//
//  MyFilesCollectionController.h
//  Symmetry
//
//  Created by John on 19/05/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADeleteableController_Protected.h"
#import "PFileViewer.h"

@interface TilesCollectionController : ADeleteableController <PFileViewer>

- (id)initWithCollectionViewLayout:(UICollectionViewLayout*) layout withCellIdent:(NSString*)ident withCellClass:(Class)class;

@end
