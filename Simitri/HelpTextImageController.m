
#import "HelpTextImageController.h"
#import "Appearance.h"
#import "ImageUtils.h"
#import "PolaroidView.h"
#import "SymmNotifications.h"

@interface HelpTextImageController ()

@property UITextView* topText;
@property UIView* imgView;
@property NSString* text;
@property UIImage* img;
@property NSString* des;
@property BOOL isPolaroid;

@end

@implementation HelpTextImageController

- (id) initWithText:(NSString*)text withImage:(UIImage*)img withDes:(NSString*) des withPol:(BOOL)isPol{
	self = [super init];
	if(self){
		self.text = text;
		self.isPolaroid = isPol;
		self.img = img;
		self.des = des;
	}
	return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDidRotate:) name:SYMM_NOTIF_DID_ROTATE object:nil];
	[self addText];
	[self addImage];
	[self layoutText];
	[self layoutImage];
}

- (void) onDidRotate:(NSNotification*) notification{
	
}
/*
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
*/

- (void) addText{
	self.topText = [Appearance textViewWithFontSize:SYMM_FONT_SIZE_MED];
	self.topText.textAlignment = NSTextAlignmentJustified;
	[self.view addSubview:self.topText];
	self.topText.text = self.text;
}

- (void) layoutText{
	self.topText.translatesAutoresizingMaskIntoConstraints = NO;
	NSLayoutConstraint* c1 = [NSLayoutConstraint constraintWithItem:self.topText attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0];
	NSLayoutConstraint* c2 = [NSLayoutConstraint constraintWithItem:self.topText attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
	NSLayoutConstraint* c3 = [NSLayoutConstraint constraintWithItem:self.topText attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
	NSLayoutConstraint* c4 = [NSLayoutConstraint constraintWithItem:self.topText attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:0.2 constant:0];
	[self.view addConstraints:@[c1, c2, c3, c4]];
}

- (void) layoutImage{
	self.imgView.translatesAutoresizingMaskIntoConstraints = NO;
	NSLayoutConstraint* c1 = [NSLayoutConstraint constraintWithItem:self.imgView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topText attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
	NSLayoutConstraint* c2 = [NSLayoutConstraint constraintWithItem:self.imgView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
	NSLayoutConstraint* c3 = [NSLayoutConstraint constraintWithItem:self.imgView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
	NSLayoutConstraint* c4 = [NSLayoutConstraint constraintWithItem:self.imgView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
	[self.view addConstraints:@[c1, c2, c3, c4]];
}

- (void)didReceiveMemoryWarning{
	[super didReceiveMemoryWarning];
}

- (void) addImage{
	if(self.isPolaroid){
		self.imgView = [[PolaroidView alloc] initWithFrame:CGRectMake(0,0,100,100) hasDes:YES];
		[(PolaroidView*)self.imgView loadImage:self.img withDescription:self.des];
	}
	else{
		self.imgView = [[UIImageView alloc] init];
		self.imgView.contentMode = UIViewContentModeScaleAspectFit;
		[((UIImageView*)self.imgView) setImage:self.img];
	}
	[self.view addSubview:self.imgView];
}

- (void) dealloc{
	[[NSNotificationCenter defaultCenter] removeObserver:self name:SYMM_NOTIF_DID_ROTATE object:nil];
	if(self.topText){
		[self.topText removeFromSuperview];
		self.topText = nil;
	}
	if(self.imgView){
		[self.imgView removeFromSuperview];
		self.imgView = nil;
	}
	self.text = nil;
	self.img = nil;
}

@end
