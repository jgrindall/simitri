
#import "HelpTextImageTextController.h"
#import "Appearance.h"
#import "PolaroidView.h"

@interface HelpTextImageTextController ()

@property UITextView* topText;
@property UITextView* bottomText;
@property PolaroidView* imgView;
@property NSString* text1;
@property NSString* text2;
@property UIImage* img;
@property NSString* des;

@end

@implementation HelpTextImageTextController

- (id) initWithText:(NSString*)text1 withImage:(UIImage*)img withText:(NSString*)text2 withDes:(NSString*) des{
	self = [super init];
	if(self){
		self.text1 = text1;
		self.text2 = text2;
		self.img = img;
		self.des = des;
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
	self.topText.textAlignment = NSTextAlignmentJustified;
	[self.view addSubview:self.topText];
	self.topText.text = self.text1;
	
	self.bottomText = [Appearance textViewWithFontSize:SYMM_FONT_SIZE_MED];
	self.bottomText.textAlignment = NSTextAlignmentJustified;
	[self.view addSubview:self.bottomText];
	self.bottomText.text = self.text2;
}

- (void) layoutText{
	self.topText.translatesAutoresizingMaskIntoConstraints = NO;
	NSLayoutConstraint* c1 = [NSLayoutConstraint constraintWithItem:self.topText attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0];
	NSLayoutConstraint* c2 = [NSLayoutConstraint constraintWithItem:self.topText attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
	NSLayoutConstraint* c3 = [NSLayoutConstraint constraintWithItem:self.topText attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:-0];
	NSLayoutConstraint* c4 = [NSLayoutConstraint constraintWithItem:self.topText attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:0.2 constant:0];
	[self.view addConstraints:@[c1, c2, c3, c4]];
	
	self.bottomText.translatesAutoresizingMaskIntoConstraints = NO;
	NSLayoutConstraint* c5 = [NSLayoutConstraint constraintWithItem:self.bottomText attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:0.875 constant:0];
	NSLayoutConstraint* c6 = [NSLayoutConstraint constraintWithItem:self.bottomText attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
	NSLayoutConstraint* c7 = [NSLayoutConstraint constraintWithItem:self.bottomText attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
	NSLayoutConstraint* c8 = [NSLayoutConstraint constraintWithItem:self.bottomText attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
	[self.view addConstraints:@[c5, c6, c7, c8]];
}

- (void) layoutImage{
	self.imgView.translatesAutoresizingMaskIntoConstraints = NO;
	NSLayoutConstraint* c1 = [NSLayoutConstraint constraintWithItem:self.imgView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topText attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
	NSLayoutConstraint* c2 = [NSLayoutConstraint constraintWithItem:self.imgView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
	NSLayoutConstraint* c3 = [NSLayoutConstraint constraintWithItem:self.imgView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
	NSLayoutConstraint* c4 = [NSLayoutConstraint constraintWithItem:self.imgView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.bottomText attribute:NSLayoutAttributeTop multiplier:1 constant:0];
	[self.view addConstraints:@[c1, c2, c3, c4]];
}

- (void) addImage{
	self.imgView = [[PolaroidView alloc] initWithFrame:CGRectMake(0, 0, 100, 100) hasDes:YES];
	[self.imgView loadImage:self.img withDescription:self.des];
	[self.view addSubview:self.imgView];
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
	if(self.imgView){
		[self.imgView removeFromSuperview];
		self.imgView = nil;
	}
	self.text1 = nil;
	self.text2 = nil;
	self.img = nil;
}

@end
