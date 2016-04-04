//
//  AppDelegate.h
//  Simitri
//
//  Created by John on 02/04/2016.
//  Copyright © 2016 jgrindall. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, UIAppearanceContainer, UINavigationControllerDelegate>

@property UINavigationController *navigationController;
@property (strong, nonatomic) UIWindow *window;

@end

