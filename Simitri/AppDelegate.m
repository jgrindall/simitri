//
//  AppDelegate.m
//  Simitri
//
//  Created by John on 02/04/2016.
//  Copyright © 2016 jgrindall. All rights reserved.
//

#import "AppDelegate.h"
#import "Appearance.h"
#import "MyFilesScreenController.h"
#import "MainMenuViewController.h"
#import "TemplateScreenController.h"
#import "TemplateFileViewController.h"
#import "TemplatePageViewController.h"
#import "TransitionAnimator.h"
#import "SoundManager.h"
#import "NavController.h"
#import "SymmNotifications.h"
#import "LaunchOptions.h"
#import "FileLoader.h"
#import "ImageUtils.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
	[SoundManager sharedInstance];
	[self initApp];
	[self applyStyles];
	return YES;
}

- (void) initApp{
	self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	UIViewController* rootViewController = [[MainMenuViewController alloc] init];
	self.navigationController = [[NavController alloc] initWithRootViewController:rootViewController];
	[self.window setRootViewController:self.navigationController];
	[self.window addSubview:self.navigationController.view];
	[self.window makeKeyAndVisible];
}

- (void) applyStyles{
	[Appearance applyStylesInWindow:self.window];
	
}

- (void) dispatchRotate:(NSString*) name to:(UIInterfaceOrientation) to{
	UIInterfaceOrientation from;
	if(UIInterfaceOrientationIsLandscape(to)){
		from = UIInterfaceOrientationPortrait;
	}
	else{
		from = UIInterfaceOrientationLandscapeLeft;
	}
	NSDictionary* dic = @{@"to":[NSNumber numberWithInt:to], @"from":[NSNumber numberWithInt:from]};
	[[NSNotificationCenter defaultCenter] postNotificationName:name object:nil userInfo:dic];
}

- (void) application:(UIApplication *)application willChangeStatusBarOrientation:(UIInterfaceOrientation)newStatusBarOrientation duration:(NSTimeInterval)duration{
	[self dispatchRotate:SYMM_NOTIF_WILL_ROTATE to:newStatusBarOrientation];
}

-(void) application:(UIApplication *)application didChangeStatusBarOrientation:(UIInterfaceOrientation)oldStatusBarOrientation{
	UIInterfaceOrientation to;
	if(UIInterfaceOrientationIsLandscape(oldStatusBarOrientation)){
		to = UIInterfaceOrientationPortrait;
	}
	else{
		to = UIInterfaceOrientationLandscapeLeft;
	}
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.05*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
		[self dispatchRotate:SYMM_NOTIF_DID_ROTATE to:to];
	});
}

- (void)applicationWillResignActive:(UIApplication *)application{
	// NSLog(@"resign bg");
	// Sent when the application is about to move from active to inactive state.
	// This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message)
	// or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down
	// OpenGL ES frame rates. Games should use this method to pause the game.
	[[NSNotificationCenter defaultCenter] postNotificationName:SYMM_NOTIF_STOP_ANIM object:nil userInfo:nil];
}

- (void)applicationDidEnterBackground:(UIApplication *)application{
	// NSLog(@"enter bg");
	// Use this method to release shared resources, save user data, invalidate timers,
	// and store enough application state information to restore your application to its
	// current state in case it is terminated later.
	// If your application supports background execution, this method is called instead of
	// applicationWillTerminate: when the user quits.
	[[NSNotificationCenter defaultCenter] postNotificationName:SYMM_NOTIF_STOP_ANIM object:nil userInfo:nil];
}

- (void) applicationDidReceiveMemoryWarning:(UIApplication *)application{
	[[LaunchOptions sharedInstance] decreaseImgQuality];
	[[NSNotificationCenter defaultCenter] postNotificationName:SYMM_NOTIF_STOP_ANIM object:nil userInfo:nil];
	[[NSNotificationCenter defaultCenter] postNotificationName:SYMM_NOTIF_MEMORY object:nil userInfo:nil];
	[ImageUtils emptyCache];
}

- (void)applicationWillEnterForeground:(UIApplication *)application{
	// NSLog(@"enter fg");
	// Called as part of the transition from the background to the inactive state;
	// here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application{
	// NSLog(@"did become active");
	// Restart any tasks that were paused (or not yet started) while the application
	// was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application{
	// NSLog(@"terminate");
	[[NSNotificationCenter defaultCenter] postNotificationName:SYMM_NOTIF_STOP_ANIM object:nil userInfo:nil];
	[[FileLoader sharedInstance] storeState];
	// Called when the application is about to terminate. Save data if
	// appropriate. See also applicationDidEnterBackground:.
}

@end
