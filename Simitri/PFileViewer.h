//
//  PFileViewer.h
//  Symmetry
//
//  Created by John on 23/05/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PFileViewer <NSObject>

- (NSInteger) getSelectedIndex;
- (void) loadFiles:(NSArray*) files;

@end
