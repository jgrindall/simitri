//
//  GeoService.h
//  Simitri
//
//  Created by John on 12/06/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GeoService : NSObject
+ (NSArray*) getAllCountryNames;
+ (NSArray*) getAllLatitudes;
+ (NSArray*) getAllLongitudes;
@end
