//
//  ToastUtils.m
//  Symmetry
//
//  Created by John on 09/06/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "ToastUtils.h"
#import "SoundManager.h"
#import "AppDelegate.h"
#import <UIKit/UIKit.h>

@implementation ToastUtils

+ (void) showToastInController:(UIViewController*)controller withMessage:(NSString*)subtitle withType:(TSMessageNotificationType)type{
	NSString* title = @"";
	AppDelegate* del = (AppDelegate *)[UIApplication sharedApplication].delegate;
	if(type == TSMessageNotificationTypeSuccess){
		title = @"SUCCESS";
		[[SoundManager sharedInstance] playSuccess];
	}
	else if(type == TSMessageNotificationTypeError){
		title = @"ERROR";
		[[SoundManager sharedInstance] playError];
	}
	UIViewController* presenter = del.window.rootViewController;
	if(!presenter){
		presenter = controller;
	}
	[TSMessage showNotificationInViewController:presenter withTitle:title withMessage:subtitle withType:type withDuration:30.f];
}

+ (NSString*) getOpenFileErrorMessage{
	return @"An error occured opening your file, please try again.";
}

+ (NSString*) getFileSaveSuccessMessage{
	return @"Your file has been saved.";
}

+ (NSString*) getFileSaveErrorMessage{
	return @"An error occured saving your file, please try again.";
}

+ (NSString*) getFileDeleteSuccessMessage{
	return @"Your file has been deleted";
}

+ (NSString*) getFileDeleteErrorMessage{
	return @"An error occured deleting your file, please retry.";
}

+ (NSString*) getStartFileErrorMessage{
	return @"An unknown error occured, please try again.";
}

+ (NSString*) getNoFbErrorMessage{
	return @"Unable to post to Facebook, please check that you have the Facebook app and have registered an account on your device.";
}

+ (NSString*) getFacebookSuccessMessage{
	return @"Posted to Facebook!";
}

+ (NSString*) getTwitterSuccessMessage{
	return @"Posted to Twitter!";
}

+ (NSString*) getFbErrorMessage{
	return @"An error occured posting to Facebook, please try again.";
}

+ (NSString*) getNoTwitterErrorMessage{
	return @"Unable to post to Twitter, please check that you have the Twitter app and have registered an account on your device.";
}

+ (NSString*) getTwitterErrorMessage{
	return @"An error occured posting to Twitter, please try again.";
}

+ (NSString*) getCameraRollSuccessMessage{
	return @"Saved to your camera roll.";
}

+ (NSString*) getGalleryViewErrorMessage{
	return @"An error occured loading the gallery, please try again.";
}

+ (NSString*) getGalleryViewNoInternetMessage{
	return @"You do not seem to have an internet connection, please connect to the internet to load the gallery.";
}

+ (NSString*) getGallerySubmitNoInternetMessage{
	return @"You do not seem to have an internet connection, please connect to the internet to submit to the gallery.";
}

+ (NSString*) getGallerySubmitErrorMessage{
	return @"An error occured submitting to the gallery, please try again.";
}

+ (NSString*) getGallerySubmitSuccessMessage{
	return @"Thanks, your file has been submitted to the gallery!";
}

+ (NSString*) getGalleryViewInsuffFilesMessage{
	return @"An unknown error occured while loading the gallery, please try again.";
}

@end
