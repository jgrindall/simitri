//
//  ColorViewController.m
//  Symmetry
//
//  Created by John on 19/05/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "ColorViewController.h"
#import "ColorCell.h"
#import "Colors.h"
#import "SymmNotifications.h"

@interface ColorViewController ()

@end

@implementation ColorViewController

- (void)viewDidLoad{
    [super viewDidLoad];
	self.colors = [Colors getAllForeground];
}

- (void) notifyColorChange{
	if(self.colors){
		NSDictionary* dic = @{@"color":self.colors[self.selectedColorIndex]};
		[[NSNotificationCenter defaultCenter] postNotificationName:SYMM_NOTIF_CHANGE_COLOR object:nil userInfo:dic];
	}
}

@end
