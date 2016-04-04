//
//  PTemplateViewer.h
//  Symmetry
//
//  Created by John on 07/06/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PTemplateViewer <NSObject>

- (NSInteger) getSelectedIndex;
- (NSInteger) getNumberOfPages;
- (void) swipeLeft;
- (void) swipeRight;
@end
