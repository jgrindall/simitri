//
//  FileManager.m
//  Symmetry
//
//  Created by John on 19/05/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "FacebookService.h"
#import "AppDelegate.h"
#import "SymmNotifications.h"
#import <Social/Social.h>
#import "ToastUtils.h"

@interface FacebookService ()

@end

@implementation FacebookService

+ (id)sharedInstance {
    static FacebookService* service = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        service = [[self alloc] init];
    });
    return service;
}

- (NSString*) getUrl{
	return @"http://bit.ly/1o1Z60b";
}

- (NSString*) getMessageFb{
	return @"Check out what I made using the Simitri app. Learn about the beauty of maths and symmetry! #simitriapp";
}

- (NSString*) getMessageTwitter{
	NSString* text = @"See the beauty of maths and symmetry with the Simitri app! #simitriapp";
	return [NSString stringWithFormat:@"%@ %@", text, [self getUrl]];
}

- (void) postToSocialNetwork:(UIImage*)img withText:(NSString*) text withCallback:(void(^)(FacebookResults result))callback withServiceType:(NSString *)serviceType{
	AppDelegate* del = (AppDelegate *)[UIApplication sharedApplication].delegate;
	UIViewController* presenter = del.window.rootViewController;
	if(!presenter){
		return;
	}
	if([SLComposeViewController isAvailableForServiceType:serviceType]) {
        SLComposeViewController* controller = [SLComposeViewController composeViewControllerForServiceType:serviceType];
        [controller setInitialText:text];
        [controller addURL:[NSURL URLWithString:[self getUrl]]];
        [controller addImage:img];
		[controller setCompletionHandler:^(SLComposeViewControllerResult result) {
			if(result == SLComposeViewControllerResultCancelled){
				callback(FacebookResultCancelled);
			}
			else if(result == SLComposeViewControllerResultDone){
				callback(FacebookResultOk);
			}
		}];
        [presenter presentViewController:controller animated:YES completion:nil];
	}
	else{
		callback(FacebookResultNoFacebook);
	}
}

- (void) postImageToTwitter:(UIImage*)img withCallback:(void(^)(FacebookResults result))callback{
	[self postToSocialNetwork:img withText:[self getMessageTwitter] withCallback:callback withServiceType:SLServiceTypeTwitter];
}

- (void) postImageToFacebook:(UIImage*)img withCallback:(void(^)(FacebookResults result))callback{
	[self postToSocialNetwork:img withText:[self getMessageFb] withCallback:callback withServiceType:SLServiceTypeFacebook];
}

@end





