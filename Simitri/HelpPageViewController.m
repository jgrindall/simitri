
//  Created by John on 22/05/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "HelpPageViewController.h"
#import "Appearance.h"
#import "AHelpContentsViewController.h"
#import "HelpTextImageController.h"
#import "HelpTextImageTextController.h"
#import "HelpTextImageImageTextController.h"
#import "HelpTextAnimController.h"
#import "ImageUtils.h"
#import "HelpWelcomeController.h"
#import "DrawerFactory.h"
#import "HelpJustTextController.h"

@interface HelpPageViewController ()

@property UIView* contentsView;
@property AHelpContentsViewController* contentsController;
@property UILabel* label;
@end

@implementation HelpPageViewController

- (id) init{
	self = [super init];
	if(self){
		
	}
	return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
	[self addLabel];
	[self addContainer];
}

- (void) viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	[self layoutLabel];
	[self layoutContainer];
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	if([self.contentsController isKindOfClass:[HelpTextAnimController class]]){
		HelpTextAnimController* anim = (HelpTextAnimController*)(self.contentsController);
		[anim touch:[touches anyObject] ];
	}
}


- (void) layoutContainer{
	self.contentsView.translatesAutoresizingMaskIntoConstraints = NO;
	NSLayoutConstraint* c1 = [NSLayoutConstraint constraintWithItem:self.contentsView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.label attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
	NSLayoutConstraint* c2 = [NSLayoutConstraint constraintWithItem:self.contentsView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:15];
	NSLayoutConstraint* c3 = [NSLayoutConstraint constraintWithItem:self.contentsView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:-15];
	NSLayoutConstraint* c4 = [NSLayoutConstraint constraintWithItem:self.contentsView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
	[self.view addConstraints:@[c1, c2, c3, c4]];
}

- (void) layoutLabel{
	self.label.translatesAutoresizingMaskIntoConstraints = NO;
	NSLayoutConstraint* c1 = [NSLayoutConstraint constraintWithItem:self.label attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0];
	NSLayoutConstraint* c2 = [NSLayoutConstraint constraintWithItem:self.label attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:15];
	NSLayoutConstraint* c3 = [NSLayoutConstraint constraintWithItem:self.label attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:-15];
	NSLayoutConstraint* c4 = [NSLayoutConstraint constraintWithItem:self.label attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:30];
	[self.view addConstraints:@[c1, c2, c3, c4]];
}

- (void) addContainer{
	self.contentsView = [[UIImageView alloc] initWithFrame:self.view.frame];
	self.contentsView.contentMode = UIViewContentModeScaleAspectFit;
	[self.view addSubview:self.contentsView];
}

- (void) addLabel{
	self.label = [Appearance labelWithFontSize:SYMM_FONT_SIZE_LARGE];
	self.label.textAlignment = NSTextAlignmentCenter;
	[self.view addSubview:self.label];
}

- (void)populate{
	[super populate];
	NSInteger num = [self.dataObject integerValue];
	self.label.text = [HelpPageViewController getLabelForIndex:num];
	[self removeChild];
	self.contentsController = [HelpPageViewController getControllerForIndex:num];
	[self addChildInto:self.contentsView withController:self.contentsController];
}

- (void) cleanUpView{
	if(self.contentsView){
		[self removeChild];
		[self.contentsView removeFromSuperview];
		self.contentsView = nil;
	}
	[self.view removeFromSuperview];
	self.view = nil;
}

- (void)didReceiveMemoryWarning{
	[super didReceiveMemoryWarning];
	if(self.view && !self.view.window){
		[self cleanUpView];
	}
}

+ (AHelpContentsViewController*) getControllerForIndex:(NSInteger)i{
	if(i == 0){
		return [[HelpTextImageTextController alloc] initWithText:[self getTextForIndex:i][0] withImage:[ImageUtils loadImageNamed:@"p3m1.jpg"] withText:[self getTextForIndex:i][1] withDes:@"A Persian glazed tile"];
	}
	//trans
	else if(i==1){
		return [[HelpTextImageController alloc] initWithText:[self getTextForIndex:i][0] withImage:[ImageUtils loadImageNamed:[DrawerFactory imageUrlForIndex:0]] withDes:[DrawerFactory imageDesForIndex:0] withPol:YES];
	}
	else if(i==2){
		return [[HelpTextAnimController alloc] initWithText:[self getTextForIndex:i][0] withDrawerNum:0];
	}
	//rot
	else if(i==3){
		return [[HelpTextImageController alloc] initWithText:[self getTextForIndex:i][0] withImage:[ImageUtils loadImageNamed:[DrawerFactory imageUrlForIndex:3]] withDes:[DrawerFactory imageDesForIndex:3] withPol:YES];
	}
	else if(i==4){
		return [[HelpTextAnimController alloc] initWithText:[self getTextForIndex:i][0] withDrawerNum:3];
	}
	else if(i==5){
		return [[HelpTextImageController alloc] initWithText:[self getTextForIndex:i][0] withImage:[ImageUtils loadImageNamed:[DrawerFactory markedImageUrlForIndex:3]] withDes:[DrawerFactory imageDesForIndex:3] withPol:YES];
	}
	//ref
	else if(i==6){
		return [[HelpTextImageTextController alloc] initWithText:[self getTextForIndex:i][0] withImage:[ImageUtils loadImageNamed:[DrawerFactory imageUrlForIndex:15]] withText:[self getTextForIndex:i][1] withDes:[DrawerFactory imageDesForIndex:15]];
	}
	else if(i == 7){
		return [[HelpTextAnimController alloc] initWithText:[self getTextForIndex:i][0] withDrawerNum:15];
	}
	else if(i == 8){
		return [[HelpTextImageController alloc] initWithText:[self getTextForIndex:i][0] withImage:[ImageUtils loadImageNamed:[DrawerFactory markedImageUrlForIndex:15]] withDes:[DrawerFactory imageDesForIndex:15] withPol:YES];
	}
	//glide ref
	else if(i==9){
		return [[HelpTextImageController alloc] initWithText:[self getTextForIndex:i][0] withImage:[ImageUtils loadImageNamed:[DrawerFactory imageUrlForIndex:10]] withDes:[DrawerFactory imageDesForIndex:10] withPol:YES];
	}
	else if(i == 10){
		return [[HelpTextAnimController alloc] initWithText:[self getTextForIndex:i][0] withDrawerNum:10];
	}
	else if(i == 11){
		return [[HelpTextImageController alloc] initWithText:[self getTextForIndex:i][0] withImage:[ImageUtils loadImageNamed:[DrawerFactory markedImageUrlForIndex:10]] withDes:[DrawerFactory imageDesForIndex:10] withPol:YES];
	}
	else{
		return [[HelpJustTextController alloc] initWithText:[self getTextForIndex:i][0]];
	}
}

+ (NSString*) getLabelForIndex:(NSInteger)i{
	if(i == 0){
		return @"1. Welcome to Simitri";
	}
	else if(i==1){
		return @"2. Types of symmetry - Translations";
	}
	else if(i==2){
		return @"3. Types of symmetry - Translations continued";
	}
	else if(i==3){
		return @"4. Types of symmetry - Rotations";
	}
	else if(i==4){
		return @"5. Types of symmetry - Rotations continued";
	}
	else if(i==5){
		return @"6. Types of symmetry - Rotations continued";
	}
	else if(i==6){
		return @"7. Types of symmetry - Reflections";
	}
	else if(i==7){
		return @"8. Types of symmetry - Reflections continued";
	}
	else if(i==8){
		return @"9. Types of symmetry - Reflections continued";
	}
	else if(i==9){
		return @"10. Types of symmetry - Glide Reflections";
	}
	else if(i==10){
		return @"11. Types of symmetry - Glide Reflections continued";
	}
	else if(i==11){
		return @"12. Types of symmetry - Glide Reflections continued";
	}
	else{
		return @"17. Privacy policy";
	}
}

+ (NSArray*) getTextForIndex:(NSInteger)i{
	if(i == 0){
		return @[@"A 'symmetry' of a repeating pattern is a way of transforming the pattern so it looks exactly the same before and after. Such patterns occur frequently in architecture and decorative art, for example in the image below, a detail from a Persian glazed tile. A 'symmetry group' is a mathematical term for all the symmetries possessed by a pattern.", @"In two dimensions there are exactly 17 different symmetry groups (also called wallpaper groups). Using this app you can explore them all, create your own artistic patterns and see those created by others."];
	}
	else if (i==1){
		return @[@"A translation is the simplest kind of symmetry. It is the transformation that just moves a pattern in a certain direction. All wallpaper groups possess at least two translations and the simplest wallpaper group contains only translations.\n\nCan you see how the motifs can be moved without changing the pattern at all? This symmetry group is named \"p1(O)\" - the official scientific name is followed by the mathematical name in brackets."];
	}
	else if (i==2){
		return @[@"This interactive animation shows the pair of translations. Click on the arrows to see the transformations. In addition, the grid shows so-called 'fundamental regions' which repeat to fill the entire space.\nThe two marked translations are not the only possibilities - you could also translate two spaces to the left for example. But the two shown and their reverse translations can be used in combination to generate all the others, so they are called 'generators'."];
	}
	else if (i==3){
		return @[@"A rotational symmetry has a centre and an order. The order is the number of times the rotation must be repeated to make a full turn.\n\nYou can rotate the pattern below about the middle of one of the circles by 90 degrees without changing it. This is a rotational symmetry of order 4 (since you must repeat it 4 times to get full turn of 360 degrees).", @"abc"];
	}
	else if (i==4){
		return @[@"Rotational symmetries are shown in the interactive animations by small markers that you can click on.  A rotational symmetry of order 4 (90 degrees) is indicated by a small square and a symmetry of order 2 (180 degrees) is shown by a small circle. Click on them to see the pattern rotate!"];
	}
	else if (i==5){
		return @[@"The centres of rotation and fundamental regions are shown in this image - circles mark centres of rotation of order 2 and squares mark centres of rotation of order 4."];
	}
	else if (i==6){
		return @[@"A reflection can be thought of as a mirror line. Points move to the other side of the line but stay the same distance away.\n\nThe pattern below contains numerous mirror lines - if you reflect in any of them the pattern would not be changed. How many mirror lines can you see?  Some are horizontal, some vertical and some are at a 45 degree slope.", @"You might be able to see that there is also some rotational symmetry. For example, you can rotate the whole pattern by 90 degrees about the middle of any blue flower. This is typical of symmetry groups - the presence of some symmetries automatically means that others exist, and this goes some way to explaining why there are only 17."];
	}
	else if (i==7){
		return @[@"This interactive animation allows you to visualise all the lines of reflection for a pattern - click on the dashed lines to see the pattern reflected.\n\nNotice that only the generators of the symmetry group are shown- there are other symmetries (for example rotations mentioned before) - can you see them?"];
	}
	else if (i==8){
		return @[@"The lines of reflection are shown in this image. The fundamental region is a right-angled triangle and the mirror lines are vertical, horizontal and at 45 degrees. The extra centres of rotation of order 4 are located at the middle of the blue flowers and on the small white emblems."];
	}
	else if (i==9){
		return @[@"A glide reflection is the hardest type of symmetry to spot. A glide reflection consists of a translation followed by a reflection in the line of the translation. For example, in the image below it is easy to spot vertical lines of reflective symmetry, there is one along each of the green lines, through the centre of each cup shape.\n\nBut there is also a glide reflection that moves the pattern upwards AND reflects in a vertical line. Can you spot it?"];
	}
	else if (i==10){
		return @[@"In the interactive animation below, lines of reflection are shown by dashed lines and glide reflections are shown by dashed arrows. They indicate a translation along the arrow followed by a reflection in the line of the arrow.\n\nIn this symmetry group the glide reflections are parallel to, and mid-way between the mirror lines."];
	}
	else if (i==11){
		return @[@"Here is one of the glide reflections marked - translate upwards along the arrow and then reflect in the line of the arrow!\n\nEach glide reflection is  mid-way between the lines of reflection which pass through the green sections of the motif."];
	}
	else{
		NSString* line0 = @"This application does not collect any personal information from users apart from the country you live in. It does not collect your name, email address or any other piece of personally identifiable information.";
		NSString* line1 = @"This application asks for your country only if you chose to submit your designs to the Gallery.";
		NSString* line2 = @"Terms and conditions apply to submissions to the public gallery, you must accept these before submitting.";
		NSString* line3 = @"The gallery is publicly accessible to all users of the app and is intended purely as an educational resource.";
		NSString* line4 = @"All data on the servers for the Gallery is stored securely and is used internally - it is not shared with any 3rd parties.";
		NSString* line5 = @"The application does not contain any purchaseable content ('In-App Purchases').";
		NSString* line6 = @"You can, if you chose to, post to your Facebook or Twitter feed from inside the app but we do not have access to the accounts or ANY information that is posted.";
		NSString* line7 = @"For more information, to suggest improvements, report bugs or tell us how you used the app, please contact simitriapp@gmail.com";
		NSString* line8 = @"All photographic images used in this app are in the public domain.";
		
		NSString* all = [NSString stringWithFormat:@"\n\u2022  %@\n\n\u2022  %@\n\n\u2022  %@\n\n\u2022  %@\n\n\u2022  %@\n\n\u2022  %@\n\n\u2022  %@\n\n\n\n\n\n\n%@\n\n%@", line0, line1, line2, line3, line4, line5, line6, line7, line8];
		return @[all];
	}
}

- (void) removeChild{
	if(self.contentsController){
		[self removeChildFrom:self.contentsView withController:self.contentsController];
		self.contentsController = nil;
	}
}

-(void) dealloc{
	[self cleanUpView];
}

@end
