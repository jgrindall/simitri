
#import "HelpTextAnimController.h"
#import "Appearance.h"
#import "HelpAnimViewController.h"

@interface HelpTextAnimController ()

@property UITextView* topText;
@property UIView* containerView;
@property NSString* text;
@property NSInteger drawerNum;
@property HelpAnimViewController* animController;

@end

@implementation HelpTextAnimController

- (id) initWithText:(NSString*)text withDrawerNum:(NSInteger)drawerNum{
	self = [super init];
	if(self){
		self.text = text;
		self.drawerNum = drawerNum;
	}
	return self;
}

- (void)didReceiveMemoryWarning{
	[super didReceiveMemoryWarning];
}

- (void) touch:(UITouch*) anyObject{
	[self.animController touch:anyObject];
}

- (void)viewDidLoad{
    [super viewDidLoad];
	[self addText];
	[self addContainer];
	[self layoutText];
	[self layoutContainer];
}

- (void) loadAnim{
	DrawingObject* obj = [[DrawingObject alloc] init];
	obj.drawerNum = self.drawerNum;
	[obj setSize:self.containerView.frame.size];
	[obj loadDefaultColors];
	[self.animController loadDrawingObject:obj];
	[self.animController showMath:YES];
}

- (void) viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	[self loadAnim];
}

- (void) addText{
	self.topText = [Appearance textViewWithFontSize:SYMM_FONT_SIZE_MED];
	self.topText.textAlignment = NSTextAlignmentNatural;
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

- (void) layoutContainer{
	self.containerView.translatesAutoresizingMaskIntoConstraints = NO;
	NSLayoutConstraint* c1 = [NSLayoutConstraint constraintWithItem:self.containerView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topText attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
	NSLayoutConstraint* c2 = [NSLayoutConstraint constraintWithItem:self.containerView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
	NSLayoutConstraint* c3 = [NSLayoutConstraint constraintWithItem:self.containerView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
	NSLayoutConstraint* c4 = [NSLayoutConstraint constraintWithItem:self.containerView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
	[self.view addConstraints:@[c1, c2, c3, c4]];
}

- (void) addContainer{
	self.containerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height*0.25, self.view.frame.size.width, self.view.frame.size.height*0.75)];
	[self.view addSubview:self.containerView];
	self.animController = [[HelpAnimViewController alloc] init];
	[self addChildInto:self.containerView withController:self.animController];
}

- (void) dealloc{
	if(self.topText){
		[self.topText removeFromSuperview];
		self.topText = nil;
	}
	[self removeChildFrom:self.containerView withController:self.animController];
	if(self.containerView){
		[self.containerView removeFromSuperview];
		self.containerView = nil;
	}
	self.animController = nil;
	self.text = nil;
	self.containerView = nil;
}

@end
