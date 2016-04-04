//
//  FileManager.m
//  Symmetry
//
//  Created by John on 19/05/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "GalleryService.h"
#import "SymmNotifications.h"
#import "Reachability.h"
#import <SystemConfiguration/SystemConfiguration.h>

@interface GalleryService ()

@property NSArray* cachedFiles;

@end



@implementation GalleryService

//static NSString* baseUrl = @"http://localhost:5000/";

static NSString* baseUrl = @"http://infinite-ravine-9708.herokuapp.com/";
static NSString* awsUrl = @"http://s3.amazonaws.com/com.jgrindall.simitrithumbs/";


static NSInteger numLoaded = 0;
static NSInteger minFiles = 2;
static NSString* userName = @"symmUserName";
static NSString* password = @"symmPassword";


+ (id)sharedInstance {
    static GalleryService* service = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        service = [[self alloc] init];
    });
    return service;
}

+ (NSString*) imageUrlForId:(NSString*) _id{
	return [NSString stringWithFormat:@"%@%@%@%@", awsUrl, @"thumb_", _id, @".png"];
}

+ (NSString*) filePostUrl{
	return [NSString stringWithFormat:@"%@%@", baseUrl, @"files"];
}

+ (NSString*) fileGetUrl{
	return [NSString stringWithFormat:@"%@%@", baseUrl, @"files"];
}

- (void) clear{
	self.cachedFiles = nil;
}

- (void) setHeadersFor:(NSMutableURLRequest*) request{
	NSString* authStr = [NSString stringWithFormat:@"%@:%@", userName, password];
	NSData* authData = [authStr dataUsingEncoding:NSASCIIStringEncoding];
	[request setValue:[NSString stringWithFormat:@"Basic %@", [authData base64EncodedStringWithOptions:0]] forHTTPHeaderField:@"Authorization"];
	[request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
}

- (void) hitUrlWithType:(NSString*) type withBody:(NSData*) body withUrlString:(NSString*) url withHandler:(void(^)(NSData *data, NSURLResponse *response, NSError *error)) handler{
	//NSLog(@"hit url %@    body %@   type %@", url, body, type);
	NSURLSession* session = [NSURLSession sharedSession];
	NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:45.0];
	[self setHeadersFor:request];
	[request setHTTPMethod:type];
	if(body){
		[request setHTTPBody:body];
	}
	NSURLSessionDataTask* task = [session dataTaskWithRequest:request completionHandler:handler];
	[task resume];
}

- (void) performGetFilesWithCallback:(void(^)(GalleryResults result))callback{
	NSString* urlString = [NSString stringWithFormat:@"%@?numLoaded=%ld",[GalleryService fileGetUrl], (long)numLoaded];
	[self hitUrlWithType:@"GET" withBody:(NSData*) nil withUrlString:urlString withHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
		dispatch_async(dispatch_get_main_queue(), ^{
			[[NSNotificationCenter defaultCenter] postNotificationName:SYMM_NOTIF_HIDE_SPINNER object:nil];
			NSError* e;
			NSDictionary* resDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&e];
			if(e || !resDic){
				callback(GalleryResultError);
			}
			else{
				NSInteger successVal = [[resDic valueForKey:@"success"] integerValue];
				BOOL loopVal = [[resDic valueForKey:@"loop"] boolValue];
				if(successVal == 1){
					if(loopVal){
						numLoaded = 0;
					}
					id files = [resDic valueForKey:@"files"];
					if([files isKindOfClass:[NSArray class]]){
						NSArray* filesArray = (NSArray*)files;
						if(filesArray.count >= minFiles){
							self.cachedFiles = filesArray;
							numLoaded += filesArray.count;
							callback(GalleryResultOk);
						}
						else{
							callback(GalleryResultInsufficientFilesError);
						}
					}
					else{
						callback(GalleryResultError);
					}
				}
				else{
					callback(GalleryResultError);
				}
			}
		});
	}];
}

- (void) getFilesWithCallback:(void(^)(GalleryResults result))callback{
	[[NSNotificationCenter defaultCenter] postNotificationName:SYMM_NOTIF_SHOW_SPINNER object:nil];
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
		Reachability* networkReachability = [Reachability reachabilityForInternetConnection];
		NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
		if (networkStatus == NotReachable) {
			[[NSNotificationCenter defaultCenter] postNotificationName:SYMM_NOTIF_HIDE_SPINNER object:nil];
			callback(GalleryResultUnreachable);
		}
		else {
			[self performGetFilesWithCallback:callback];
		}
	});
}

- (NSArray*) getFiles{
	return self.cachedFiles;
}

- (void) performSubmitData:(NSDictionary*) dic withCallback:(void(^)(GalleryResults result))callback{
	NSError* e;
	NSData* postData = [NSJSONSerialization dataWithJSONObject:dic options:0 error:&e];
	if(e){
		[[NSNotificationCenter defaultCenter] postNotificationName:SYMM_NOTIF_HIDE_SPINNER object:nil];
		callback(GalleryResultError);
	}
	else{
		[self hitUrlWithType:@"POST" withBody:postData withUrlString:[GalleryService filePostUrl] withHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
			dispatch_async(dispatch_get_main_queue(), ^{
				[[NSNotificationCenter defaultCenter] postNotificationName:SYMM_NOTIF_HIDE_SPINNER object:nil];
				NSError* e;
				NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&e];
				if(e || !dic){
					callback(GalleryResultError);
				}
				else{
					if([[dic valueForKey:@"success"] integerValue] == 1){
						callback(GalleryResultOk);
					}
					else{
						callback(GalleryResultError);
					}
				}
			});
		}];
	}
}

- (void) submitData:(NSDictionary*)dic withCallback:(void(^)(GalleryResults result))callback{
	[[NSNotificationCenter defaultCenter] postNotificationName:SYMM_NOTIF_SHOW_SPINNER object:nil];
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
		Reachability* networkReachability = [Reachability reachabilityForInternetConnection];
		NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
		if (networkStatus == NotReachable) {
			[[NSNotificationCenter defaultCenter] postNotificationName:SYMM_NOTIF_HIDE_SPINNER object:nil];
			callback(GalleryResultUnreachable);
		}
		else {
			[self performSubmitData:dic withCallback:callback];
		}
	});
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
	if ([challenge previousFailureCount] == 0) {
        NSURLCredential *newCredential = [NSURLCredential credentialWithUser:userName password:password persistence:NSURLCredentialPersistenceForSession];
        [[challenge sender] useCredential:newCredential forAuthenticationChallenge:challenge];
    }
    else {
        NSLog(@"previous authentication failure");
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	 NSLog(@"response");
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	 NSLog(@"data");
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	 NSLog(@"finished");
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	 NSLog(@"fail");
}

+ (NSString*) getTerms{
	NSString* line0 = @"By submitting your design you must agree to the following Terms of Use:";
	NSString* line1 = @"1. The gallery is intended purely as an educational resource to showcase artistic designs based on simple mathematical rules.";
	NSString* line2 = @"2. I understand that by submitting my image to the gallery, I grant the owner of the app a royalty free worldwide license to use and/or modify the image.";
	NSString* line3 = @"3. I understand that in the above context, the image may be seen by the public, inside apps, on websites, in Facebook and in any other media formats or media channels.";
	NSString* line4 = @"4. All images undergo a review process to check that they are suitable to be part of the gallery - designs that are too simple, or contain swear words for example will not be accepted!";
	NSString* line5 = @"5. I understand that no personal information of any sort is collected by the app apart from the country I live in.";
	NSString* line6 = @"6. For reasons of privacy and security your name/email address are NOT collected and you will not receive a notification if your image is accepted or not.";
	NSArray* array = [NSArray arrayWithObjects:line0, line1, line2, line3, line4, line5, line6, nil];
	return[array componentsJoinedByString:@"\n\n"];
}

@end
