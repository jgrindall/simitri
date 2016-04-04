//
//  SubmitPageController.m
//  Simitri
//
//  Created by John on 11/06/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "SubmitPageController.h"
#import "FileLoader.h"
#import "LayoutConsts.h"
#import "ImageUtils.h"
#import "Colors.h"
#import "Appearance.h"
#import "GalleryService.h"
#import "SymmNotifications.h"
#import "MapView.h"
#import "GeoService.h"
#import "AnimationUtils.h"

@interface SubmitPageController ()

@property UIImageView* imgView;
@property MapView* mapView;
@property UITextView* terms;
@property UIPickerView* picker;
@property UILabel* termsLabel;
@property UILabel* placeLabel;
@property UILabel* switchLabel;
@property UISwitch* mySwitch;
@property UIView* topContainer;
@property UIView* bottomContainer;
@property UIView* menu;
@property NSInteger selectedRow;

@end

@implementation SubmitPageController

- (void)viewDidLoad{
    [super viewDidLoad];
	
	[self addContainers];
	[self addImg];
	[self addLabels];
	[self addText];
	[self addSwitch];
	[self addMap];
	
	[self layoutContainers];
	[self layoutImage];
	[self layoutLabels];
	[self layoutText];
	[self layoutPicker];
	[self layoutSwitch];
	[self layoutMap];
	[self layoutMenu];
	self.view.backgroundColor = [Colors symmGrayBgColor];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDidRotate:) name:SYMM_NOTIF_DID_ROTATE object:nil];
}

- (void)onDidRotate:(NSNotification*)notification{
    [self.mapView refresh];
}

- (void) layoutImage{
	self.imgView.translatesAutoresizingMaskIntoConstraints = NO;
	NSLayoutConstraint* c1 = [NSLayoutConstraint constraintWithItem:self.imgView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topContainer attribute:NSLayoutAttributeTop multiplier:1 constant:0];
	NSLayoutConstraint* c2 = [NSLayoutConstraint constraintWithItem:self.imgView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.topContainer attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
	NSLayoutConstraint* c3 = [NSLayoutConstraint constraintWithItem:self.imgView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.topContainer attribute:NSLayoutAttributeWidth multiplier:0.6 constant:0];
	NSLayoutConstraint* c4 = [NSLayoutConstraint constraintWithItem:self.imgView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.topContainer attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
	[self.view addConstraints:@[c1, c2, c3, c4]];
}

- (void) layoutMap{
	self.mapView.translatesAutoresizingMaskIntoConstraints = NO;
	NSLayoutConstraint* c1 = [NSLayoutConstraint constraintWithItem:self.mapView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.bottomContainer attribute:NSLayoutAttributeTop multiplier:1 constant:0];
	NSLayoutConstraint* c2 = [NSLayoutConstraint constraintWithItem:self.mapView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.bottomContainer attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
	NSLayoutConstraint* c3 = [NSLayoutConstraint constraintWithItem:self.mapView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.bottomContainer attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
	NSLayoutConstraint* c4 = [NSLayoutConstraint constraintWithItem:self.mapView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.picker attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
	[self.view addConstraints:@[c1, c2, c3, c4]];
}

- (void) addContainers{
	self.topContainer = [[UIView alloc]init];
	self.bottomContainer = [[UIView alloc]init];
	self.menu = [[UIView alloc]init];
	[self.view addSubview:self.topContainer];
	[self.view addSubview:self.bottomContainer];
	[self.view addSubview:self.menu];
}

- (void) addMap{
	self.mapView = [[MapView alloc]init];
	[self.bottomContainer addSubview:self.mapView];
	[self.mapView mark:CGPointZero withLabel:[GeoService getAllCountryNames][0]];
}

- (void) warn{
	[AnimationUtils flashLabel:self.placeLabel withTheme:FlatButtonThemeDanger withDelay0:0 withDelay1:2 withCallback:^(BOOL success) {
		
	}];
}

- (void) layoutLabels{
	self.placeLabel.translatesAutoresizingMaskIntoConstraints = NO;
	self.termsLabel.translatesAutoresizingMaskIntoConstraints = NO;
	NSLayoutConstraint* c5 = [NSLayoutConstraint constraintWithItem:self.placeLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.bottomContainer attribute:NSLayoutAttributeTop multiplier:1 constant:0];
	NSLayoutConstraint* c6 = [NSLayoutConstraint constraintWithItem:self.placeLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:25];
	NSLayoutConstraint* c7 = [NSLayoutConstraint constraintWithItem:self.placeLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.bottomContainer attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
	NSLayoutConstraint* c8 = [NSLayoutConstraint constraintWithItem:self.placeLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:LAYOUT_PICKER_WIDTH];
	
	NSLayoutConstraint* c9 = [NSLayoutConstraint constraintWithItem:self.termsLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topContainer attribute:NSLayoutAttributeTop multiplier:1 constant:0];
	NSLayoutConstraint* c10 = [NSLayoutConstraint constraintWithItem:self.termsLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:25];
	NSLayoutConstraint* c11 = [NSLayoutConstraint constraintWithItem:self.termsLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.imgView attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
	NSLayoutConstraint* c12 = [NSLayoutConstraint constraintWithItem:self.termsLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.topContainer attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
	
		
	[self.view addConstraints:@[c5, c6, c7, c8, c9, c10, c11, c12]];
}

- (void) layoutContainers{
	self.topContainer.translatesAutoresizingMaskIntoConstraints = NO;
	self.bottomContainer.translatesAutoresizingMaskIntoConstraints = NO;
	self.menu.translatesAutoresizingMaskIntoConstraints = NO;
	
	NSLayoutConstraint* c1 = [NSLayoutConstraint constraintWithItem:self.topContainer attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0];
	NSLayoutConstraint* c2 = [NSLayoutConstraint constraintWithItem:self.topContainer attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.menu attribute:NSLayoutAttributeTop multiplier:0.7 constant:0];
	NSLayoutConstraint* c3 = [NSLayoutConstraint constraintWithItem:self.topContainer attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
	NSLayoutConstraint* c4 = [NSLayoutConstraint constraintWithItem:self.topContainer attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
	
	NSLayoutConstraint* c5 = [NSLayoutConstraint constraintWithItem:self.bottomContainer attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topContainer attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
	NSLayoutConstraint* c6 = [NSLayoutConstraint constraintWithItem:self.bottomContainer attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.menu attribute:NSLayoutAttributeTop multiplier:1 constant:0];
	NSLayoutConstraint* c7 = [NSLayoutConstraint constraintWithItem:self.bottomContainer attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
	NSLayoutConstraint* c8 = [NSLayoutConstraint constraintWithItem:self.bottomContainer attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
	
	NSLayoutConstraint* c9 = [NSLayoutConstraint constraintWithItem:self.menu attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:LAYOUT_DEFAULT_BUTTON_HEIGHT];
	NSLayoutConstraint* c10 = [NSLayoutConstraint constraintWithItem:self.menu attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
	NSLayoutConstraint* c11 = [NSLayoutConstraint constraintWithItem:self.menu attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
	NSLayoutConstraint* c12 = [NSLayoutConstraint constraintWithItem:self.menu attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
	
	[self.view addConstraints:@[c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11, c12]];
}

- (void) addLabels{
	self.termsLabel = [Appearance labelWithFontSize:SYMM_FONT_SIZE_SMALL];
	self.placeLabel = [Appearance labelWithFontSize:SYMM_FONT_SIZE_SMALL];
	self.switchLabel = [Appearance labelWithFontSize:SYMM_FONT_SIZE_SMALL];
	
	self.placeLabel.text = @"Please tell us where you are from";
	self.termsLabel.text = @"Terms and conditions";
	self.switchLabel.text = @"I do not accept the terms and conditions";
	
	self.switchLabel.textAlignment = NSTextAlignmentLeft;
	self.termsLabel.textAlignment = NSTextAlignmentCenter;
	self.placeLabel.textAlignment = NSTextAlignmentCenter;
	
	[self.topContainer addSubview:self.termsLabel];
	[self.bottomContainer addSubview:self.placeLabel];
	[self.menu addSubview:self.switchLabel];
}

- (void) addText{
	self.picker = [[UIPickerView alloc] init];
	self.picker.delegate = self;
	self.picker.dataSource = self;
	[self.bottomContainer addSubview:self.picker];
	self.terms = [Appearance textViewWithFontSize:SYMM_FONT_SIZE_V_SMALL];
	[self.topContainer addSubview:self.terms];
	self.terms.text = [GalleryService getTerms];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
	return [GeoService getAllCountryNames].count;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* tView = (UILabel*)view;
    if (!tView){
        tView = [Appearance labelWithFontSize:SYMM_FONT_SIZE_SMALL];
    }
    tView.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    return tView;
}

- (NSString*) base64{
	UIImage* largeImg = [FileLoader sharedInstance].tempThumbs[2];
	return [UIImagePNGRepresentation(largeImg) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

- (NSDictionary*) getData{
	NSNumber* latitude = [GeoService getAllLatitudes][self.selectedRow];
	NSNumber* longitude = [GeoService getAllLongitudes][self.selectedRow];
	NSString* country = [GeoService getAllCountryNames][self.selectedRow];
	NSNumber* drawerNum = [NSNumber numberWithInteger:[[FileLoader sharedInstance] getCurrentDrawingObject].drawerNum];
	NSDictionary* dic = @{@"country":country, @"drawerNum":drawerNum, @"latitude":latitude, @"longitude":longitude, @"imgData":[self base64]};
	return dic;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [GeoService getAllCountryNames][row];
}

- (void) disableAll{
	dispatch_async(dispatch_get_main_queue(), ^{
		[self.mySwitch setOn:NO animated:YES];
		self.mySwitch.enabled = NO;
		[self.picker setUserInteractionEnabled:NO];
		[self.picker setAlpha:0.5];
	});
}

-  (void) enableAll{
	dispatch_async(dispatch_get_main_queue(), ^{
		self.mySwitch.enabled = YES;
		[self.mySwitch setOn:NO animated:NO];
		[self.picker setUserInteractionEnabled:YES];
		[self.picker setAlpha:1];
	});
}

- (void)didReceiveMemoryWarning{
	[super didReceiveMemoryWarning];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
	self.selectedRow = row;
	NSNumber* latitude = [GeoService getAllLatitudes][row];
	NSNumber* longitude = [GeoService getAllLongitudes][row];
	[self.mapView mark:CGPointMake([latitude floatValue], [longitude floatValue]) withLabel:[GeoService getAllCountryNames][row]];
}

- (void) addSwitch{
	self.mySwitch = [[UISwitch alloc] init];
	self.mySwitch.onTintColor = [Colors getColorForTheme:FlatButtonThemeDefault];
	[self.mySwitch addTarget:self action:@selector(switchClick) forControlEvents:UIControlEventValueChanged];
	[self.menu addSubview:self.mySwitch];
}

- (void) switchClick{
	BOOL sel = self.mySwitch.on;
	if(sel){
		self.switchLabel.text = @"I accept the terms and conditions";
	}
	else{
		self.switchLabel.text = @"I do not accept the terms and conditions";
	}
	NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:sel], @"on", nil];
	[[NSNotificationCenter defaultCenter] postNotificationName:SYMM_NOTIF_ACCEPT_TERMS object:nil userInfo:dic];
}

- (void) layoutMenu{
	self.menu.translatesAutoresizingMaskIntoConstraints = NO;
	NSLayoutConstraint* c1 = [NSLayoutConstraint constraintWithItem:self.menu attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:10];
	NSLayoutConstraint* c2 = [NSLayoutConstraint constraintWithItem:self.menu attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:10];
	NSLayoutConstraint* c3 = [NSLayoutConstraint constraintWithItem:self.menu attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:-10];
	NSLayoutConstraint* c4 = [NSLayoutConstraint constraintWithItem:self.menu attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:35];
	[self.view addConstraints:@[c1, c2, c3, c4]];
}

- (void) layoutSwitch{
	self.mySwitch.translatesAutoresizingMaskIntoConstraints = NO;
	self.switchLabel.translatesAutoresizingMaskIntoConstraints = NO;
	NSLayoutConstraint* c1 = [NSLayoutConstraint constraintWithItem:self.mySwitch attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.menu attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
	NSLayoutConstraint* c2 = [NSLayoutConstraint constraintWithItem:self.mySwitch attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.menu attribute:NSLayoutAttributeTrailing multiplier:0.5 constant:-140];
	NSLayoutConstraint* c3 = [NSLayoutConstraint constraintWithItem:self.mySwitch attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:40];
	NSLayoutConstraint* c4 = [NSLayoutConstraint constraintWithItem:self.mySwitch attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:35];
	
	NSLayoutConstraint* c5 = [NSLayoutConstraint constraintWithItem:self.switchLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.menu attribute:NSLayoutAttributeBottom multiplier:1 constant:-3];
	NSLayoutConstraint* c6 = [NSLayoutConstraint constraintWithItem:self.switchLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.mySwitch attribute:NSLayoutAttributeTrailing multiplier:1 constant:18];
	NSLayoutConstraint* c7 = [NSLayoutConstraint constraintWithItem:self.switchLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:300];
	NSLayoutConstraint* c8 = [NSLayoutConstraint constraintWithItem:self.switchLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:35];
	
	[self.view addConstraints:@[c1, c2, c3, c4, c5, c6, c7, c8]];
}

- (void) layoutPicker{
	self.picker.translatesAutoresizingMaskIntoConstraints = NO;
	NSLayoutConstraint* c1 = [NSLayoutConstraint constraintWithItem:self.picker attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.placeLabel attribute:NSLayoutAttributeBottom multiplier:1 constant:-10];
	NSLayoutConstraint* c2 = [NSLayoutConstraint constraintWithItem:self.picker attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:LAYOUT_PICKER_HEIGHT];
	NSLayoutConstraint* c3 = [NSLayoutConstraint constraintWithItem:self.picker attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.bottomContainer attribute:NSLayoutAttributeLeading multiplier:1 constant:6];
	NSLayoutConstraint* c4 = [NSLayoutConstraint constraintWithItem:self.picker attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:LAYOUT_PICKER_WIDTH];
	[self.view addConstraints:@[c1, c2, c3, c4]];
}

- (void) layoutText{
	self.terms.translatesAutoresizingMaskIntoConstraints = NO;
	NSLayoutConstraint* c1 = [NSLayoutConstraint constraintWithItem:self.terms attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.termsLabel attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
	NSLayoutConstraint* c2 = [NSLayoutConstraint constraintWithItem:self.terms attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.topContainer attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
	NSLayoutConstraint* c3 = [NSLayoutConstraint constraintWithItem:self.terms attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.imgView attribute:NSLayoutAttributeTrailing multiplier:1 constant:10];
	NSLayoutConstraint* c4 = [NSLayoutConstraint constraintWithItem:self.terms attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.topContainer attribute:NSLayoutAttributeTrailing multiplier:1 constant:-10];
		
	[self.view addConstraints:@[c1, c2, c3, c4]];
}

- (void) addImg{
	self.imgView = [[UIImageView alloc] init];
	self.imgView.contentMode = UIViewContentModeScaleAspectFit;
	[self.topContainer addSubview:self.imgView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
	UIImage* largeImg = [FileLoader sharedInstance].tempThumbs[2];
	self.imgView.image = largeImg;
	[self.mySwitch setOn:NO animated:YES];
}

- (void) dealloc{
	[[NSNotificationCenter defaultCenter] removeObserver:self name:SYMM_NOTIF_DID_ROTATE object:nil];
	self.imgView.image = nil;
	[self.imgView removeFromSuperview];
	self.imgView = nil;
	[self.terms removeFromSuperview];
	self.terms = nil;
	[self.placeLabel removeFromSuperview];
	self.placeLabel = nil;
	[self.mapView removeFromSuperview];
	self.mapView = nil;
	[self.picker removeFromSuperview];
	self.picker = nil;
	[self.termsLabel removeFromSuperview];
	self.termsLabel = nil;
	[self.switchLabel removeFromSuperview];
	self.switchLabel = nil;
	[self.mySwitch removeTarget:self action:@selector(switchClick) forControlEvents:UIControlEventValueChanged];
	[self.mySwitch removeFromSuperview];
	self.mySwitch = nil;
	[self.topContainer removeFromSuperview];
	self.topContainer = nil;
	[self.bottomContainer removeFromSuperview];
	self.bottomContainer = nil;
	[self.menu removeFromSuperview];
	self.menu = nil;
	
}



@end
