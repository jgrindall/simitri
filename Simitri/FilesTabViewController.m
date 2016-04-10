//
//  SymmetryTabViewController.m
//  FileManager
//
//  Created by John on 26/05/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "FilesTabViewController.h"
#import "PFileViewer.h"
#import "LayoutConsts.h"
#import "TilesCollectionController.h"
#import "AlbumScreenViewController.h"
#import "FileCell.h"

@interface FilesTabViewController ()

@property NSArray* files;

@end

@implementation FilesTabViewController

- (id) initWithTitles:(NSArray*)titles {
	self = [super initWithTitles:titles];
	if (self) {
		
	}
	return self;
}

- (NSInteger) numChildren{
	return 2;
}

- (UIViewController*) getChildControllerAt:(NSInteger)i{
	UIViewController* child;
	if(i==0){
		UICollectionViewFlowLayout* aFlowLayout = [[UICollectionViewFlowLayout alloc] init];
		[aFlowLayout setItemSize:CGSizeMake(LAYOUT_FILE_THUMB_SIZE, LAYOUT_FILE_THUMB_SIZE)];
		[aFlowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
		aFlowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
		child = [[TilesCollectionController alloc] initWithCollectionViewLayout:aFlowLayout withCellIdent:@"FileCell" withCellClass:[FileCell class]];
	}
	else{
		child = [[AlbumScreenViewController alloc] init];
	}
	return child;
}

- (NSInteger) getSelectedIndex{
	return [super getSelectedIndex];
}

- (void) onViewAdded{
	[self showFiles];
}

- (void) showFiles{
	BOOL segShown = (self.files && self.files.count>=2 && self.files.count <= 20);
	[self showSegments:segShown];
	if(self.files){
		if(self.childShown > 0 && (!segShown || self.files.count <= 1)){
			[self showChild:0];
		}
		if(self.currentChildController){
			id<PFileViewer> child = (id<PFileViewer>)(self.currentChildController);
			[child loadFiles:self.files];
		}
	}
	
}

- (void) viewDidAppear:(BOOL)animated{
	[super viewDidAppear:animated];
	//[self showFiles];
}

- (void) loadFiles:(NSArray*) files{
	self.files = files;
	[self showFiles];
}

- (void) didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

@end
