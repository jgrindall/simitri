
#import "HelpWelcomeController.h"
#import "Appearance.h"
#import "PolaroidView.h"
#import "LayoutConsts.h"
#import "SymmNotifications.h"

@interface HelpWelcomeController ()

@property UITextView* topText;
@property UITextView* bottomText;
@property PolaroidView* imgView;
@property NSString* text1;
@property NSString* text2;
@property UIImage* img;
@property NSString* des;
@property UIButton* closeButton;
@property UIButton* swipeButton;


@end

@implementation HelpWelcomeController

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
	[self addButtons];
	[self layoutText];
	[self layoutImage];
	[self layoutButtons];
	self.topText.backgroundColor = [UIColor redColor];
	self.bottomText.backgroundColor = [UIColor orangeColor];
	self.closeButton.backgroundColor = [UIColor yellowColor];
	self.imgView.backgroundColor = [UIColor purpleColor];
}

- (void) addButtons{
	CGSize size = CGSizeMake(LAYOUT_LONG_BUTTON_WIDTH, LAYOUT_DEFAULT_BUTTON_HEIGHT);
	self.closeButton = [Appearance flatTabButtonWithLabel:@"Ok let me start!" withIcon:@"multiply 2.png" withSize:size];
	self.swipeButton = [Appearance flatTabButtonWithLabel:@"Swipe to keep reading" withIcon:@"multiply 2.png" withSize:size];
	[self.view addSubview:self.closeButton];
	[self.view addSubview:self.swipeButton];
	[self.closeButton addTarget:self action:@selector(clickClose) forControlEvents:UIControlEventTouchUpInside];
	[self.closeButton addTarget:self action:@selector(clickClose) forControlEvents:UIControlEventTouchDown];
}

- (void) clickClose{
	NSLog(@"close");
	[[NSNotificationCenter defaultCenter] postNotificationName:SYMM_NOTIF_CLOSE_HELP object:nil];
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

- (void) layoutButtons{
	self.closeButton.translatesAutoresizingMaskIntoConstraints = NO;
	NSLayoutConstraint* c1 = [NSLayoutConstraint constraintWithItem:self.closeButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:LAYOUT_DEFAULT_BUTTON_HEIGHT];
	NSLayoutConstraint* c2 = [NSLayoutConstraint constraintWithItem:self.closeButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:LAYOUT_LONG_BUTTON_WIDTH];
	NSLayoutConstraint* c3 = [NSLayoutConstraint constraintWithItem:self.closeButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:-100];
	NSLayoutConstraint* c4 = [NSLayoutConstraint constraintWithItem:self.closeButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
	[self.view addConstraints:@[c1, c2, c3, c4]];
	
	self.swipeButton.translatesAutoresizingMaskIntoConstraints = NO;
	NSLayoutConstraint* c5 = [NSLayoutConstraint constraintWithItem:self.swipeButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:LAYOUT_DEFAULT_BUTTON_HEIGHT];
	NSLayoutConstraint* c6 = [NSLayoutConstraint constraintWithItem:self.swipeButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:LAYOUT_LONG_BUTTON_WIDTH];
	NSLayoutConstraint* c7 = [NSLayoutConstraint constraintWithItem:self.swipeButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:100];
	NSLayoutConstraint* c8 = [NSLayoutConstraint constraintWithItem:self.swipeButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
	[self.view addConstraints:@[c5, c6, c7, c8]];
}

- (void) layoutText{
	self.topText.translatesAutoresizingMaskIntoConstraints = NO;
	NSLayoutConstraint* c1 = [NSLayoutConstraint constraintWithItem:self.topText attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0];
	NSLayoutConstraint* c2 = [NSLayoutConstraint constraintWithItem:self.topText attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
	NSLayoutConstraint* c3 = [NSLayoutConstraint constraintWithItem:self.topText attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:-0];
	NSLayoutConstraint* c4 = [NSLayoutConstraint constraintWithItem:self.topText attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:0.2 constant:0];
	[self.view addConstraints:@[c1, c2, c3, c4]];
	
	self.bottomText.translatesAutoresizingMaskIntoConstraints = NO;
	NSLayoutConstraint* c5 = [NSLayoutConstraint constraintWithItem:self.bottomText attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:0.8 constant:0];
	NSLayoutConstraint* c6 = [NSLayoutConstraint constraintWithItem:self.bottomText attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
	NSLayoutConstraint* c7 = [NSLayoutConstraint constraintWithItem:self.bottomText attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
	NSLayoutConstraint* c8 = [NSLayoutConstraint constraintWithItem:self.bottomText attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.closeButton attribute:NSLayoutAttributeTop multiplier:1 constant:0];
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
	[self.closeButton removeTarget:self action:@selector(clickClose) forControlEvents:UIControlEventTouchUpInside];
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
	[self.closeButton removeFromSuperview];
	[self.swipeButton removeFromSuperview];
	self.closeButton = nil;
	self.swipeButton = nil;
	self.text1 = nil;
	self.text2 = nil;
	self.img = nil;
}

@end
