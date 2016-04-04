//
//  ADeleteableController.m
//  Symmetry
//
//  Created by John on 20/05/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "ADeleteableController_Protected.h"
#import "AnimationUtils.h"
#import "FileCell.h"

@interface ADeleteableController ()
@property UIGestureRecognizer* tapRecognizer;
@property UIGestureRecognizer* pressRecognizer;
@end

@implementation ADeleteableController

- (void)viewDidLoad{
    [super viewDidLoad];
	_editing = NO;
	_selected = -1;
    //[self addGestures];
}

- (void) addGestures{
	self.tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
	[self.collectionView addGestureRecognizer:self.tapRecognizer];
	self.pressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
	[self.collectionView addGestureRecognizer:self.pressRecognizer];
	[self.tapRecognizer setDelegate:self];
	[self.pressRecognizer setDelegate:self];
	[self.tapRecognizer setCancelsTouchesInView:NO];
	[self.pressRecognizer setCancelsTouchesInView:NO];
	self.pressRecognizer.delaysTouchesBegan = YES;
	((UILongPressGestureRecognizer*)self.pressRecognizer).minimumPressDuration = 2.0;
}

- (void)didReceiveMemoryWarning{
	[super didReceiveMemoryWarning];
}

- (void)longPress:(id)sender {
	UIGestureRecognizer* gesture = (UIGestureRecognizer*)(sender);
	if(gesture.state == UIGestureRecognizerStateBegan){
		CGPoint p = [sender locationInView:self.collectionView];
		NSIndexPath* path = [self.collectionView indexPathForItemAtPoint:p];
		self.editing = YES;
		self.selected = path.item;
		[self.collectionView reloadData];
	}
}

- (UICollectionViewCell*) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath withIdentifier:(NSString *)ident withClass:(__unsafe_unretained Class)class{
	ADeleteableCell* myCell = [collectionView dequeueReusableCellWithReuseIdentifier:ident forIndexPath:indexPath];
	BOOL highlight = (indexPath.item == self.selected);
	if(!myCell){
		myCell = [[class alloc] init];
	}
	myCell.isAnimating = self.editing;
	myCell.isDeleteShown = self.editing;
	myCell.isHighlighted = (highlight && self.editing);
	return myCell;
}

- (void)tap:(id)sender {
	if(self.editing){
		self.editing = NO;
		self.selected = -1;
		[self.collectionView reloadData];
	}
}

- (void) addNew{
	
}

- (void) openFile{
	
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
	
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
	return YES;
}

- (void) performDelete:(NSIndexPath*) path{
	// override
}

- (void) deleteClicked:(id) sender{
	if([sender isKindOfClass:[ADeleteableCell class]]){
		UICollectionViewCell* cell = (ADeleteableCell *)(sender);
		NSIndexPath* path = [self.collectionView indexPathForCell:cell];
		self.editing = NO;
		self.selected = -1;
		[self performDelete:path];
		[self.collectionView reloadData];
	}
}

- (void) dealloc{
	if(self.tapRecognizer){
		[self.collectionView removeGestureRecognizer:self.tapRecognizer];
		self.tapRecognizer = nil;
	}
	if(self.pressRecognizer){
		[self.collectionView removeGestureRecognizer:self.pressRecognizer];
		self.pressRecognizer = nil;
	}
}

@end
