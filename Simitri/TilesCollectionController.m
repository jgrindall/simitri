//
//  MyFilesCollectionController.m
//  Symmetry
//
//  Created by John on 19/05/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "TilesCollectionController.h"
#import "FileCell.h"
#import "AnimationUtils.h"
#import "FileLoader.h"
#import "SymmNotifications.h"
#import "LayoutConsts.h"
#import "TilePopupViewController.h"
#import "DisplayUtils.h"
#import "MyFilesScreenController.h"
#import "ImageUtils.h"
#import "SoundManager.h"

@interface TilesCollectionController ()
@property (nonatomic) NSArray* files;
@property NSString* cellIdent;
@property Class cellClass;
@property UIPopoverController* pop;
@property NSMutableDictionary* polaroidCache;
@end

@implementation TilesCollectionController

@synthesize files = _files;

- (id)initWithCollectionViewLayout:(UICollectionViewLayout*) layout withCellIdent:(NSString*)ident withCellClass:(Class)class{
	self = [super initWithCollectionViewLayout:layout];
	if(self){
		self.cellIdent = ident;
		self.cellClass = class;
	}
	return self;
}

- (NSInteger) indexForAddNew{
	return 0;
}

- (void) loadFiles:(NSArray *)files{
	self.polaroidCache = nil;
	self.polaroidCache = [NSMutableDictionary dictionary];
	NSMutableArray* filesPlus = [NSMutableArray arrayWithArray:files];
	[filesPlus insertObject:[NSURL URLWithString:@""] atIndex:[self indexForAddNew]];
	_files = [filesPlus copy];
	[self.collectionView reloadData];
}

- (NSArray*) files{
	if(!_files){
		_files = [NSMutableArray array];
	}
	return _files;
}

- (NSInteger) getSelectedIndex{
	return [self getActualFileIndexAdjustedForAddNew:self.selected ];
}

- (NSInteger) getActualFileIndexAdjustedForAddNew:(NSInteger)i{
	return (i - 1);
}

- (void)viewDidLoad{
    [super viewDidLoad];
	self.collectionView.backgroundColor = [UIColor clearColor];
	[self.collectionView registerClass:[self cellClass] forCellWithReuseIdentifier:self.cellIdent];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hidePop) name:SYMM_NOTIF_HIDE_POPUP object:nil];
}

- (void) hidePop{
	if(self.pop){
		[self.pop dismissPopoverAnimated:NO];
		self.pop = nil;
	}
}

- (void) viewDidAppear:(BOOL)animated{
	[super viewDidAppear:animated];
}

- (void) viewWillDisappear:(BOOL)animated{
	[self hidePop];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
	return 1;
}

- (void) performDelete:(NSIndexPath*) path{
	[DisplayUtils bubbleActionFrom:self toClass:[MyFilesScreenController class] withSelector:@"performDeleteAtItem:" withObject:[NSNumber numberWithInteger:path.item]];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return [self.files count];
}

- (BOOL) cellIsAddNewCell:(NSInteger) i{
	return (i == [self indexForAddNew]);
}

- (UIImage*)cachedImageAtIndex:(NSInteger)i{
	NSString* key = [NSString stringWithFormat:@"img%ld", (long)i];
	return [self.polaroidCache valueForKey:key];
}

- (void) cacheImage:(UIImage*) img forItem:(NSInteger)i{
	NSString* key = [NSString stringWithFormat:@"img%ld", (long)i];
	[self.polaroidCache setValue:img forKey:key];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	FileCell* cell = (FileCell*)[super collectionView:collectionView cellForItemAtIndexPath:indexPath withIdentifier:self.cellIdent withClass:self.cellClass];
	if(!cell) {
		cell = [[FileCell alloc] init];
	}
	NSURL* url = [self.files objectAtIndex:indexPath.item];
	BOOL isAdd = [self cellIsAddNewCell:indexPath.item];
	cell.isAddNew = isAdd;
	if(!isAdd){
		cell.isAddNew = NO;
		UIImage* img = [self cachedImageAtIndex:indexPath.item];
		if(!img){
			NSString* imgFileName = [[FileLoader sharedInstance] getSmallImgFilenameForUrl:url];
			img = [UIImage imageWithContentsOfFile:imgFileName];
			[self cacheImage:img forItem:indexPath.item];
		}
		cell.image = img;
	}
	[cell update];
	return cell;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionView *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
	return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionView *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
	return 10;
}

- (void) addNew{
	[[NSNotificationCenter defaultCenter] postNotificationName:SYMM_NOTIF_START_NEW_FILE object:nil];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(LAYOUT_FILE_THUMB_SIZE, LAYOUT_FILE_THUMB_SIZE);
}

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
	FileCell* cell = (FileCell*)[self collectionView:self.collectionView cellForItemAtIndexPath:indexPath];
	if(cell.isAddNew){
		[self addNew];
	}
	else if(self.editing){
		self.selected = indexPath.item;
		self.editing = NO;
		[self.collectionView reloadData];
	}
	else{
		self.selected = indexPath.item;
		NSURL* url = [self.files objectAtIndex:indexPath.item];
		NSString* imgFileName = [[FileLoader sharedInstance] getMedImgFilenameForUrl:url];
		CGRect realFrame = [self.collectionView convertRect:cell.frame toView:self.view];
		[self popupInRect:realFrame withFilename:imgFileName];
		self.editing = NO;
	}
	[self.collectionView reloadData];
}

- (void) popupInRect:(CGRect)frame withFilename:(NSString*)fileName{
	[[SoundManager sharedInstance] playClick];
	UIViewController* contents = [[TilePopupViewController alloc] initWithImage:fileName];
	self.pop = [[UIPopoverController alloc] initWithContentViewController:contents];
	self.pop.backgroundColor = [UIColor whiteColor];
	self.pop.popoverContentSize = CGSizeMake(LAYOUT_POPUP_WIDTH, LAYOUT_TILE_POPUP_HEIGHT);
	[self.pop presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
	[self emptyCache];
	self.polaroidCache = [NSMutableDictionary dictionary];
}

- (void) emptyCache{
	[self.polaroidCache removeAllObjects];
	self.polaroidCache = nil;
}

- (void) dealloc{
	[[NSNotificationCenter defaultCenter] removeObserver:self name:SYMM_NOTIF_HIDE_POPUP object:nil];
	[self emptyCache];
	self.cellClass = nil;
	[self hidePop];
	self.files = nil;
}

@end
