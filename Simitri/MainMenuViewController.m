//
//  MainMenuViewController.m
//  Symmetry
//
//  Created by John on 29/05/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "MainMenuViewController.h"
#import "ToolbarController.h"
#import "LayoutConsts.h"
#import "MyFilesScreenController.h"
#import "Colors.h"
#import "HelpViewController.h"
#import "HelpDataProvider.h"
#import "HelpPageViewController.h"
#import "FileLoader.h"
#import "DrawingScreenController.h"
#import "SymmNotifications.h"
#import "Appearance.h"
#import "GalleryScreenController.h"
#import "GalleryViewController.h"
#import "GalleryViewerController.h"
#import "ImageUtils.h"
#import "ExampleViewController.h"
#import "TransitionDelegate.h"
#import "HelpScreenController.h"

@interface MainMenuViewController ()

@property UIButton* backButton;
@property TransitionDelegate* transDelegate;

@end

@implementation MainMenuViewController

- (id) init{
	self = [super initWithButtons:@[@"Your files", @"Gallery", @"Help/About"] withIcons:@[@"folder.png", @"pic 3.png", @"bulb.png"] ];
	if(self){
		self.view.backgroundColor = [Colors symmGrayBgColor];
	}
	return self;
}

- (void) buttonChosen:(NSNumber*)n{
	int intN = [n intValue];
	if(intN <= 1){
		[super buttonChosen:n];
	}
	else{
		[self openHelp];
	}
}

- (NSInteger) numChildren{
	return 2;
}

- (UIViewController*) getChildControllerAt:(NSInteger)i{
	if(i == 0){
		return [[MyFilesScreenController alloc] init];
	}
	else{
		return [[GalleryScreenController alloc] init];
	}
}

- (void)viewDidLoad{
    [super viewDidLoad];
	self.transDelegate = [[TransitionDelegate alloc] init];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setBackButtonVis) name:SYMM_NOTIF_CURRENT_FILE_CHANGE object:nil];
	self.title = @"Home";
	[self addBackButton];
	[self addHelpButton];
}

- (void) closeHelp{
	[[NSNotificationCenter defaultCenter] removeObserver:self name:SYMM_NOTIF_CLOSE_HELP object:nil];
	[self.navigationController dismissViewControllerAnimated:YES completion:^{
		//
	}];
}

- (void) openHelp{
	UIViewController* viewController = [[HelpScreenController alloc] init];
	CGRect r = CGRectMake(0, 0, self.view.frame.size.width + self.view.frame.origin.x, self.view.frame.size.height + self.view.frame.origin.y);
	viewController.view.frame = r;
	viewController.transitioningDelegate = self.transDelegate;
	viewController.modalPresentationStyle = UIModalPresentationCustom;
	[self.navigationController presentViewController:viewController animated:YES completion:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeHelp) name:SYMM_NOTIF_CLOSE_HELP object:nil];
}

- (void) showChild:(NSInteger)childIndex{
	NSArray* titles = @[@"Home - Your files", @"Home - Gallery", @"Home - Info"];
	self.title = titles[childIndex];
	[super showChild:childIndex];
}

- (void) addHelpButton{
	
}

- (void) addBackButton{
	UIImage* buttonImage = [ImageUtils loadImageNamed:@"UINavigationBarFdIndicatorDefault.png"];
	self.backButton = [UIButton buttonWithType:UIButtonTypeSystem];
	UIView* backContainer = [[UIView alloc] initWithFrame:CGRectMake(0,0,80,40)];
	[backContainer addSubview:self.backButton];
	[self.backButton setTitle:@"Draw " forState:UIControlStateNormal];
	self.backButton.tintColor = [Colors getColorForTheme:FlatButtonThemeDefault];
	[self.backButton setImage:buttonImage forState:UIControlStateNormal];
	self.backButton.frame = CGRectMake(0, 0, 80, 40);
	self.backButton.titleLabel.font = [Appearance fontOfSize:SYMM_FONT_SIZE_BUTTON];
	[self.backButton addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem* backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backContainer];
	[self.backButton setImageEdgeInsets:UIEdgeInsetsMake(0, 68, 0, 0)];
	self.navigationItem.rightBarButtonItem = backButtonItem;
}

- (void)didReceiveMemoryWarning{
	[super didReceiveMemoryWarning];
}

- (void) viewDidAppear:(BOOL)animated{
	[super viewDidAppear:animated];
	[self setBackButtonVis];
	[self showChild:0];
	NSArray* files = [[FileLoader sharedInstance] getYourFiles];
	DrawingObject* obj = [[FileLoader sharedInstance] getCurrentDrawingObject];
	NSInteger numFiles = files.count;
	if(numFiles == 0 && !obj){
		[self openHelp];
	}
}

- (void) setBackButtonVis{
	DrawingObject* obj = [[FileLoader sharedInstance] getCurrentDrawingObject];
	if(obj){
		[self.backButton setHidden:NO];
	}
	else{
		[self.backButton setHidden:YES];
	}
}

-  (void) clickBack{
	DrawingScreenController* v = [[DrawingScreenController alloc] init];
	[self.navigationController pushViewController:v animated:YES];
}

- (void) dealloc{
	[self.backButton removeTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:SYMM_NOTIF_CURRENT_FILE_CHANGE object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:SYMM_NOTIF_CLOSE_HELP object:nil];
	[self.backButton removeFromSuperview];
	self.backButton = nil;
	
}

@end
