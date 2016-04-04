
//  Created by John on 22/05/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "GalleryPageViewController.h"
#import "Appearance.h"
#import "MapView.h"
#import "LayoutConsts.h"
#import "SymmNotifications.h"
#import "GalleryService.h"
#import "UIImageView+WebCache.h"
#import "DrawerFactory.h"
#import "ImageUtils.h"
#import <UIKit/UIKit.h>

@interface GalleryPageViewController ()

@property UILabel* descriptionTextView;
@property UIImageView* imageView;
@property MapView* mapView;
@property NSArray* mapLandscapeConstraints;
@property NSArray* mapPortraitConstraints;
@property NSArray* imgLandscapeConstraints;
@property NSArray* imgPortraitConstraints;
@property NSArray* desLandscapeConstraints;
@property NSArray* desPortraitConstraints;
@property int currentOrientation;

@end

@implementation GalleryPageViewController

- (id) init{
	self = [super init];
	if(self){
		
	}
	return self;
}

- (void)updateViewConstraints{
	[super updateViewConstraints];
	if(self.mapView){
		[self.mapView refresh];
	}
}

- (void)didReceiveMemoryWarning{
	[super didReceiveMemoryWarning];
}

- (void) viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	[self updateViewConstraints];
}

- (void) viewDidAppear:(BOOL)animated{
	[super viewDidAppear:animated];
	[self updateViewConstraints];
}

- (void)viewDidLoad{
    [super viewDidLoad];
	self.currentOrientation = -1;
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDidRotate:) name:SYMM_NOTIF_DID_ROTATE object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onWillRotate:) name:SYMM_NOTIF_WILL_ROTATE object:nil];
	[self addImage];
	[self addText];
	[self addMap];
	[self getImageConstraints];
	[self getMapConstraints];
	[self getDesConstraints];
	[self layoutAll];
}


- (void) layoutAll{
	UIInterfaceOrientation orient = [UIApplication sharedApplication].statusBarOrientation;
	if(UIInterfaceOrientationIsLandscape(orient)){
		if(self.currentOrientation == -1 || !UIInterfaceOrientationIsLandscape(self.currentOrientation)){
			[self layoutLandscape];
			self.currentOrientation = orient;
		}
	}
	else{
		if(self.currentOrientation == -1 || UIInterfaceOrientationIsLandscape(self.currentOrientation)){
			[self layoutPortrait];
			self.currentOrientation = orient;
		}
	}
}

- (void) removeConstraints{
	[self.view removeConstraints:self.view.constraints];
	[self updateViewConstraints];
}

- (void) layoutLandscape{
	[self removeConstraints];
	[self layoutMap:self.mapLandscapeConstraints];
	[self layoutDes:self.desLandscapeConstraints];
	[self layoutImage:self.imgLandscapeConstraints];
	[self updateViewConstraints];
}

- (void) layoutPortrait{
	[self removeConstraints];
	[self layoutMap:self.mapPortraitConstraints];
	[self layoutDes:self.desPortraitConstraints];
	[self layoutImage:self.imgPortraitConstraints];
	[self updateViewConstraints];
}

- (void) onDidRotate:(NSNotification*) notification{
	[self layoutAll];
}

- (void) onWillRotate:(NSNotification*) notification{
	[self removeConstraints];
}

- (void) layoutMap:(NSArray*) constraints{
	[self.view addConstraints:constraints];
}

- (void) layoutImage:(NSArray*) constraints{
	[self.view addConstraints:constraints];
}

- (void) layoutDes:(NSArray*) constraints{
	[self.view addConstraints:constraints];
}

- (void) addMap{
	self.mapView = [[MapView alloc] init];
	[self.view addSubview:self.mapView];
}

- (void) addText{
	self.descriptionTextView = [Appearance labelWithFontSize:SYMM_FONT_SIZE_MED];
	[self.view addSubview:self.descriptionTextView];
	self.descriptionTextView.textAlignment = NSTextAlignmentCenter;
}

- (void) getImageConstraints{
	self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
	NSLayoutConstraint* c1 = [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0];
	NSLayoutConstraint* c2 = [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:LAYOUT_FILE_THUMB_LARGE_SIZE];
	NSLayoutConstraint* c3 = [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
	NSLayoutConstraint* c4 = [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
	
	NSLayoutConstraint* c5 = [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.descriptionTextView attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
	NSLayoutConstraint* c6 = [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
	NSLayoutConstraint* c7 = [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
	NSLayoutConstraint* c8 = [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:0.5 constant:0];
	
	self.imgPortraitConstraints = @[c1, c2, c3, c4];
	self.imgLandscapeConstraints = @[c5, c6, c7, c8];
}


- (void) getMapConstraints{
	self.mapView.translatesAutoresizingMaskIntoConstraints = NO;
	NSLayoutConstraint* c1 = [NSLayoutConstraint constraintWithItem:self.mapView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.descriptionTextView attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
	NSLayoutConstraint* c2 = [NSLayoutConstraint constraintWithItem:self.mapView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
	NSLayoutConstraint* c3 = [NSLayoutConstraint constraintWithItem:self.mapView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
	NSLayoutConstraint* c4 = [NSLayoutConstraint constraintWithItem:self.mapView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
	
	NSLayoutConstraint* c5 = [NSLayoutConstraint constraintWithItem:self.mapView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.descriptionTextView attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
	NSLayoutConstraint* c6 = [NSLayoutConstraint constraintWithItem:self.mapView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
	NSLayoutConstraint* c7 = [NSLayoutConstraint constraintWithItem:self.mapView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:0.5 constant:0];
	NSLayoutConstraint* c8 = [NSLayoutConstraint constraintWithItem:self.mapView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
	
	self.mapPortraitConstraints = @[c1, c2, c3, c4];
	self.mapLandscapeConstraints = @[c5, c6, c7, c8];
}

- (void) getDesConstraints{
	self.descriptionTextView.translatesAutoresizingMaskIntoConstraints = NO;
	NSLayoutConstraint* c1 = [NSLayoutConstraint constraintWithItem:self.descriptionTextView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.imageView attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
	NSLayoutConstraint* c2 = [NSLayoutConstraint constraintWithItem:self.descriptionTextView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:30];
	NSLayoutConstraint* c3 = [NSLayoutConstraint constraintWithItem:self.descriptionTextView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
	NSLayoutConstraint* c4 = [NSLayoutConstraint constraintWithItem:self.descriptionTextView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
	
	NSLayoutConstraint* c5 = [NSLayoutConstraint constraintWithItem:self.descriptionTextView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0];
	NSLayoutConstraint* c6 = [NSLayoutConstraint constraintWithItem:self.descriptionTextView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:30];
	NSLayoutConstraint* c7 = [NSLayoutConstraint constraintWithItem:self.descriptionTextView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
	NSLayoutConstraint* c8 = [NSLayoutConstraint constraintWithItem:self.descriptionTextView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
	
	self.desPortraitConstraints = @[c1, c2, c3, c4];
	self.desLandscapeConstraints = @[c5, c6, c7, c8];
}

- (void) addImage{
	self.imageView = [[UIImageView alloc] init];
	self.imageView.contentMode = UIViewContentModeScaleAspectFit;
	[self.view addSubview:self.imageView];
}

- (void)populate{
	[super populate];
	if([self.dataObject isKindOfClass:[NSDictionary class]]){
		NSDictionary* dic = (NSDictionary*)(self.dataObject);
		NSNumber* drawerNum = (NSNumber*)[dic objectForKey:@"drawerNum"];
		NSString* _id = (NSString*)[dic objectForKey:@"_id"];
		NSString* label = [DrawerFactory getLabelForDrawerNum:[drawerNum integerValue]];
		NSString* countryString = (NSString*)[dic objectForKey:@"country"];
		NSNumber* latNum = (NSNumber*)[dic objectForKey:@"latitude"];
		NSNumber* longNum = (NSNumber*)[dic objectForKey:@"longitude"];
		self.descriptionTextView.text = [NSString stringWithFormat:@"This design was created in %@, using template %@.", countryString, label];
		NSString* urlString = [GalleryService imageUrlForId:_id];
		UIImage* placeholder = [ImageUtils loadImageNamed:@"largePlaceholder.png"];
		//[self.imageView setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:placeholder];
		//[self.imageView sd_setImageWithURL:<#(NSURL *)#>]
		[self.imageView sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:placeholder];
		CGPoint p = CGPointMake([latNum floatValue], [longNum floatValue]);
		[self.mapView mark:p withLabel:countryString];
	}
}

-(void) dealloc{
	[[NSNotificationCenter defaultCenter] removeObserver:self name:SYMM_NOTIF_WILL_ROTATE object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:SYMM_NOTIF_DID_ROTATE object:nil];
	if(self.mapView){
		[self.mapView removeFromSuperview];
		self.mapView = nil;
	}
	if(self.imageView){
		self.imageView.image = nil;
		[self.imageView removeFromSuperview];
		self.imageView = nil;
	}
}

@end
