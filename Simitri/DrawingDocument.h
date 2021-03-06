//
//  DrawingDocument.h
//  Symmetry
//
//  Created by John on 19/05/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrawingObject.h"
#import "FileLoaderUtils.h"

@interface DrawingDocument : UIDocument

@property DrawingObject* obj;
@property (readonly) NSURL* url;
@property BOOL dirty;

- (void) saveWithCallback:(void(^)(FileLoaderResults result))callback;

@end
