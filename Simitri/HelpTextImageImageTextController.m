
#import "HelpTextImageImageTextController.h"
#import "Appearance.h"
#import "PolaroidView.h"

@interface HelpTextImageImageTextController ()

@property UITextView* topText;
@property UITextView* bottomText;
@property PolaroidView* imgView1;
@property PolaroidView* imgView2;
@property NSString* text1;
@property NSString* text2;
@property UIImage* img1;
@property UIImage* img2;
@property NSString* des1;
@property NSString* des2;

@end

@implementation HelpTextImageImageTextController

- (id) initWithText:(NSString*)text1 withImage1:(UIImage*)img1 withImage2:(UIImage*)img2 withText:(NSString*)text2 withDes1:(NSString*) des1 withDes2:(NSString*)des2{
	self = [super init];
	if(self){
		self.text1 = text1;
		self.text2 = text2;
		self.img1 = img1;
		self.img2 = img2;
		self.des1 = des1;
		self.des2 = des2;
	}
	return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
	[self addText];
	[self addImage];
	[self layoutText];
	[self layoutImage];
}

- (void)didReceiveMemoryWarning{
	[super didReceiveMemoryWarning];
}

- (void) addText{
	self.topText = [Appearance textViewWithFontSize:SYMM_FONT_SIZE_MED];
	self.topText.textAlignment = NSTextAlignmentNatural;
	[self.view addSubview:self.topText];
	self.topText.text = self.text1;
	self.bottomText = [Appearance textViewWithFontSize:SYMM_FONT_SIZE_MED];
	self.bottomText.textAlignment = NSTextAlignmentNatural;
	[self.view addSubview:self.bottomText];
	self.bottomText.text = self.text2;
}

- (void) layoutText{
	self.topText.translatesAutoresizingMaskIntoConstraints = NO;
	NSLayoutConstraint* c1 = [NSLayoutConstraint constraintWithItem:self.topText attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0];
	NSLayoutConstraint* c2 = [NSLayoutConstraint constraintWithItem:self.topText attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
	NSLayoutConstraint* c3 = [NSLayoutConstraint constraintWithItem:self.topText attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:-0];
	NSLayoutConstraint* c4 = [NSLayoutConstraint constraintWithItem:self.topText attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:0.25 constant:0];
	[self.view addConstraints:@[c1, c2, c3, c4]];
	
	self.bottomText.translatesAutoresizingMaskIntoConstraints = NO;
	NSLayoutConstraint* c5 = [NSLayoutConstraint constraintWithItem:self.bottomText attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:0.75 constant:0];
	NSLayoutConstraint* c6 = [NSLayoutConstraint constraintWithItem:self.bottomText attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
	NSLayoutConstraint* c7 = [NSLayoutConstraint constraintWithItem:self.bottomText attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
	NSLayoutConstraint* c8 = [NSLayoutConstraint constraintWithItem:self.bottomText attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
	[self.view addConstraints:@[c5, c6, c7, c8]];
}

- (void) layoutImage{
	self.imgView1.translatesAutoresizingMaskIntoConstraints = NO;
	NSLayoutConstraint* c1 = [NSLayoutConstraint constraintWithItem:self.imgView1 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topText attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
	NSLayoutConstraint* c2 = [NSLayoutConstraint constraintWithItem:self.imgView1 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
	NSLayoutConstraint* c3 = [NSLayoutConstraint constraintWithItem:self.imgView1 attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:0.5 constant:0];
	NSLayoutConstraint* c4 = [NSLayoutConstraint constraintWithItem:self.imgView1 attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.bottomText attribute:NSLayoutAttributeTop multiplier:1 constant:0];
	[self.view addConstraints:@[c1, c2, c3, c4]];
	
	self.imgView2.translatesAutoresizingMaskIntoConstraints = NO;
	NSLayoutConstraint* c5 = [NSLayoutConstraint constraintWithItem:self.imgView2 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topText attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
	NSLayoutConstraint* c6 = [NSLayoutConstraint constraintWithItem:self.imgView2 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:0.5 constant:0];
	NSLayoutConstraint* c7 = [NSLayoutConstraint constraintWithItem:self.imgView2 attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
	NSLayoutConstraint* c8 = [NSLayoutConstraint constraintWithItem:self.imgView2 attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.bottomText attribute:NSLayoutAttributeTop multiplier:1 constant:0];
	[self.view addConstraints:@[c5, c6, c7, c8]];
}

- (void) addImage{
	self.imgView1 = [[PolaroidView alloc] initWithFrame:CGRectMake(0,0,100,100) hasDes:YES];
	[self.imgView1 loadImage:self.img1 withDescription:self.des1];
	[self.view addSubview:self.imgView1];
	self.imgView2 = [[PolaroidView alloc] initWithFrame:CGRectMake(0,0,100,100) hasDes:YES];
	[self.imgView2 loadImage:self.img2 withDescription:self.des2];
	[self.view addSubview:self.imgView2];
}

- (void) dealloc{
	if(self.topText){
		[self.topText removeFromSuperview];
		self.topText = nil;
	}
	if(self.bottomText){
		[self.bottomText removeFromSuperview];
		self.bottomText = nil;
	}
	if(self.imgView1){
		[self.imgView1 removeFromSuperview];
		self.imgView1 = nil;
	}
	if(self.imgView2){
		[self.imgView2 removeFromSuperview];
		self.imgView2 = nil;
	}
	self.text1 = nil;
	self.text2 = nil;
	self.img1 = nil;
	self.img2 = nil;
}

@end
