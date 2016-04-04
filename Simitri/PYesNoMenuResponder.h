//
//  PYesNoMenuResponder.h
//  Symmetry
//
//  Created by John on 25/06/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PYesNoMenuResponder <NSObject>

- (void) yesClicked;

- (void) noClicked;

@end
