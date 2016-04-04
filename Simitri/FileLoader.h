//
//  FileManager.h
//  Symmetry
//
//  Created by John on 19/05/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DrawingDocument.h"
#import "DrawingObject.h"
#import "FileLoaderUtils.h"

@interface FileLoader : NSObject

+ (FileLoader*) sharedInstance;

- (void) saveCurrentFile:(DrawingObject*) drawingObject withImages:(NSArray*) thumbs withCallback:(void(^)(FileLoaderResults result))callback;
- (void) saveCurrentFileWithCallback:(void(^)(FileLoaderResults result))callback;
- (void) deleteFileAtItem:(NSInteger) item withCallback:(void(^)(FileLoaderResults result))callback;
- (void) openFile : (NSURL*) url withForce:(BOOL)force withCallback:(void(^)(FileLoaderResults result))callback;
- (void) openFileWithIndex:(NSInteger)i withForce:(BOOL)force withCallback:(void(^)(FileLoaderResults result))callback;
- (void) startNewFileWithForce:(BOOL)force withCallback:(void (^)(FileLoaderResults result))callback;
- (NSString*) getSmallImgFilenameForUrl:(NSURL*) url;
- (NSString*) getMedImgFilenameForUrl:(NSURL*) url;
- (NSString*) getLargeImgFilenameForUrl:(NSURL*) url;
- (NSInteger) getDrawerNumFromFileName:(NSString*) url;
- (DrawingObject*) getCurrentDrawingObject;
- (NSString*) getStoredState;
- (NSArray*) getYourFiles;
- (void) clearStoredState;
- (void) storeState;
- (NSInteger) fileExists:(NSURL*) url;

@property (readonly) BOOL enabled;
@property (readonly) DrawingDocument* currentDoc;
@property DrawingObject* scratchObj;
@property NSArray* tempThumbs;

@end

