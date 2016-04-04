//
//  FileManager.h
//  Symmetry
//
//  Created by John on 19/05/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GalleryService : NSObject <NSURLSessionDelegate>

typedef enum  {
	GalleryResultOk = 0,
	GalleryResultError,
	GalleryResultInsufficientFilesError,
	GalleryResultUnreachable
} GalleryResults;


+ (GalleryService*) sharedInstance;

- (void) getFilesWithCallback:(void(^)(GalleryResults result))callback;
- (NSArray*) getFiles;
- (void) clear;
- (void) submitData:(NSDictionary*)dic withCallback:(void(^)(GalleryResults result))callback;
+ (NSString*) getTerms;
+ (NSString*) imageUrlForId:(NSString*) _id;

@end

