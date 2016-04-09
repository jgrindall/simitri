//
//  ToolsBarViewController.m
//  Symmetry
//
//  Created by John on 29/05/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "ToolsBarViewController.h"
#import "ColorViewController.h"
#import "WidthViewController.h"
#import "ColorCell.h"
#import "BgViewController.h"
#import "UIColor+Utils.h"
#import "LayoutConsts.h"
#import "PColorView.h"
#import "PWidthView.h"
#import "Appearance.h"
#import "Colors.h"

@interface ToolsBarViewController ()

@property UICollectionViewController<PColorView>* colorViewController;
@property UIView* colorContainer;
@property UICollectionViewController<PColorView>* bgViewController;
@property UIView* bgContainer;
@property UIViewController<PWidthView>* widthViewController;
@property UIView* widthContainer;
@property UILabel* fgLabel;
@property UILabel* bgLabel;

@end

@implementation ToolsBarViewController

- (void)viewDidLoad{
    [super viewDidLoad];
	[self setupAll];
}

- (void) viewWillDisappear:(BOOL)animated{
	[self.view.layer removeAllAnimations];
}

- (void) viewWillAppear:(BOOL)animated{
	[self layoutAll];
}

- (void) setupAll{
	self.view.backgroundColor = [UIColor whiteColor];
	[self addAll];
	[self addChildInto: self.colorContainer withController:self.colorViewController];
	[self addChildInto: self.widthContainer withController:self.widthViewController];
	[self addChildInto: self.bgContainer withController:self.bgViewController];
}

- (void) setColor:(UIColor*)color{
	NSInteger colorIndex = [Colors indexForFgColor:color];
	[self.colorViewController setSelected:colorIndex];
}

- (void)didReceiveMemoryWarning{
	[super didReceiveMemoryWarning];
}

- (void) setBgColor:(UIColor*)color{
	NSInteger colorIndex = [Colors indexForBgColor:color];
	[self.bgViewController setSelected:colorIndex];
}

- (void) setWidth:(NSInteger)width{
	[self.widthViewController setSelected:width];
}

- (void) addAll{
	[self addColor];
	[self addWidth];
	[self addLabels];
	[self addBg];
}

- (void) layoutAll{
	[self layoutColor];
	[self layoutBg];
	[self layoutWidth];
	[self layoutLabels];
}

- (void) layoutColor{
	self.colorContainer.translatesAutoresizingMaskIntoConstraints = NO;
	NSLayoutConstraint* c1 = [NSLayoutConstraint constraintWithItem:self.colorContainer attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0];
	NSLayoutConstraint* c2 = [NSLayoutConstraint constraintWithItem:self.colorContainer attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:LAYOUT_LABEL_WIDTH];
	NSLayoutConstraint* c3 = [NSLayoutConstraint constraintWithItem:self.colorContainer attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:-LAYOUT_WIDTH_WIDTH - 5];
	NSLayoutConstraint* c4 = [NSLayoutConstraint constraintWithItem:self.colorContainer attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:LAYOUT_COLOR_VIEW_HEIGHT];
	[self.view addConstraints:@[c1, c2, c3, c4]];
}

- (void) layoutBg{
	self.bgContainer.translatesAutoresizingMaskIntoConstraints = NO;
	NSLayoutConstraint* c1 = [NSLayoutConstraint constraintWithItem:self.bgContainer attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.colorContainer attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
	NSLayoutConstraint* c2 = [NSLayoutConstraint constraintWithItem:self.bgContainer attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:LAYOUT_LABEL_WIDTH];
	NSLayoutConstraint* c3 = [NSLayoutConstraint constraintWithItem:self.bgContainer attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:-LAYOUT_WIDTH_WIDTH - 5];
	NSLayoutConstraint* c4 = [NSLayoutConstraint constraintWithItem:self.bgContainer attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:LAYOUT_COLOR_VIEW_HEIGHT];
	[self.view addConstraints:@[c1, c2, c3, c4]];
}

- (void) layoutWidth{
	self.widthContainer.translatesAutoresizingMaskIntoConstraints = NO;
	NSLayoutConstraint* c1 = [NSLayoutConstraint constraintWithItem:self.widthContainer attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0.25*LAYOUT_COLOR_VIEW_HEIGHT];
	NSLayoutConstraint* c2 = [NSLayoutConstraint constraintWithItem:self.widthContainer attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:LAYOUT_WIDTH_WIDTH];
	NSLayoutConstraint* c3 = [NSLayoutConstraint constraintWithItem:self.widthContainer attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:-4];
	NSLayoutConstraint* c4 = [NSLayoutConstraint constraintWithItem:self.widthContainer attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:1.5*LAYOUT_COLOR_VIEW_HEIGHT];
	[self.view addConstraints:@[c1, c2, c3, c4]];
}

- (void) addLabels{
	self.fgLabel = [Appearance labelWithFontSize:SYMM_FONT_SIZE_SMALL];
	self.fgLabel.text = @"Foreground";
	self.bgLabel = [Appearance labelWithFontSize:SYMM_FONT_SIZE_SMALL];
	self.bgLabel.text = @"Background";
	[self.view addSubview:self.fgLabel];
	[self.view addSubview:self.bgLabel];
}

-  (void) layoutLabels{
	self.fgLabel.translatesAutoresizingMaskIntoConstraints = NO;
	self.bgLabel.translatesAutoresizingMaskIntoConstraints = NO;
	NSLayoutConstraint* c1 = [NSLayoutConstraint constraintWithItem:self.fgLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.colorContainer attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
	NSLayoutConstraint* c2 = [NSLayoutConstraint constraintWithItem:self.fgLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:5];
	NSLayoutConstraint* c3 = [NSLayoutConstraint constraintWithItem:self.fgLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:LAYOUT_LABEL_WIDTH];
	NSLayoutConstraint* c32 = [NSLayoutConstraint constraintWithItem:self.fgLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:20];
	NSLayoutConstraint* c4 = [NSLayoutConstraint constraintWithItem:self.bgLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.bgContainer attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
	NSLayoutConstraint* c5 = [NSLayoutConstraint constraintWithItem:self.bgLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:5];
	NSLayoutConstraint* c6 = [NSLayoutConstraint constraintWithItem:self.bgLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:LAYOUT_LABEL_WIDTH];
	NSLayoutConstraint* c62 = [NSLayoutConstraint constraintWithItem:self.bgLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:20];
	[self.fgLabel setContentHuggingPriority: UILayoutPriorityFittingSizeLevel forAxis: UILayoutConstraintAxisVertical];
	[self.bgLabel setContentHuggingPriority: UILayoutPriorityFittingSizeLevel forAxis: UILayoutConstraintAxisVertical];
	[self.fgLabel setContentHuggingPriority: UILayoutPriorityFittingSizeLevel forAxis: UILayoutConstraintAxisHorizontal];
	[self.bgLabel setContentHuggingPriority: UILayoutPriorityFittingSizeLevel forAxis: UILayoutConstraintAxisHorizontal];
	[self.view addConstraints:@[c1, c2, c3, c32, c4, c5, c6, c62]];
}

- (void) addColor{
	self.colorContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
	self.colorContainer.clipsToBounds = YES;
	UICollectionViewFlowLayout *aFlowLayout = [[UICollectionViewFlowLayout alloc] init];
	[aFlowLayout setItemSize:CGSizeMake(LAYOUT_COLOR_CELL_SIZE, LAYOUT_COLOR_CELL_SIZE)];
	[aFlowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
	aFlowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
	self.colorViewController = [[ColorViewController alloc] initWithCollectionViewLayout:aFlowLayout withCellIdent:@"ColorCell" withCellClass:[ColorCell class] withColor:3];
	[self.view addSubview:self.colorContainer];
}

- (void) addBg{
	self.bgContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
	self.bgContainer.clipsToBounds = YES;
	UICollectionViewFlowLayout *aFlowLayout = [[UICollectionViewFlowLayout alloc] init];
	[aFlowLayout setItemSize:CGSizeMake(LAYOUT_COLOR_CELL_SIZE, LAYOUT_COLOR_CELL_SIZE)];
	aFlowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
	[aFlowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
	self.bgViewController = [[BgViewController alloc] initWithCollectionViewLayout:aFlowLayout withCellIdent:@"BgColorCell" withCellClass:[ColorCell class] withColor:1];
	[self.view addSubview:self.bgContainer];
}

- (void) addWidth{
	self.widthContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
	self.widthContainer.backgroundColor = [UIColor redColor];
	self.widthContainer.clipsToBounds = YES;
	self.widthViewController = [[WidthViewController alloc] initWithWidth:10];
	[self.view addSubview:self.widthContainer];
}

- (void) hide{
	[UIView animateWithDuration:0.5 animations:^{
		self.view.frame = CGRectIntegral(CGRectMake(0, -2*LAYOUT_COLOR_VIEW_HEIGHT, self.view.frame.size.width, LAYOUT_COLOR_VIEW_HEIGHT));
	}];
}

- (void) show{
	[UIView animateWithDuration:0.25 animations:^{
		self.view.frame = CGRectIntegral(CGRectMake(0, 0, self.view.frame.size.width, LAYOUT_COLOR_VIEW_HEIGHT));
	}];
}

- (void) dealloc{
	[self removeChildFrom:self.colorContainer withController:self.colorViewController];
	[self removeChildFrom:self.widthContainer withController:self.widthViewController];
	[self removeChildFrom:self.bgContainer withController:self.bgViewController];
	[self.fgLabel removeFromSuperview];
	[self.bgLabel removeFromSuperview];
	self.fgLabel = nil;
	self.bgLabel = nil;
	[self.bgContainer removeFromSuperview];
	[self.colorContainer removeFromSuperview];
	[self.widthContainer removeFromSuperview];
	self.bgContainer = nil;
	self.colorContainer = nil;
	self.bgContainer = nil;
}

@end
