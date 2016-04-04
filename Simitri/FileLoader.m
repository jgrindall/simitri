//
//  FileManager.m
//  Symmetry
//
//  Created by John on 19/05/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "FileLoader.h"
#import "SymmNotifications.h"
#import "ImageUtils.h"
#import "LayoutConsts.h"

@interface FileLoader ()

@property NSFileManager* fileManager;
@property NSURL* savesFolder;
@property BOOL enabled;
@property NSMutableArray* files;
@property DrawingDocument* currentDoc;

+ (NSString*) getUUID;

@end

@implementation FileLoader

+ (id)sharedInstance {
    static FileLoader* loader = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        loader = [[self alloc] init];
    });
    return loader;
}

- (id)init {
	if (self = [super init]) {
		self.fileManager = [NSFileManager defaultManager];
		self.enabled = [self makeFolders];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fileChanged) name:SYMM_NOTIF_FILE_CHANGED object:nil];
		[self addObserver:self forKeyPath:@"currentDoc" options:NSKeyValueObservingOptionNew context:nil];
	}
	return self;
}

- (BOOL) makeFolders{
	NSArray* array = [self.fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
	if([array count] == 0){
		return NO;
	}
	NSURL* dir = array[0];
	NSError* error;
	NSString* bundle = [[NSBundle mainBundle] bundleIdentifier];
	NSURL* folder = [dir URLByAppendingPathComponent:bundle];
	BOOL folderExists = [self.fileManager fileExistsAtPath:[folder path] ];
	if(!folderExists){
		[self.fileManager createDirectoryAtURL:folder withIntermediateDirectories:YES attributes:nil error:&error];
		if(error) {
			return NO;
		}
	}
	self.savesFolder = folder;
	return YES;
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
	[[NSNotificationCenter defaultCenter] postNotificationName:SYMM_NOTIF_CURRENT_FILE_CHANGE object:nil];
}

- (void) fileChanged{
	if(self.currentDoc){
		self.currentDoc.dirty = YES;
	}
}

- (void) newFileWithObj:(DrawingObject*)obj withCallBack:(void (^)(FileLoaderResults result))callback{
	NSURL* newFileUrl = [self getNewFilenameWithNum:obj.drawerNum];
	DrawingDocument* doc = [[DrawingDocument alloc] initWithFileURL:newFileUrl];
	if([[self fileManager] fileExistsAtPath:[newFileUrl path] isDirectory:nil]){
		callback(FileLoaderResultUnknownError);
	}
	else{
		[doc saveToURL:newFileUrl forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
			if(success) {
				self.currentDoc = doc;
				callback(FileLoaderResultOk);
			}
			else{
				callback(FileLoaderResultUnknownError);
			}
		}];
	}
}

- (void) performOpen : (NSURL*) url withCallback:(void(^)(FileLoaderResults result))callback{
	BOOL isDir;
	BOOL exists = [[self fileManager] fileExistsAtPath:[url path] isDirectory:&isDir];
 	if(!exists){
		callback(FileLoaderResultUnknownError);
	}
	else{
		DrawingDocument* doc = [[DrawingDocument alloc] initWithFileURL:url];
		[doc openWithCompletionHandler:^(BOOL success) {
			if(success) {
				self.currentDoc = doc;
				callback(FileLoaderResultOk);
			}
			else{
				callback(FileLoaderResultUnknownError);
			}
		}];
	}
}

- (NSInteger) fileExists:(NSURL*) urlSearch{
	if(!self.files){
		return -1;
	}
	for(int i = 0; i < self.files.count; i++){
		NSURL* url = (NSURL*)(self.files[i]);
		if(url && [url isEqual:urlSearch]){
			return i;
		}
	}
	return -1;
}

- (NSArray*) getYourFiles{
	NSArray* array;
	[self getFiles];
	array = [self.files copy];
	return array;
}

- (void) getFiles{
	NSNumber* isDir;
	NSError* error;
	self.files = [NSMutableArray array];
	NSArray* keys = @[NSURLNameKey, NSURLFileSizeKey, NSURLIsDirectoryKey, NSURLContentModificationDateKey];
	NSDirectoryEnumerator* enumerator = [self.fileManager enumeratorAtURL:self.savesFolder includingPropertiesForKeys:keys options:0 errorHandler:^BOOL(NSURL *url, NSError *error) {
		return YES;
	}];
	for(NSURL* url in enumerator){
		[url getResourceValue:&isDir forKey:NSURLIsDirectoryKey error:&error];
		[url getResourceValue:&isDir forKey:NSURLContentModificationDateKey error:&error];
		if([url.pathExtension isEqualToString:@"dat"]){
			[self.files addObject:url];
		}
	}
	[self.files sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
		NSURL* url1 = (NSURL*) obj1;
		NSURL* url2 = (NSURL*) obj2;
		NSDate* d1 = nil;
		NSDate* d2 = nil;
		[url1 getResourceValue:&d1 forKey:NSURLContentModificationDateKey error:nil];
		[url2 getResourceValue:&d1 forKey:NSURLContentModificationDateKey error:nil];
		if([d1 laterDate:d2]){
			return NSOrderedAscending;
		}
		else if([d2 laterDate:d1]){
			return NSOrderedDescending;
		}
		else {
			return NSOrderedSame;
		}
	}];
}

- (void) deleteFileAtItem:(NSInteger) item withCallback:(void(^)(FileLoaderResults result))callback{
	NSURL* url = [self.files objectAtIndex:item];
	if(self.currentDoc && [self.currentDoc.url isEqual:url]){
		[self.currentDoc closeWithCompletionHandler:^(BOOL success) {
			if(success){
				self.currentDoc = nil;
				[self deleteFileAtItem:item withCallback:callback];
			}
			else{
				callback(FileLoaderResultUnknownError);
			}
		}];
	}
	else{
		NSError* error = nil;
		[self.fileManager removeItemAtURL:url error:&error];
		if(error){
			callback(FileLoaderResultUnknownError);
		}
		else{
			[self.files removeObjectAtIndex:item];
			callback(FileLoaderResultOk);
		}
	}
}

- (void) makeScratchWithCallback:(void (^)(FileLoaderResults result))callback{
	self.currentDoc = nil;
	self.scratchObj = [[DrawingObject alloc] init];
	self.tempThumbs = nil;
	callback(FileLoaderResultOk);
}

- (void) startNewFileWithForce:(BOOL)force withCallback:(void (^)(FileLoaderResults result))callback{
	if(self.currentDoc && self.currentDoc.dirty &&!force){
		callback(FileLoaderResultCheckSaveWanted);
	}
	else if(self.scratchObj && self.tempThumbs && self.tempThumbs.count>=1 && !force){
		callback(FileLoaderResultCheckSaveWanted);
	}
	else if(self.currentDoc){
		[self.currentDoc closeWithCompletionHandler:^(BOOL success) {
			if(success){
				[self makeScratchWithCallback:callback];
			}
			else{
				callback(FileLoaderResultUnknownError);
			}
		}];
	}
	else{
		[self makeScratchWithCallback:callback];
	}
}

- (DrawingObject*) getCurrentDrawingObject{
	if(self.currentDoc){
		return self.currentDoc.obj;
	}
	else{
		return self.scratchObj;
	}
}

- (NSInteger) getDrawerNumFromFileName:(NSString*) url{
	NSArray* comp = [url componentsSeparatedByString:@"_"];
	if(comp.count >= 1){
		NSString* stringIndex = comp[0];
		return [stringIndex intValue];
	}
	return -1;
}

- (void) clearStoredState{
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"currentDocUrl"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString*) getStoredState{
	return [[NSUserDefaults standardUserDefaults] objectForKey:@"currentDocUrl"];
}

- (void) storeState{
	if(self.currentDoc){
		NSString* url = self.currentDoc.url.absoluteString;
		[[NSUserDefaults standardUserDefaults] setObject:url forKey:@"currentDocUrl"];
	}
	else{
		[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"currentDocUrl"];
	}
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (void) openFileWithIndex:(NSInteger)i withForce:(BOOL)force withCallback:(void(^)(FileLoaderResults result))callback{
	if(i>=0 && i < self.files.count){
		NSURL* url = [self.files objectAtIndex:i];
		[self openFile:url withForce:force withCallback:callback];
	}
	else{
		callback(FileLoaderResultUnknownError);
	}
}

- (void) openFile:(NSURL*) url withForce:(BOOL)force withCallback:(void(^)(FileLoaderResults result))callback{
	if(!self.currentDoc){
		[self performOpen:url withCallback:callback];
	}
	else{
		if([self.currentDoc.url.path isEqualToString:url.path]){
			callback(FileLoaderResultAlreadyOpen);
		}
		else if(!force && self.currentDoc.dirty){
			callback(FileLoaderResultCheckSaveWanted);
		}
		else{
			[self.currentDoc closeWithCompletionHandler:^(BOOL success) {
				if(success){
					self.currentDoc = nil;
					self.scratchObj = nil;
					[self performOpen:url withCallback:callback];
				}
				else{
					callback(FileLoaderResultUnknownError);
				}
			}];
		}
	}
}

- (void) performSave:(DrawingObject*) drawingObject withImages:(NSArray*)thumbs withCallback:(void(^)(FileLoaderResults result))callback{
	self.currentDoc.obj = drawingObject;
	[self.currentDoc saveWithCallback:^(FileLoaderResults result) {
		if(result == FileLoaderResultOk){
			NSURL* url = self.currentDoc.url;
			NSString* imgPathSmall = [self getSmallImgFilenameForUrl:url];
			NSString* imgPathMed = [self getMedImgFilenameForUrl:url];
			NSString* imgPathLarge = [self getLargeImgFilenameForUrl:url];
			[UIImagePNGRepresentation(thumbs[0]) writeToFile:imgPathSmall atomically:YES];
			[UIImagePNGRepresentation(thumbs[1]) writeToFile:imgPathMed atomically:YES];
			[UIImagePNGRepresentation(thumbs[2]) writeToFile:imgPathLarge atomically:YES];
			self.scratchObj = nil;
			callback(FileLoaderResultOk);
		}
		else{
			callback(FileLoaderResultUnknownError);
		}
	}];
}

- (void) performSaveWithCallback:(void(^)(FileLoaderResults result))callback{
	[self.currentDoc saveWithCallback:^(FileLoaderResults result) {
		if(result == FileLoaderResultOk){
			callback(FileLoaderResultOk);
		}
		else{
			callback(FileLoaderResultUnknownError);
		}
	}];
}

- (void) saveCurrentFileWithCallback:(void(^)(FileLoaderResults result))callback{
	DrawingObject* obj;
	if(self.currentDoc){
		obj = self.currentDoc.obj;
	}
	else if(self.scratchObj){
		obj = self.scratchObj;
	}
	if(obj){
		NSArray* images = [FileLoader sharedInstance].tempThumbs;
		if(images && images.count>=1){
			[self saveCurrentFile:obj withImages:images withCallback:callback];
		}
		else{
			callback(FileLoaderResultUnknownError);
		}
	}
	else{
		callback(FileLoaderResultUnknownError);
	}
}

- (void) saveCurrentFile:(DrawingObject*) drawingObject withImages:(NSArray*)thumbs withCallback:(void(^)(FileLoaderResults result))callback{
	if(!self.currentDoc){
		[self newFileWithObj:drawingObject withCallBack:^(FileLoaderResults result) {
			if(result == FileLoaderResultOk){
				[self performSave:drawingObject withImages:thumbs withCallback:callback];
			}
			else{
				callback(FileLoaderResultUnknownError);
			}
		}];
	}
	else{
		[self performSave:drawingObject withImages:thumbs withCallback:callback];
	}
}

- (NSString*) getSmallImgFilenameForUrl:(NSURL*) url{
	NSString* path = url.path;
	NSString* imgPath = [path stringByReplacingOccurrencesOfString:@".dat" withString:@"_small.png"];
	return imgPath;
}

- (NSString*) getMedImgFilenameForUrl:(NSURL*) url{
	NSString* path = url.path;
	NSString* imgPath = [path stringByReplacingOccurrencesOfString:@".dat" withString:@"_med.png"];
	return imgPath;
}

- (NSString*) getLargeImgFilenameForUrl:(NSURL*) url{
	NSString* imgPath;
	if(url){
		NSString* path = url.path;
		if(path){
			imgPath = [path stringByReplacingOccurrencesOfString:@".dat" withString:@"_large.png"];
		}
	}
	return imgPath;
}

- (NSURL*) getNewFilenameWithNum:(NSInteger)drawerNum{
	NSString* uuidString = [FileLoader getUUID];
	NSString* fileName = [NSString stringWithFormat:@"%ld%@%@%@", (long)drawerNum, @"_", uuidString, @".dat"];
	return [self.savesFolder URLByAppendingPathComponent:fileName];
}

+ (NSString*) getUUID{
	NSString* uuidString = [[NSProcessInfo processInfo] globallyUniqueString];
	return uuidString;
}

- (void) dealloc{
	[self removeObserver:self forKeyPath:@"currentDoc" context:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:SYMM_NOTIF_FILE_CHANGED object:nil];
}

@end
