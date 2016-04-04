
#import "HelpJustTextController.h"
#import "Appearance.h"

@interface HelpJustTextController ()

@property UITextView* topText;
@property NSString* text;

@end

@implementation HelpJustTextController

- (id) initWithText:(NSString*)text{
	self = [super init];
	if(self){
		self.text = text;
	}
	return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
	[self addText];
	[self layoutText];
}

- (void) addText{
	self.topText = [Appearance textViewWithFontSize:SYMM_FONT_SIZE_MED];
	self.topText.textAlignment = NSTextAlignmentLeft;
	[self.view addSubview:self.topText];
	self.topText.text = self.text;
}

- (void) layoutText{
	self.topText.translatesAutoresizingMaskIntoConstraints = NO;
	NSLayoutConstraint* c1 = [NSLayoutConstraint constraintWithItem:self.topText attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0];
	NSLayoutConstraint* c2 = [NSLayoutConstraint constraintWithItem:self.topText attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
	NSLayoutConstraint* c3 = [NSLayoutConstraint constraintWithItem:self.topText attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
	NSLayoutConstraint* c4 = [NSLayoutConstraint constraintWithItem:self.topText attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
	[self.view addConstraints:@[c1, c2, c3, c4]];
}

- (void)didReceiveMemoryWarning{
	[super didReceiveMemoryWarning];
}

- (void) dealloc{
	if(self.topText){
		[self.topText removeFromSuperview];
		self.topText = nil;
	}
	self.text = nil;
}

@end

