//
//  DrawerFactory.h
//  Simitri
//
//  Created by John on 19/06/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ADrawer.h"

@interface DrawerFactory : NSObject

+ (ADrawer*) getDrawer:(NSInteger)drawerNum withScreenSize:(CGSize) screenSize;
+ (NSString*) getLabelForDrawerNum:(NSInteger)i;
+ (NSString*) getMessageForDrawerNum:(NSInteger)i;
+ (NSString*) imageUrlForIndex:(NSInteger)i;
+ (NSString*) imageDesForIndex:(NSInteger)i;
+ (NSString*) markedImageUrlForIndex:(NSInteger)i;

@end
