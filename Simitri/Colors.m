

#import "Colors.h"
#import "UIColor+Utils.h"

@implementation Colors

#define NUM_ELEMS(x)  (sizeof(x) / sizeof(x[0]))

static NSArray* allColorValues = nil;

static NSArray* allColors = nil;

static int defaultFgColors [17] = {2, 35, 9, 10, 15, 26, 5, 0, 8, 27, 2, 40, 8, 23, 22, 20, 20};

static int defaultBgColors [17] = {0, 20, 15, 33, 12, 9, 23, 3, 19, 5, 8, 26, 2, 24, 8, 2, 35};

static int allFgColors[42] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41};

static int allBgColors[41] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41};

+ (NSArray*) getAllColors{
	if(!allColors){
		allColorValues = [NSArray arrayWithObjects:
						  @"#f5b4ae",
						  @"#ed7669",
						  @"#e74c3c",
						  @"#d62c1a",
						  @"#ffc680",
						  @"#ffa333",
						  @"#ff8c00",
						  @"#cc7000",
						  @"#f8e287",
						  @"#f4d03f",
						  @"#f1c40f",
						  @"#c29d0b",
						  @"#93e7b6",
						  @"#54d98c",
						  @"#2ecc71",
						  @"#25a25a",
						  @"#6bebd1",
						  @"#28e1bd",
						  @"#1abc9c",
						  @"#148f77",
						  @"#a0cfee",
						  @"#5faee3",
						  @"#3498db",
						  @"#217dbb",
						  @"#d0b2dd",
						  @"#b07cc6",
						  @"#9b59b6",
						  @"#804399",
						  @"#d9d9d9",
						  @"#b3b3b3",
						  @"#999999",
						  @"#808080",
						  @"#87a2bd",
						  @"#587ba0",
						  @"#46627f",
						  @"#34495e",
						  @"#dbcfb8",
						  @"#c1ac85",
						  @"#b09563",
						  @"#957b4b",
						  @"#ffffff",
						  @"000000"
						 ,nil];
		
		
		NSMutableArray* allColorsMut = [[NSMutableArray alloc] init];
		for (NSString* s in allColorValues) {
			[allColorsMut addObject:[UIColor colorFromHexCode:s]];
		}
		allColors = [allColorsMut copy];
	}
	return allColors;
}

+ (UIColor*) getColor:(NSInteger)i{
	return [Colors getAllColors][i];
}

+ (UIColor*) getGridColor{
	return [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
}

+ (NSArray*) getAllFromArray:(int*) list n:(int)num{
	NSMutableArray* ret = [NSMutableArray array];
	for(int i = 0; i <= num - 1; i++){
		int index = list[i];
		[ret addObject:[Colors getColor:index]];
	}
	return [ret copy];
}

+ (NSArray*) getAllForeground{
	return [Colors getAllFromArray:allFgColors n:NUM_ELEMS(allFgColors)];
}

+ (NSArray*) getAllBackground{
	return [Colors getAllFromArray:allBgColors n:NUM_ELEMS(allBgColors)];
}

+ (UIColor*) defaultFgColorForIndex:(NSInteger)i{
	return [Colors getColor:[Colors defaultFgColorIndexForIndex:i]];
}

+ (UIColor*) defaultBgColorForIndex:(NSInteger)i{
	return [Colors getColor:[Colors defaultBgColorIndexForIndex:i]];
}

+ (NSInteger) defaultFgColorIndexForIndex:(NSInteger)i{
	// i is 0 to 16
	return defaultFgColors[i];
}

+ (NSInteger) defaultBgColorIndexForIndex:(NSInteger)i{
	// i is 0 to 16
	return defaultBgColors[i];
}

+ (NSInteger) defaultWidthForIndex:(NSInteger)i{
	return 6;
}

+ (NSInteger) indexForFgColor:(UIColor*) color{
	return [Colors indexForColor:color inArray:[Colors getAllForeground]];
}

+ (NSInteger) indexForBgColor:(UIColor*) color{
	return [Colors indexForColor:color inArray:[Colors getAllBackground]];
}

+ (NSInteger) indexForColor:(UIColor*) color inArray:(NSArray*)allColors{
	UIColor* test;
	NSInteger max = allColors.count;
	for(int i = 0;i < max; i++){
		test = (UIColor*)(allColors[i]);
		if([test equals: color]){
			return i;
		}
	}
	return -1;
}

+ (UIColor*) getColorForTheme:(FlatButtonThemes) f{
	if(f == FlatButtonThemeDefault){
		return [Colors getColor:22];
	}
	else if(f == FlatButtonThemePositive){
		return [Colors getColor:14];
	}
	else if(f == FlatButtonThemeDanger){
		return [Colors getColor:3];
	}
	else if(f == FlatButtonThemeTab){
		return [Colors symmGrayTextColor];
	}
	else{
		return [Colors symmGrayTextColor];
	}
}

+ (UIColor*) symmGrayBgColor{
	return [UIColor getGray:0.94];
}

+ (UIColor*) symmGrayTextColor{
	return [UIColor getGray:0.2];
}

+ (UIColor*) symmGrayButtonColor{
	return [UIColor getGray:0.45];
}

+ (UIColor*) symmGrayTextDisabledColor{
	return [UIColor getGray:0.87];
}

+ (UIColor*) symmGrayTextShadowColor{
	return [UIColor getGray:0.9 withAlpha:1.0];
}

@end



