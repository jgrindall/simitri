//
//  Created by John on 19/05/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "TemplateFileViewController.h"
#import "SymmNotifications.h"
#import "Appearance.h"
#import "TemplateScreenController.h"
#import "TemplateMenuController.h"
#import "FileManagerDelegate.h"
#import "MyFilesScreenController.h"
#import "DrawingScreenController.h"
#import "TemplateDataProvider.h"
#import "TemplatePageViewController.h"
#import "LayoutConsts.h"
#import "DrawingDocument.h"
#import "DrawingObject.h"
#import "FileLoader.h"
#import "PTemplateViewer.h"
#import "UIColor+Utils.h"
#import "InfoViewController.h"
#import "PInfoDelegate.h"
#import "AnimationUtils.h"
#import "ExampleViewController.h"
#import "TemplateConfig.h"
#import "TransitionDelegate.h"

@interface TemplateScreenController ()

@property UIView* templatesContainer;
@property UIView* menuContainer;
@property UIViewController<PTemplateViewer>* templateController;
@property TemplateMenuController* menuController;
@property UIView* infoContainer;
@property UIViewController* infoViewController;
@property BOOL infoShown;
@property TransitionDelegate* transDelegate;
@property ExampleViewController* exampleController;

@end

@implementation TemplateScreenController

- (void) layoutMenu{
	self.menuContainer.translatesAutoresizingMaskIntoConstraints = NO;
	NSLayoutConstraint* c1 = [NSLayoutConstraint constraintWithItem:self.menuContainer attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.bottomLayoutGuide attribute:NSLayoutAttributeTop multiplier:1 constant:0];
	NSLayoutConstraint* c2 = [NSLayoutConstraint constraintWithItem:self.menuContainer attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
	NSLayoutConstraint* c3 = [NSLayoutConstraint constraintWithItem:self.menuContainer attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
	NSLayoutConstraint* c4 = [NSLayoutConstraint constraintWithItem:self.menuContainer attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:LAYOUT_TAB_HEIGHT];
	[self.view addConstraints:@[c1, c2, c3, c4]];
}

- (void) layoutTemplates{
	self.templatesContainer.translatesAutoresizingMaskIntoConstraints = NO;
	NSLayoutConstraint* c1 = [NSLayoutConstraint constraintWithItem:self.templatesContainer attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topLayoutGuide attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
	NSLayoutConstraint* c2 = [NSLayoutConstraint constraintWithItem:self.templatesContainer attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
	NSLayoutConstraint* c3 = [NSLayoutConstraint constraintWithItem:self.templatesContainer attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
	NSLayoutConstraint* c4 = [NSLayoutConstraint constraintWithItem:self.templatesContainer attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.menuContainer attribute:NSLayoutAttributeTop multiplier:1 constant:0];
	[self.view addConstraints:@[c1, c2, c3, c4]];
}

- (void) layoutInfo{
	self.infoContainer.translatesAutoresizingMaskIntoConstraints = NO;
	NSLayoutConstraint* c1 = [NSLayoutConstraint constraintWithItem:self.infoContainer attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
	NSLayoutConstraint* c2 = [NSLayoutConstraint constraintWithItem:self.infoContainer attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:LAYOUT_INFO_WIDTH];
	NSLayoutConstraint* c3 = [NSLayoutConstraint constraintWithItem:self.infoContainer attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
	NSLayoutConstraint* c4 = [NSLayoutConstraint constraintWithItem:self.infoContainer attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:LAYOUT_INFO_HEIGHT];
	[self.view addConstraints:@[c1, c2, c3, c4]];
}

- (void) addInfo{
	self.infoContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, LAYOUT_INFO_WIDTH, 100)];
	self.infoContainer.clipsToBounds = YES;
	self.infoViewController = [[InfoViewController alloc] init];
	[self.view addSubview:self.infoContainer];
}

- (void)viewDidLoad{
    [super viewDidLoad];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(swipeLeft) name:SYMM_NOTIF_EXAMPLE_SWIPE_LEFT object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(swipeRight) name:SYMM_NOTIF_EXAMPLE_SWIPE_RIGHT object:nil];
	self.view.backgroundColor = [Colors symmGrayBgColor];
	self.title = @"Choose a template";
	self.infoShown = NO;
	[self addTemplates];
	[self addMenu];
	[self addInfo];
	[self addChildInto:self.menuContainer withController:self.menuController];
	[self addChildInto:self.templatesContainer withController:self.templateController];
	[self addChildInto: self.infoContainer withController:self.infoViewController];
}

- (void) swipeLeft{
	NSInteger numPages = [self.templateController getNumberOfPages];
	NSInteger currentIndex = [self.templateController getSelectedIndex];
	if(currentIndex < numPages - 1){
		[self openExample:(currentIndex + 1)];
		[self.templateController swipeLeft];
	}
}

- (void) swipeRight{
	NSInteger currentIndex = [self.templateController getSelectedIndex];
	if(currentIndex >= 1){
		[self openExample:(currentIndex - 1)];
		[self.templateController swipeRight];
	}
}

- (void) clickClose{
	[self hideInfo];
	[[TemplateConfig sharedInstance] setShowMathConfig:NO];
}

- (void) clickMathPoint:(id) pVal{
	
}

- (void) viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	[self layoutMenu];
	[self layoutTemplates];
	[self layoutInfo];
}

- (void)viewDidAppear:(BOOL)animated{
	[super viewDidAppear:animated];
	BOOL show = [[TemplateConfig sharedInstance] getShowMathConfig];
	if(show && !self.infoShown){
		[self showInfo];
	}
	else if(!show && self.infoShown){
		[self hideInfo];
	}
}

- (void) viewDidDisappear:(BOOL)animated{
	[super viewDidDisappear:animated];
	[self.infoContainer.layer removeAllAnimations];
}

- (void) animateInfoFrom:(float) fromPos to:(float) toPos{
	[AnimationUtils bounceAnimateView:self.infoContainer from:fromPos to:toPos withKeyPath:@"position.y" withKey:@"infoBounce" withDelegate:nil withDuration:0.5 withImmediate:NO];
}

- (void) showInfo{
	[self animateInfoFrom:self.view.frame.size.height + LAYOUT_INFO_HEIGHT/2 to:self.view.frame.size.height - LAYOUT_INFO_HEIGHT/2 - LAYOUT_TAB_HEIGHT];
	self.infoShown = YES;
}

- (void) hideInfo{
	[self animateInfoFrom:self.view.frame.size.height - LAYOUT_INFO_HEIGHT/2 to:self.view.frame.size.height + LAYOUT_INFO_HEIGHT/2];
	self.infoShown = NO;
}

- (void)infoChosen{
	BOOL show;
	if(self.infoShown){
		[self hideInfo];
		show = NO;
	}
	else{
		[self showInfo];
		show = YES;
	}
	[[TemplateConfig sharedInstance] setShowMathConfig:show];
}

- (void) didReceiveMemoryWarning{
	[super didReceiveMemoryWarning];
	if(self.view && !self.view.window){
		[self cleanUpView];
	}
}

- (void) openExample:(NSInteger)i{
	if(self.exampleController){
		[self.exampleController loadIndex:i];
	}
	else{
		self.exampleController = [[ExampleViewController alloc] initWithIndex:i];
		self.exampleController.view.frame = CGRectIntegral(CGRectMake(0, 0, self.view.frame.size.width + self.view.frame.origin.x, self.view.frame.size.height + self.view.frame.origin.y));
		self.exampleController.modalPresentationStyle = UIModalPresentationCustom;
		[self.navigationController presentViewController:self.exampleController animated:YES completion:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeExample) name:SYMM_NOTIF_CLOSE_EXAMPLE object:nil];
	}
}

- (void) egChosen{
	NSInteger i = [self.templateController getSelectedIndex];
	[self openExample:i];
}

- (void) closeExample{
	if(self.exampleController){
		[[NSNotificationCenter defaultCenter] removeObserver:self name:SYMM_NOTIF_CLOSE_EXAMPLE object:nil];
		[self.navigationController dismissViewControllerAnimated:YES completion:^{
			//
		}];
		self.exampleController = nil;
	}
}

- (void)tplChosen{
	DrawingObject* obj = [[FileLoader sharedInstance] getCurrentDrawingObject];
	obj.drawerNum = [self.templateController getSelectedIndex];
	[obj loadDefaultColors];
	DrawingScreenController* v = [[DrawingScreenController alloc]init];
	[self.navigationController pushViewController:v animated:YES];
}

- (void) addMenu{
	self.menuController = [[TemplateMenuController alloc] init];
	self.menuContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
	[self.view addSubview: self.menuContainer];
}

- (void) addTemplates{
	TemplateDataProvider* dataProvider = [[TemplateDataProvider alloc] initWithPageClass:[TemplatePageViewController class]];
	self.templateController = [[TemplateFileViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil withDataProvider:dataProvider];
	self.templatesContainer = [[UIView alloc] initWithFrame:CGRectIntegral(self.view.frame)];
	[self.view addSubview: self.templatesContainer];
}

- (void) cleanUpView{
	[self removeChildFrom:self.menuContainer withController:self.menuController];
	[self removeChildFrom:self.templatesContainer withController:self.templateController];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:SYMM_NOTIF_CLOSE_EXAMPLE object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:SYMM_NOTIF_EXAMPLE_SWIPE_LEFT object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:SYMM_NOTIF_EXAMPLE_SWIPE_RIGHT object:nil];
	self.menuController = nil;
	self.templateController = nil;
	[self.menuContainer removeFromSuperview];
	self.menuContainer = nil;
	[self.templatesContainer removeFromSuperview];
	self.templatesContainer = nil;
	[self.view removeFromSuperview];
	self.view = nil;
}

- (void) dealloc{
	[self cleanUpView];
}

@end

