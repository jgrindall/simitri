//
//  ParentViewController.m
//  Symmetry
//
//  Created by John on 19/05/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "DrawingScreenController.h"
#import "DrawingDocument.h"
#import "DrawingViewController.h"
#import "ColorViewController.h"
#import "DrawingMenuViewController.h"
#import "FileLoader.h"
#import "SymmNotifications.h"
#import "TSMessage.h"
#import "Appearance.h"
#import "ToolsBarViewController.h"
#import "SKBounceAnimation.h"
#import "AnimationUtils.h"
#import "ToolbarViewController.h"
#import "LayoutConsts.h"
#import "PToolsDelegate.h"
#import "Colors.h"
#import "ToastUtils.h"
#import "ImageUtils.h"
#import "ShareViewController.h"
#import "FacebookService.h"
#import "GallerySubmitViewController.h"
#import "PInfoDelegate.h"
#import "InfoViewController.h"
#import "SoundManager.h"
#import "DrawerFactory.h"
#import "UIColor+Utils.h"

@interface DrawingScreenController ()

@property UIViewController* tabController;
@property UIButton* toolsButton;
@property UIViewController<PToolsDelegate>* toolsViewController;
@property DrawingViewController* drawingViewController;
@property UIView* tabContainer;
@property UIView* toolsContainer;
@property UIView* infoContainer;
@property UIViewController<PInfoDelegate>* infoViewController;
@property UIView* drawingContainer;
@property BOOL toolsShown;
@property BOOL infoShown;
@property UIButton* backButton;
@property UIPopoverController* pop;
@end

@implementation DrawingScreenController

- (void)viewDidLoad{
    [super viewDidLoad];
	[self setupAll];
	self.view.backgroundColor = [Colors symmGrayBgColor];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(performSave) name:SYMM_NOTIF_PERFORM_SAVE object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(performShare) name:SYMM_NOTIF_PERFORM_SHARE object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(performInfo:) name:SYMM_NOTIF_PERFORM_INFO object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(performFb) name:SYMM_NOTIF_FACEBOOK object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(performTwitter) name:SYMM_NOTIF_TWITTER object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(performCamera) name:SYMM_NOTIF_CAMERA object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(performGallery) name:SYMM_NOTIF_GALLERY object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDidRotate:) name:SYMM_NOTIF_DID_ROTATE object:nil];
}

- (void) clickClose{
	[self.drawingViewController stopAnimateWithFade:NO];
	NSDictionary* dic = @{@"infoShown":[NSNumber numberWithBool:YES]};
	[[NSNotificationCenter defaultCenter] postNotificationName:SYMM_NOTIF_PERFORM_INFO object:nil userInfo:dic];
}

- (void) clickMathPoint:(id) pVal{
	[self.drawingViewController clickMathPoint:pVal];
}

- (void) setPageTitle{
	self.title = @"Draw";
}

- (void) setupAll{
	self.toolsShown = NO;
	self.infoShown = NO;
	[self setPageTitle];
	[self addAll];
	[self addChildInto: self.tabContainer withController:self.tabController];
	[self addChildInto: self.drawingContainer withController:self.drawingViewController];
	[self addChildInto: self.toolsContainer withController:self.toolsViewController];
	[self addChildInto: self.infoContainer withController:self.infoViewController];
	[self layoutAll];
}

- (void) addAll{
	[self addDrawing];
	[self addTab];
	[self addTools];
	[self addBack];
	[self addInfo];
	[self addToolsButton];
}

- (void) layoutAll{
	[self layoutDrawing];
	[self layoutTab];
	[self layoutTools];
	[self layoutInfo];
}

- (void) addToolsButton{
	UIImage* iconImg = [ImageUtils iconWithName:@"settingsdown.png" andSize:CGSizeMake(40,40)];
	self.toolsButton = [UIButton buttonWithType:UIButtonTypeSystem];
	UIView* toolsContainer = [[UIView alloc] initWithFrame:CGRectMake(0,0,40,40)];
	[toolsContainer addSubview:self.toolsButton];
	[self.toolsButton setTitle:@" " forState:UIControlStateNormal];
	[self.toolsButton setImage:iconImg forState:UIControlStateNormal];
	self.toolsButton.frame = CGRectMake(5, 0, 30, 30);
	self.toolsButton.titleLabel.font = [Appearance fontOfSize:SYMM_FONT_SIZE_BUTTON];
	[self.toolsButton addTarget:self action:@selector(clickTools) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem* toolsButtonItem = [[UIBarButtonItem alloc] initWithCustomView:toolsContainer];
	self.navigationItem.rightBarButtonItem = toolsButtonItem;
}

- (void) clickTools{
	[[SoundManager sharedInstance] playClick];
	if(self.toolsShown){
		self.toolsShown = NO;
		[self hideTools];
	}
	else{
		self.toolsShown = YES;
		[self showTools];
	}
}

- (void) addBack{
	[self.navigationItem setHidesBackButton:YES animated:NO];
	UIImage* buttonImage = [ImageUtils loadImageNamed:@"backtop.png"];
	self.backButton = [UIButton buttonWithType:UIButtonTypeSystem];
	self.backButton.tintColor = [Colors getColorForTheme:FlatButtonThemeDefault];
	UIView* backContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 140, 40)];
	[backContainer addSubview:self.backButton];
	[self.backButton setTitle:@" Back" forState:UIControlStateNormal];
	[self.backButton setImage:buttonImage forState:UIControlStateNormal];
	self.backButton.frame = CGRectMake(-30, 0, 100, 30);
	self.backButton.titleLabel.font = [Appearance fontOfSize:SYMM_FONT_SIZE_BUTTON];
	[self.backButton addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem* backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backContainer];
	backButtonItem.tintColor = [Colors getColorForTheme:FlatButtonThemeDefault];
	self.navigationItem.leftBarButtonItem = backButtonItem;
}

- (void) clickBack{
	[self.navigationController popToRootViewControllerAnimated:YES];
}

- (void) onDidRotate:(NSNotification*) notification{
	if(self.toolsShown){
		[self showTools];
	}
	else{
		[self hideTools];
	}
	if(self.infoShown){
		[self showInfo];
	}
	else{
		[self hideInfo];
	}
	[self.drawingViewController onRotate];
}

- (void) layoutTools{
	self.toolsContainer.translatesAutoresizingMaskIntoConstraints = NO;
	NSLayoutConstraint* c1 = [NSLayoutConstraint constraintWithItem:self.toolsContainer attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual			toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:-2*LAYOUT_COLOR_VIEW_HEIGHT];
	NSLayoutConstraint* c2 = [NSLayoutConstraint constraintWithItem:self.toolsContainer attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual		toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
	NSLayoutConstraint* c3 = [NSLayoutConstraint constraintWithItem:self.toolsContainer attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual		toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
	NSLayoutConstraint* c4 = [NSLayoutConstraint constraintWithItem:self.toolsContainer attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual		toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:2*LAYOUT_COLOR_VIEW_HEIGHT];
	[self.view addConstraints:@[c1, c2, c3, c4]];
}

- (void) layoutInfo{
	self.infoContainer.translatesAutoresizingMaskIntoConstraints = NO;
	NSLayoutConstraint* c1 = [NSLayoutConstraint constraintWithItem:self.infoContainer attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual			toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
	NSLayoutConstraint* c2 = [NSLayoutConstraint constraintWithItem:self.infoContainer attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual			toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:LAYOUT_INFO_WIDTH];
	NSLayoutConstraint* c3 = [NSLayoutConstraint constraintWithItem:self.infoContainer attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual		toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
	NSLayoutConstraint* c4 = [NSLayoutConstraint constraintWithItem:self.infoContainer attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual		toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:LAYOUT_INFO_HEIGHT];
	[self.view addConstraints:@[c1, c2, c3, c4]];
}

- (void) layoutDrawing{
	self.drawingContainer.translatesAutoresizingMaskIntoConstraints = NO;
	NSLayoutConstraint* c1 = [NSLayoutConstraint constraintWithItem:self.drawingContainer attribute:NSLayoutAttributeTop		relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0];
	NSLayoutConstraint* c2 = [NSLayoutConstraint constraintWithItem:self.drawingContainer attribute:NSLayoutAttributeLeading	relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
	NSLayoutConstraint* c3 = [NSLayoutConstraint constraintWithItem:self.drawingContainer attribute:NSLayoutAttributeTrailing	relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
	NSLayoutConstraint* c4 = [NSLayoutConstraint constraintWithItem:self.drawingContainer attribute:NSLayoutAttributeBottom		relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:-LAYOUT_TAB_HEIGHT];
	[self.view addConstraints:@[c1, c2, c3, c4]];
}

- (void) animateToolsFrom:(float) fromPos to:(float) toPos{
	[AnimationUtils bounceAnimateView:self.toolsContainer from:fromPos to:toPos withKeyPath:@"position.y" withKey:@"toolsBounce" withDelegate:nil withDuration:0.5 withImmediate:NO];
}

- (void) animateInfoFrom:(float) fromPos to:(float) toPos{
	[AnimationUtils bounceAnimateView:self.infoContainer from:fromPos to:toPos withKeyPath:@"position.y" withKey:@"infoBounce" withDelegate:nil withDuration:0.5 withImmediate:NO];
}

- (void) showTools{
	UIImage* iconImg = [ImageUtils iconWithName:@"multiply 2.png" andSize:CGSizeMake(40,40)];
	[self.toolsButton setImage:iconImg forState:UIControlStateNormal];
	[self animateToolsFrom:self.toolsContainer.layer.position.y to:2*LAYOUT_COLOR_VIEW_HEIGHT/2];
}

- (void) hideTools{
	UIImage* iconImg = [ImageUtils iconWithName:@"settingsdown.png" andSize:CGSizeMake(40,40)];
	[self.toolsButton setImage:iconImg forState:UIControlStateNormal];
	[self animateToolsFrom:self.toolsContainer.layer.position.y to:-2*LAYOUT_COLOR_VIEW_HEIGHT/2];
}

- (void) layoutTab{
	self.tabContainer.translatesAutoresizingMaskIntoConstraints = NO;
	NSLayoutConstraint* c1 = [NSLayoutConstraint constraintWithItem:self.tabContainer attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:-LAYOUT_TAB_HEIGHT];
	NSLayoutConstraint* c2 = [NSLayoutConstraint constraintWithItem:self.tabContainer attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
	NSLayoutConstraint* c3 = [NSLayoutConstraint constraintWithItem:self.tabContainer attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
	NSLayoutConstraint* c4 = [NSLayoutConstraint constraintWithItem:self.tabContainer attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:LAYOUT_TAB_HEIGHT];
	[self.view addConstraints:@[c1, c2, c3, c4]];
}

- (void) addTab{
	self.tabContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
	self.tabController = [[DrawingMenuViewController alloc] init];
	[self.view addSubview:self.tabContainer];
}

- (void) hidePop{
	if(self.pop){
		[self.pop dismissPopoverAnimated:NO];
		self.pop = nil;
	}
}

- (void) addTools{
	self.toolsContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 2*LAYOUT_COLOR_VIEW_HEIGHT)];
	self.toolsContainer.clipsToBounds = YES;
	self.toolsViewController = [[ToolsBarViewController alloc] init];
	[self.view addSubview:self.toolsContainer];
}

- (void) addInfo{
	int y = self.view.frame.size.height + LAYOUT_INFO_HEIGHT/2;
	self.infoContainer = [[UIView alloc] initWithFrame:CGRectMake(0, y, LAYOUT_INFO_WIDTH, LAYOUT_INFO_HEIGHT)];
	self.infoContainer.clipsToBounds = YES;
	self.infoViewController = [[InfoViewController alloc] init];
	[self.view addSubview:self.infoContainer];
}

- (void) addDrawing{
	self.drawingContainer = [[UIView alloc] initWithFrame:CGRectIntegral(self.view.frame)];
	self.drawingContainer.frame = CGRectIntegral(self.view.frame);
	self.drawingContainer.backgroundColor = [UIColor clearColor];
	self.drawingViewController = [[DrawingViewController alloc] init];
	[self.view addSubview:self.drawingContainer];
}

- (void) performSave{
	NSArray* thumbs = [self.drawingViewController getThumbs];
	DrawingObject* obj = [self.drawingViewController getDrawingObject];
	[[FileLoader sharedInstance] saveCurrentFile:obj withImages:thumbs withCallback:^(FileLoaderResults result) {
		if(result == FileLoaderResultOk){
			[[NSNotificationCenter defaultCenter] postNotificationName:SYMM_NOTIF_FILE_SAVE_SUCCESS object:nil userInfo:nil];
			[ToastUtils showToastInController:self withMessage:[ToastUtils getFileSaveSuccessMessage] withType:TSMessageNotificationTypeSuccess];
		}
		else{
			[ToastUtils showToastInController:self withMessage:[ToastUtils getFileSaveErrorMessage] withType:TSMessageNotificationTypeError];
		}
	}];
}

- (void) performShare{
	CGRect frame = CGRectMake((self.view.frame.size.width - LAYOUT_POPUP_WIDTH)/2,(self.view.frame.size.height - LAYOUT_TILE_POPUP_HEIGHT)/2, LAYOUT_POPUP_WIDTH, LAYOUT_TILE_POPUP_HEIGHT);
	UIViewController* contents = [[ShareViewController alloc] init];
	self.pop = [[UIPopoverController alloc] initWithContentViewController:contents];
	[[[self.pop contentViewController] view] setBackgroundColor:[Colors symmGrayBgColor]];
	self.pop.popoverContentSize = CGSizeMake(LAYOUT_SHARE_POPUP_WIDTH, LAYOUT_SHARE_POPUP_HEIGHT);
	[self.pop presentPopoverFromRect:frame inView:self.view permittedArrowDirections:0 animated:YES];
}

- (void) performInfo:(NSNotification*) notification{
	BOOL infoShown = [[((NSDictionary*)notification.userInfo) valueForKey:@"infoShown"] boolValue];
	if(!infoShown){
		[self showInfo];
		self.infoShown = YES;
	}
	else{
		[self hideInfo];
		self.infoShown = NO;
	}
}

- (void) showInfo{
	[self animateInfoFrom:self.view.frame.size.height + LAYOUT_INFO_HEIGHT/2 to:self.view.frame.size.height - LAYOUT_INFO_HEIGHT/2 - LAYOUT_TAB_HEIGHT];
}

- (void) hideInfo{
	[self animateInfoFrom:self.view.frame.size.height - LAYOUT_INFO_HEIGHT/2 to:self.view.frame.size.height + LAYOUT_INFO_HEIGHT/2];
}

- (void) performGallery{
	[self hidePop];
	GallerySubmitViewController* v = [[GallerySubmitViewController alloc]init];
	[self.navigationController pushViewController:v animated:YES];
}

- (void) performCamera{
	UIImageWriteToSavedPhotosAlbum([self.drawingViewController getLargeThumb], self, @selector(cameraImage:didFinishSavingWithError:contextInfo:), nil);
	[self hidePop];
}

- (void) cameraImage:(UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo{
	[ToastUtils showToastInController:self withMessage:[ToastUtils getCameraRollSuccessMessage] withType:TSMessageNotificationTypeSuccess];
}

- (void) performFb{
	[self hidePop];
	[[FacebookService sharedInstance] postImageToFacebook:[self.drawingViewController getLargeThumb] withCallback:^(FacebookResults result) {
		if(result == FacebookResultOk){
			[ToastUtils showToastInController:self withMessage:[ToastUtils getFacebookSuccessMessage] withType:TSMessageNotificationTypeSuccess];
		}
		else if(result == FacebookResultCancelled){
			// nothing
		}
		else if(result == FacebookResultNoFacebook){
			[ToastUtils showToastInController:self withMessage:[ToastUtils getNoFbErrorMessage] withType:TSMessageNotificationTypeWarning];
		}
		else{
			[ToastUtils showToastInController:self withMessage:[ToastUtils getFbErrorMessage] withType:TSMessageNotificationTypeWarning];
		}
	}];
}

- (void) cleanUpView{
	[self hidePop];
	[self hideInfo];
	[self hideTools];
	[self removeChildFrom: self.tabContainer withController:self.tabController];
	[self removeChildFrom: self.drawingContainer withController:self.drawingViewController];
	[self removeChildFrom: self.toolsContainer withController:self.toolsViewController];
	[self removeChildFrom: self.infoContainer withController:self.infoViewController];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:SYMM_NOTIF_PERFORM_SAVE object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:SYMM_NOTIF_PERFORM_SHARE object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:SYMM_NOTIF_PERFORM_INFO object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:SYMM_NOTIF_FACEBOOK object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:SYMM_NOTIF_TWITTER object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:SYMM_NOTIF_CAMERA object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:SYMM_NOTIF_GALLERY object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:SYMM_NOTIF_DID_ROTATE object:nil];
	[self.toolsButton removeTarget:self action:@selector(clickTools) forControlEvents:UIControlEventTouchUpInside];
	[self.backButton removeTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
	[self.toolsButton removeFromSuperview];
	self.toolsButton = nil;
	[self.backButton removeFromSuperview];
	self.backButton = nil;
	[self.tabContainer removeFromSuperview];
	self.tabContainer = nil;
	[self.toolsContainer removeFromSuperview];
	self.toolsContainer = nil;
	[self.drawingContainer removeFromSuperview];
	self.drawingContainer = nil;
	[self.infoContainer removeFromSuperview];
	self.infoContainer = nil;
	self.infoViewController = nil;
	self.tabController = nil;
	self.drawingViewController = nil;
	self.toolsViewController = nil;
	[self.view removeFromSuperview];
	self.view = nil;
}

- (void)didReceiveMemoryWarning{
	[super didReceiveMemoryWarning];
	if(self.view && !self.view.window){
		[self cleanUpView];
	}
}

- (void) performTwitter{
	[self hidePop];
	[[FacebookService sharedInstance] postImageToTwitter:[self.drawingViewController getLargeThumb] withCallback:^(FacebookResults result) {
		if(result == FacebookResultOk){
			[ToastUtils showToastInController:self withMessage:[ToastUtils getTwitterSuccessMessage] withType:TSMessageNotificationTypeSuccess];
		}
		else if(result == FacebookResultCancelled){
			// noithing
		}
		else if(result == FacebookResultNoFacebook){
			[ToastUtils showToastInController:self withMessage:[ToastUtils getNoTwitterErrorMessage] withType:TSMessageNotificationTypeWarning];
		}
		else{
			[ToastUtils showToastInController:self withMessage:[ToastUtils getTwitterErrorMessage] withType:TSMessageNotificationTypeWarning];
		}
	}];
}

- (void) viewWillDisappear:(BOOL)animated{
	[FileLoader sharedInstance].tempThumbs = [self.drawingViewController getThumbs];
	[self.toolsContainer.layer removeAllAnimations];
	[self.infoContainer.layer removeAllAnimations];
}

- (void) viewDidAppear:(BOOL)animated{
	[super viewDidAppear:animated];
	[FileLoader sharedInstance].tempThumbs = [self.drawingViewController getThumbs];
}

- (void) viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	DrawingObject* obj = [[FileLoader sharedInstance] getCurrentDrawingObject];
	[obj setSize:self.drawingContainer.bounds.size];
	[self.drawingViewController loadDrawingObject:obj];
	[self.toolsViewController setColor:obj.color];
	[self.toolsViewController setBgColor:obj.bgColor];
	[self.toolsViewController setWidth:obj.width];
	[self hideInfo];
}

- (void) dealloc{
	[self cleanUpView];
}

@end

