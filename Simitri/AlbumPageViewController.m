
//  Created by John on 22/05/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "AlbumPageViewController.h"
#import "FileLoader.h"
#import "Appearance.h"
#import "SymmNotifications.h"
#import "LayoutConsts.h"
#import "UIImage+RoundedCorner.h"

@interface AlbumPageViewController ()

@end

@implementation AlbumPageViewController

- (void)viewDidLoad{
    [super viewDidLoad];
	[self addImg];
	[self layoutImage];
}

- (void) layoutImage{
	NSLayoutConstraint* c1 = [NSLayoutConstraint constraintWithItem:self.img attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:5];
	NSLayoutConstraint* c2 = [NSLayoutConstraint constraintWithItem:self.img attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
	NSLayoutConstraint* c3 = [NSLayoutConstraint constraintWithItem:self.img attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
	NSLayoutConstraint* c4 = [NSLayoutConstraint constraintWithItem:self.img attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:-5];
	[DisplayUtils applyConstraints:self.view withChild: self.img withConstraints:@[c1, c2, c3, c4]];
}

- (void) addImg{
	self.img = [[UIImageView alloc] init];
	self.img.contentMode = UIViewContentModeScaleAspectFit;
	[self.view addSubview:self.img];
}

- (void) populate{
	[super populate];
	NSString* fileName = [self.dataObject description];
	if(self.dataObject && [self.dataObject isKindOfClass:[NSURL class]]){
		fileName = [[FileLoader sharedInstance] getLargeImgFilenameForUrl:self.dataObject];
	}
	UIImage* img = [UIImage imageWithContentsOfFile:fileName];
	self.img.image = img;
}

- (void)didReceiveMemoryWarning{
	[super didReceiveMemoryWarning];
}

- (void) dealloc{
	self.img.image = nil;
	[self.img removeFromSuperview];
	self.img = nil;
}

@end
