//
//  ColorViewController.m
//  Symmetry
//
//  Created by John on 19/05/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "AColorViewController_Protected.h"
#import "ColorCell.h"
#import "Colors.h"
#import "SymmNotifications.h"
#import "AColorCell_Protected.h"
#import "Appearance.h"
#import "SoundManager.h"

@interface AColorViewController ()

@end

@implementation AColorViewController

@synthesize selectedColorIndex = _selectedColorIndex;

- (id)initWithCollectionViewLayout:(UICollectionViewLayout*) layout withCellIdent:(NSString*)ident withCellClass:(Class)class withColor:(NSInteger)colorIndex{
	self = [super initWithCollectionViewLayout:layout];
	if(self){
		self.selectedColorIndex = colorIndex;
		self.cellClass = class;
		self.cellIdent = ident;
	}
	return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
	[self.collectionView registerClass:[self cellClass] forCellWithReuseIdentifier:self.cellIdent];
	[Appearance styleCollectionView:self.collectionView];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
	return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return [[self colors] count];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionView *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
	return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionView *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
	return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	AColorCell* myCell = (AColorCell*)[collectionView dequeueReusableCellWithReuseIdentifier:self.cellIdent forIndexPath:indexPath];
	if(!myCell){
		myCell = (AColorCell*)[[self.cellClass alloc] init];
	}
	myCell.isSelected = (indexPath.item == self.selectedColorIndex);
	if(indexPath.item == 0){
		myCell.item = AColorCellPositionFirst;
	}
	else if(indexPath.item == [self.colors count]){
		myCell.item = AColorCellPositionLast;
	}
	else{
		myCell.item = AColorCellPositionMiddle;
	}
	myCell.color = self.colors[indexPath.item];
	[myCell setNeedsDisplay];
	return myCell;
}

- (void) setSelected:(NSInteger)i{
	self.color = i;
	[self.collectionView reloadData];
}

- (void) notifyColorChange{
	// override
}

- (void) setColor:(NSInteger)i{
	if(_selectedColorIndex != i){
		_selectedColorIndex = i;
		[self notifyColorChange];
	}
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
	if(self.selectedColorIndex == indexPath.item){
		return;
	}
	AColorCell* cell = (AColorCell*)[self.collectionView cellForItemAtIndexPath:indexPath];
	cell.isSelected = YES;
	[cell selectMe];
	NSIndexPath* prevPath = [NSIndexPath indexPathForItem:self.selectedColorIndex inSection:0];
	AColorCell* prevCell = (AColorCell*)[self.collectionView cellForItemAtIndexPath:prevPath];
	prevCell.isSelected = NO;
	[prevCell deselectMe];
	[self setColor:indexPath.item];
}

- (void) collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
	//
}

@end
