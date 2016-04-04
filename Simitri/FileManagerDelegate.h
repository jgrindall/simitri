//
//  FileManagerDelegate.h
//  FileManager
//
//  Created by John on 26/05/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FileManagerDelegate <NSObject>

- (NSInteger) getSelectedIndex;

- (void) loadFiles :(NSArray*) files;

@end
