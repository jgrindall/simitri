//
//  BgViewController.m
//  Symmetry
//
//  Created by John on 29/05/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "BgViewController.h"
#import "Colors.h"
#import "SymmNotifications.h"

@interface BgViewController ()

@end

@implementation BgViewController

- (void)viewDidLoad{
    [super viewDidLoad];
	self.colors = [Colors getAllBackground];
}

- (void) notifyColorChange{
	if(self.colors){
		NSDictionary* dic = @{@"bgColor":self.colors[self.selectedColorIndex]};
		[[NSNotificationCenter defaultCenter] postNotificationName:SYMM_NOTIF_BG_CHANGE_COLOR object:nil userInfo:dic];
	}
}

@end
