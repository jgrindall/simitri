//
//  DrawingObject.m
//  Symmetry
//
//  Created by John on 19/05/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "DrawingObject.h"
#import "ADrawer.h"
#import "Colors.h"
#import "DrawerFactory.h"

@implementation DrawingObject

- (id) init{
	self = [super init];
	if(self){
		_color = [Colors defaultFgColorForIndex:0];
		_width = [Colors defaultWidthForIndex:0];
		_bgColor = [Colors defaultBgColorForIndex:0];
		_alpha = [NSNumber numberWithFloat:1];
		[self initLines];
	}
	return self;
}

- (NSString*) description{
	return [NSString stringWithFormat:@"drawing obj >>>>>   \n\n color %@  \n\n  width %ld \n\n  bgcolor %@  \n\n drawerNum  %ld\n\n", self.color, (long)self.width, self.bgColor, (long)self.drawerNum];
}

- (void) clear{
	[self initLines];
}

- (void) initLines{
	[self.lines removeAllObjects];
	self.lines = nil;
	self.lines = [[NSMutableArray alloc] init];
}

- (void)encodeWithCoder:(NSCoder *)coder{
    [coder encodeObject:self.lines forKey:@"lines"];
	[coder encodeObject:self.color forKey:@"color"];
	[coder encodeObject:self.bgColor forKey:@"bgColor"];
	[coder encodeObject:[NSNumber numberWithInteger:self.drawerNum] forKey:@"drawerNum"];
	[coder encodeObject:[NSNumber numberWithInteger:self.width] forKey:@"width"];
	[coder encodeObject:self.baseImage forKey:@"baseImage"];
}

- (void) loadDefaultColors{
	self.color = [Colors defaultFgColorForIndex:self.drawerNum];
	self.width = [Colors defaultWidthForIndex:self.drawerNum];
	self.bgColor = [Colors defaultBgColorForIndex:self.drawerNum];
}

- (void) setSize:(CGSize)size{
	self.drawer = [DrawerFactory getDrawer:self.drawerNum withScreenSize:size];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
	self = [super init];
	if(self){
		self.color = (UIColor*)[aDecoder decodeObjectForKey:@"color"];
		self.bgColor = (UIColor*)[aDecoder decodeObjectForKey:@"bgColor"];
		self.lines = (NSMutableArray*)[aDecoder decodeObjectForKey:@"lines"];
		self.baseImage = (UIImage*)[aDecoder decodeObjectForKey:@"baseImage"];
		self.drawerNum = [(NSNumber*)[aDecoder decodeObjectForKey:@"drawerNum"] integerValue];
		self.width = [(NSNumber*)[aDecoder decodeObjectForKey:@"width"] integerValue];
	}
	return self;
}

- (void) dealloc{
	[self.lines removeAllObjects];
	self.lines = nil;
	self.color = nil;
	self.bgColor = nil;
	self.drawer = nil;
}

@end
