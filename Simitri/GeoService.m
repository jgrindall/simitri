//
//  GeoService.m
//  Simitri
//
//  Created by John on 12/06/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "GeoService.h"

@implementation GeoService

static NSArray* countries = nil;
static NSArray* countryNames = nil;
static NSArray* countryLat = nil;
static NSArray* countryLong = nil;

+ (NSArray*) pluck:(NSString*)key{
	NSArray* allCountries = [GeoService getAllCountries];
	NSMutableArray* r = [NSMutableArray array];
	for (NSDictionary* d in allCountries) {
		[r addObject:[d objectForKey: key]];
	}
	return [r copy];
}

+ (NSArray*) getAllCountryNames{
	if(!countryNames){
		countryNames = [GeoService pluck:@"name"];
	}
	return countryNames;
}

+ (NSArray*) getAllLatitudes{
	if(!countryLat){
		countryLat = [GeoService pluck:@"lat"];
	}
	return countryLat;
}

+ (NSArray*) getAllLongitudes{
	if(!countryLong){
		countryLong = [GeoService pluck:@"long"];
	}
	return countryLong;
}

+ (NSArray*) getAllCountries{
	if(!countries){
		NSArray *a = @[
					   @{
						   @"lat": @42.546245,
						   @"long": @1.601554,
						   @"name": @"Andorra"
						   },
					   @{
						   @"lat": @23.424076,
						   @"long": @53.847818,
						   @"name": @"United Arab Emirates"
						   },
					   @{
						   @"lat": @33.93911,
						   @"long": @67.709953,
						   @"name": @"Afghanistan"
						   },
					   @{
						   @"lat": @17.060816,
						   @"long": @-61.796428,
						   @"name": @"Antigua and Barbuda"
						   },
					   @{
						   @"lat": @18.220554,
						   @"long": @-63.068615,
						   @"name": @"Anguilla"
						   },
					   @{
						   @"lat": @41.153332,
						   @"long": @20.168331,
						   @"name": @"Albania"
						   },
					   @{
						   @"lat": @40.069099,
						   @"long": @45.038189,
						   @"name": @"Armenia"
						   },
					   @{
						   @"lat": @12.226079,
						   @"long": @-69.060087,
						   @"name": @"Netherlands Antilles"
						   },
					   @{
						   @"lat": @-11.202692,
						   @"long": @17.873887,
						   @"name": @"Angola"
						   },
					   @{
						   @"lat": @-75.250973,
						   @"long": @-0.071389,
						   @"name": @"Antarctica"
						   },
					   @{
						   @"lat": @-38.416097,
						   @"long": @-63.616672,
						   @"name": @"Argentina"
						   },
					   @{
						   @"lat": @-14.270972,
						   @"long": @-170.132217,
						   @"name": @"American Samoa"
						   },
					   @{
						   @"lat": @47.516231,
						   @"long": @14.550072,
						   @"name": @"Austria"
						   },
					   @{
						   @"lat": @-25.274398,
						   @"long": @133.775136,
						   @"name": @"Australia"
						   },
					   @{
						   @"lat": @12.52111,
						   @"long": @-69.968338,
						   @"name": @"Aruba"
						   },
					   @{
						   @"lat": @40.143105,
						   @"long": @47.576927,
						   @"name": @"Azerbaijan"
						   },
					   @{
						   @"lat": @43.915886,
						   @"long": @17.679076,
						   @"name": @"Bosnia and Herzegovina"
						   },
					   @{
						   @"lat": @13.193887,
						   @"long": @-59.543198,
						   @"name": @"Barbados"
						   },
					   @{
						   @"lat": @23.684994,
						   @"long": @90.356331,
						   @"name": @"Bangladesh"
						   },
					   @{
						   @"lat": @50.503887,
						   @"long": @4.469936,
						   @"name": @"Belgium"
						   },
					   @{
						   @"lat": @12.238333,
						   @"long": @-1.561593,
						   @"name": @"Burkina Faso"
						   },
					   @{
						   @"lat": @42.733883,
						   @"long": @25.48583,
						   @"name": @"Bulgaria"
						   },
					   @{
						   @"lat": @25.930414,
						   @"long": @50.637772,
						   @"name": @"Bahrain"
						   },
					   @{
						   @"lat": @-3.373056,
						   @"long": @29.918886,
						   @"name": @"Burundi"
						   },
					   @{
						   @"lat": @9.30769,
						   @"long": @2.315834,
						   @"name": @"Benin"
						   },
					   @{
						   @"lat": @32.321384,
						   @"long": @-64.75737,
						   @"name": @"Bermuda"
						   },
					   @{
						   @"lat": @4.535277,
						   @"long": @114.727669,
						   @"name": @"Brunei"
						   },
					   @{
						   @"lat": @-16.290154,
						   @"long": @-63.588653,
						   @"name": @"Bolivia"
						   },
					   @{
						   @"lat": @-14.235004,
						   @"long": @-51.92528,
						   @"name": @"Brazil"
						   },
					   @{
						   @"lat": @25.03428,
						   @"long": @-77.39628,
						   @"name": @"Bahamas"
						   },
					   @{
						   @"lat": @27.514162,
						   @"long": @90.433601,
						   @"name": @"Bhutan"
						   },
					   @{
						   @"lat": @-54.423199,
						   @"long": @3.413194,
						   @"name": @"Bouvet Island"
						   },
					   @{
						   @"lat": @-22.328474,
						   @"long": @24.684866,
						   @"name": @"Botswana"
						   },
					   @{
						   @"lat": @53.709807,
						   @"long": @27.953389,
						   @"name": @"Belarus"
						   },
					   @{
						   @"lat": @17.189877,
						   @"long": @-88.49765,
						   @"name": @"Belize"
						   },
					   @{
						   @"lat": @56.130366,
						   @"long": @-106.346771,
						   @"name": @"Canada"
						   },
					   @{
						   @"lat": @-12.164165,
						   @"long": @96.870956,
						   @"name": @"Cocos [Keeling] Islands"
						   },
					   @{
						   @"lat": @-4.038333,
						   @"long": @21.758664,
						   @"name": @"Congo [DRC]"
						   },
					   @{
						   @"lat": @6.611111,
						   @"long": @20.939444,
						   @"name": @"Central African Republic"
						   },
					   @{
						   @"lat": @-0.228021,
						   @"long": @15.827659,
						   @"name": @"Congo [Republic of]"
						   },
					   @{
						   @"lat": @46.818188,
						   @"long": @8.227512,
						   @"name": @"Switzerland"
						   },
					   @{
						   @"lat": @7.539989,
						   @"long": @-5.54708,
						   @"name": @"Côte d'Ivoire"
						   },
					   @{
						   @"lat": @-21.236736,
						   @"long": @-159.777671,
						   @"name": @"Cook Islands"
						   },
					   @{
						   @"lat": @-35.675147,
						   @"long": @-71.542969,
						   @"name": @"Chile"
						   },
					   @{
						   @"lat": @7.369722,
						   @"long": @12.354722,
						   @"name": @"Cameroon"
						   },
					   @{
						   @"lat": @35.86166,
						   @"long": @104.195397,
						   @"name": @"China"
						   },
					   @{
						   @"lat": @4.570868,
						   @"long": @-74.297333,
						   @"name": @"Colombia"
						   },
					   @{
						   @"lat": @9.748917,
						   @"long": @-83.753428,
						   @"name": @"Costa Rica"
						   },
					   @{
						   @"lat": @21.521757,
						   @"long": @-77.781167,
						   @"name": @"Cuba"
						   },
					   @{
						   @"lat": @16.002082,
						   @"long": @-24.013197,
						   @"name": @"Cape Verde"
						   },
					   @{
						   @"lat": @-10.447525,
						   @"long": @105.690449,
						   @"name": @"Christmas Island"
						   },
					   @{
						   @"lat": @35.126413,
						   @"long": @33.429859,
						   @"name": @"Cyprus"
						   },
					   @{
						   @"lat": @49.817492,
						   @"long": @15.472962,
						   @"name": @"Czech Republic"
						   },
					   @{
						   @"lat": @51.165691,
						   @"long": @10.451526,
						   @"name": @"Germany"
						   },
					   @{
						   @"lat": @11.825138,
						   @"long": @42.590275,
						   @"name": @"Djibouti"
						   },
					   @{
						   @"lat": @56.26392,
						   @"long": @9.501785,
						   @"name": @"Denmark"
						   },
					   @{
						   @"lat": @15.414999,
						   @"long": @-61.370976,
						   @"name": @"Dominica"
						   },
					   @{
						   @"lat": @18.735693,
						   @"long": @-70.162651,
						   @"name": @"Dominican Republic"
						   },
					   @{
						   @"lat": @28.033886,
						   @"long": @1.659626,
						   @"name": @"Algeria"
						   },
					   @{
						   @"lat": @-1.831239,
						   @"long": @-78.183406,
						   @"name": @"Ecuador"
						   },
					   @{
						   @"lat": @58.595272,
						   @"long": @25.013607,
						   @"name": @"Estonia"
						   },
					   @{
						   @"lat": @26.820553,
						   @"long": @30.802498,
						   @"name": @"Egypt"
						   },
					   @{
						   @"lat": @24.215527,
						   @"long": @-12.885834,
						   @"name": @"Western Sahara"
						   },
					   @{
						   @"lat": @15.179384,
						   @"long": @39.782334,
						   @"name": @"Eritrea"
						   },
					   @{
						   @"lat": @40.463667,
						   @"long": @-3.74922,
						   @"name": @"Spain"
						   },
					   @{
						   @"lat": @9.145,
						   @"long": @40.489673,
						   @"name": @"Ethiopia"
						   },
					   @{
						   @"lat": @61.92411,
						   @"long": @25.748151,
						   @"name": @"Finland"
						   },
					   @{
						   @"lat": @-16.578193,
						   @"long": @179.414413,
						   @"name": @"Fiji"
						   },
					   @{
						   @"lat": @-51.796253,
						   @"long": @-59.523613,
						   @"name": @"Falkland Islands"
						   },
					   @{
						   @"lat": @7.425554,
						   @"long": @150.550812,
						   @"name": @"Micronesia"
						   },
					   @{
						   @"lat": @61.892635,
						   @"long": @-6.911806,
						   @"name": @"Faroe Islands"
						   },
					   @{
						   @"lat": @46.227638,
						   @"long": @2.213749,
						   @"name": @"France"
						   },
					   @{
						   @"lat": @-0.803689,
						   @"long": @11.609444,
						   @"name": @"Gabon"
						   },
					   @{
						   @"lat": @55.378051,
						   @"long": @-3.435973,
						   @"name": @"United Kingdom"
						   },
					   @{
						   @"lat": @12.262776,
						   @"long": @-61.604171,
						   @"name": @"Grenada"
						   },
					   @{
						   @"lat": @42.315407,
						   @"long": @43.356892,
						   @"name": @"Georgia"
						   },
					   @{
						   @"lat": @3.933889,
						   @"long": @-53.125782,
						   @"name": @"French Guiana"
						   },
					   @{
						   @"lat": @49.465691,
						   @"long": @-2.585278,
						   @"name": @"Guernsey"
						   },
					   @{
						   @"lat": @7.946527,
						   @"long": @-1.023194,
						   @"name": @"Ghana"
						   },
					   @{
						   @"lat": @36.137741,
						   @"long": @-5.345374,
						   @"name": @"Gibraltar"
						   },
					   @{
						   @"lat": @71.706936,
						   @"long": @-42.604303,
						   @"name": @"Greenland"
						   },
					   @{
						   @"lat": @13.443182,
						   @"long": @-15.310139,
						   @"name": @"Gambia"
						   },
					   @{
						   @"lat": @9.945587,
						   @"long": @-9.696645,
						   @"name": @"Guinea"
						   },
					   @{
						   @"lat": @16.995971,
						   @"long": @-62.067641,
						   @"name": @"Guadeloupe"
						   },
					   @{
						   @"lat": @1.650801,
						   @"long": @10.267895,
						   @"name": @"Equatorial Guinea"
						   },
					   @{
						   @"lat": @39.074208,
						   @"long": @21.824312,
						   @"name": @"Greece"
						   },
					   @{
						   @"lat": @-54.429579,
						   @"long": @-36.587909,
						   @"name": @"South Georgia & SSI"
						   },
					   @{
						   @"lat": @15.783471,
						   @"long": @-90.230759,
						   @"name": @"Guatemala"
						   },
					   @{
						   @"lat": @13.444304,
						   @"long": @144.793731,
						   @"name": @"Guam"
						   },
					   @{
						   @"lat": @11.803749,
						   @"long": @-15.180413,
						   @"name": @"Guinea-Bissau"
						   },
					   @{
						   @"lat": @4.860416,
						   @"long": @-58.93018,
						   @"name": @"Guyana"
						   },
					   @{
						   @"lat": @31.354676,
						   @"long": @34.308825,
						   @"name": @"Gaza Strip"
						   },
					   @{
						   @"lat": @22.396428,
						   @"long": @114.109497,
						   @"name": @"Hong Kong"
						   },
					   @{
						   @"lat": @-53.08181,
						   @"long": @73.504158,
						   @"name": @"Heard Island and McDonald Islands"
						   },
					   @{
						   @"lat": @15.199999,
						   @"long": @-86.241905,
						   @"name": @"Honduras"
						   },
					   @{
						   @"lat": @45.1,
						   @"long": @15.2,
						   @"name": @"Croatia"
						   },
					   @{
						   @"lat": @18.971187,
						   @"long": @-72.285215,
						   @"name": @"Haiti"
						   },
					   @{
						   @"lat": @47.162494,
						   @"long": @19.503304,
						   @"name": @"Hungary"
						   },
					   @{
						   @"lat": @-0.789275,
						   @"long": @113.921327,
						   @"name": @"Indonesia"
						   },
					   @{
						   @"lat": @53.41291,
						   @"long": @-8.24389,
						   @"name": @"Ireland"
						   },
					   @{
						   @"lat": @31.046051,
						   @"long": @34.851612,
						   @"name": @"Israel"
						   },
					   @{
						   @"lat": @54.236107,
						   @"long": @-4.548056,
						   @"name": @"Isle of Man"
						   },
					   @{
						   @"lat": @20.593684,
						   @"long": @78.96288,
						   @"name": @"India"
						   },
					   @{
						   @"lat": @-6.343194,
						   @"long": @71.876519,
						   @"name": @"British Indian OT"
						   },
					   @{
						   @"lat": @33.223191,
						   @"long": @43.679291,
						   @"name": @"Iraq"
						   },
					   @{
						   @"lat": @32.427908,
						   @"long": @53.688046,
						   @"name": @"Iran"
						   },
					   @{
						   @"lat": @64.963051,
						   @"long": @-19.020835,
						   @"name": @"Iceland"
						   },
					   @{
						   @"lat": @41.87194,
						   @"long": @12.56738,
						   @"name": @"Italy"
						   },
					   @{
						   @"lat": @49.214439,
						   @"long": @-2.13125,
						   @"name": @"Jersey"
						   },
					   @{
						   @"lat": @18.109581,
						   @"long": @-77.297508,
						   @"name": @"Jamaica"
						   },
					   @{
						   @"lat": @30.585164,
						   @"long": @36.238414,
						   @"name": @"Jordan"
						   },
					   @{
						   @"lat": @36.204824,
						   @"long": @138.252924,
						   @"name": @"Japan"
						   },
					   @{
						   @"lat": @-0.023559,
						   @"long": @37.906193,
						   @"name": @"Kenya"
						   },
					   @{
						   @"lat": @41.20438,
						   @"long": @74.766098,
						   @"name": @"Kyrgyzstan"
						   },
					   @{
						   @"lat": @12.565679,
						   @"long": @104.990963,
						   @"name": @"Cambodia"
						   },
					   @{
						   @"lat": @-3.370417,
						   @"long": @-168.734039,
						   @"name": @"Kiribati"
						   },
					   @{
						   @"lat": @-11.875001,
						   @"long": @43.872219,
						   @"name": @"Comoros"
						   },
					   @{
						   @"lat": @17.357822,
						   @"long": @-62.782998,
						   @"name": @"Saint Kitts and Nevis"
						   },
					   @{
						   @"lat": @40.339852,
						   @"long": @127.510093,
						   @"name": @"North Korea"
						   },
					   @{
						   @"lat": @35.907757,
						   @"long": @127.766922,
						   @"name": @"South Korea"
						   },
					   @{
						   @"lat": @29.31166,
						   @"long": @47.481766,
						   @"name": @"Kuwait"
						   },
					   @{
						   @"lat": @19.513469,
						   @"long": @-80.566956,
						   @"name": @"Cayman Islands"
						   },
					   @{
						   @"lat": @48.019573,
						   @"long": @66.923684,
						   @"name": @"Kazakhstan"
						   },
					   @{
						   @"lat": @19.85627,
						   @"long": @102.495496,
						   @"name": @"Laos"
						   },
					   @{
						   @"lat": @33.854721,
						   @"long": @35.862285,
						   @"name": @"Lebanon"
						   },
					   @{
						   @"lat": @13.909444,
						   @"long": @-60.978893,
						   @"name": @"Saint Lucia"
						   },
					   @{
						   @"lat": @47.166,
						   @"long": @9.555373,
						   @"name": @"Liechtenstein"
						   },
					   @{
						   @"lat": @7.873054,
						   @"long": @80.771797,
						   @"name": @"Sri Lanka"
						   },
					   @{
						   @"lat": @6.428055,
						   @"long": @-9.429499,
						   @"name": @"Liberia"
						   },
					   @{
						   @"lat": @-29.609988,
						   @"long": @28.233608,
						   @"name": @"Lesotho"
						   },
					   @{
						   @"lat": @55.169438,
						   @"long": @23.881275,
						   @"name": @"Lithuania"
						   },
					   @{
						   @"lat": @49.815273,
						   @"long": @6.129583,
						   @"name": @"Luxembourg"
						   },
					   @{
						   @"lat": @56.879635,
						   @"long": @24.603189,
						   @"name": @"Latvia"
						   },
					   @{
						   @"lat": @26.3351,
						   @"long": @17.228331,
						   @"name": @"Libya"
						   },
					   @{
						   @"lat": @31.791702,
						   @"long": @-7.09262,
						   @"name": @"Morocco"
						   },
					   @{
						   @"lat": @43.750298,
						   @"long": @7.412841,
						   @"name": @"Monaco"
						   },
					   @{
						   @"lat": @47.411631,
						   @"long": @28.369885,
						   @"name": @"Moldova"
						   },
					   @{
						   @"lat": @42.708678,
						   @"long": @19.37439,
						   @"name": @"Montenegro"
						   },
					   @{
						   @"lat": @-18.766947,
						   @"long": @46.869107,
						   @"name": @"Madagascar"
						   },
					   @{
						   @"lat": @7.131474,
						   @"long": @171.184478,
						   @"name": @"Marshall Islands"
						   },
					   @{
						   @"lat": @41.608635,
						   @"long": @21.745275,
						   @"name": @"Macedonia [FYROM]"
						   },
					   @{
						   @"lat": @17.570692,
						   @"long": @-3.996166,
						   @"name": @"Mali"
						   },
					   @{
						   @"lat": @21.913965,
						   @"long": @95.956223,
						   @"name": @"Myanmar [Burma]"
						   },
					   @{
						   @"lat": @46.862496,
						   @"long": @103.846656,
						   @"name": @"Mongolia"
						   },
					   @{
						   @"lat": @22.198745,
						   @"long": @113.543873,
						   @"name": @"Macau"
						   },
					   @{
						   @"lat": @17.33083,
						   @"long": @145.38469,
						   @"name": @"Northern Mariana Islands"
						   },
					   @{
						   @"lat": @14.641528,
						   @"long": @-61.024174,
						   @"name": @"Martinique"
						   },
					   @{
						   @"lat": @21.00789,
						   @"long": @-10.940835,
						   @"name": @"Mauritania"
						   },
					   @{
						   @"lat": @16.742498,
						   @"long": @-62.187366,
						   @"name": @"Montserrat"
						   },
					   @{
						   @"lat": @35.937496,
						   @"long": @14.375416,
						   @"name": @"Malta"
						   },
					   @{
						   @"lat": @-20.348404,
						   @"long": @57.552152,
						   @"name": @"Mauritius"
						   },
					   @{
						   @"lat": @3.202778,
						   @"long": @73.22068,
						   @"name": @"Maldives"
						   },
					   @{
						   @"lat": @-13.254308,
						   @"long": @34.301525,
						   @"name": @"Malawi"
						   },
					   @{
						   @"lat": @23.634501,
						   @"long": @-102.552784,
						   @"name": @"Mexico"
						   },
					   @{
						   @"lat": @4.210484,
						   @"long": @101.975766,
						   @"name": @"Malaysia"
						   },
					   @{
						   @"lat": @-18.665695,
						   @"long": @35.529562,
						   @"name": @"Mozambique"
						   },
					   @{
						   @"lat": @-22.95764,
						   @"long": @18.49041,
						   @"name": @"Namibia"
						   },
					   @{
						   @"lat": @-20.904305,
						   @"long": @165.618042,
						   @"name": @"New Caledonia"
						   },
					   @{
						   @"lat": @17.607789,
						   @"long": @8.081666,
						   @"name": @"Niger"
						   },
					   @{
						   @"lat": @-29.040835,
						   @"long": @167.954712,
						   @"name": @"Norfolk Island"
						   },
					   @{
						   @"lat": @9.081999,
						   @"long": @8.675277,
						   @"name": @"Nigeria"
						   },
					   @{
						   @"lat": @12.865416,
						   @"long": @-85.207229,
						   @"name": @"Nicaragua"
						   },
					   @{
						   @"lat": @52.132633,
						   @"long": @5.291266,
						   @"name": @"Netherlands"
						   },
					   @{
						   @"lat": @60.472024,
						   @"long": @8.468946,
						   @"name": @"Norway"
						   },
					   @{
						   @"lat": @28.394857,
						   @"long": @84.124008,
						   @"name": @"Nepal"
						   },
					   @{
						   @"lat": @-0.522778,
						   @"long": @166.931503,
						   @"name": @"Nauru"
						   },
					   @{
						   @"lat": @-19.054445,
						   @"long": @-169.867233,
						   @"name": @"Niue"
						   },
					   @{
						   @"lat": @-40.900557,
						   @"long": @174.885971,
						   @"name": @"New Zealand"
						   },
					   @{
						   @"lat": @21.512583,
						   @"long": @55.923255,
						   @"name": @"Oman"
						   },
					   @{
						   @"lat": @8.537981,
						   @"long": @-80.782127,
						   @"name": @"Panama"
						   },
					   @{
						   @"lat": @-9.189967,
						   @"long": @-75.015152,
						   @"name": @"Peru"
						   },
					   @{
						   @"lat": @-17.679742,
						   @"long": @-149.406843,
						   @"name": @"French Polynesia"
						   },
					   @{
						   @"lat": @-6.314993,
						   @"long": @143.95555,
						   @"name": @"Papua New Guinea"
						   },
					   @{
						   @"lat": @12.879721,
						   @"long": @121.774017,
						   @"name": @"Philippines"
						   },
					   @{
						   @"lat": @30.375321,
						   @"long": @69.345116,
						   @"name": @"Pakistan"
						   },
					   @{
						   @"lat": @51.919438,
						   @"long": @19.145136,
						   @"name": @"Poland"
						   },
					   @{
						   @"lat": @46.941936,
						   @"long": @-56.27111,
						   @"name": @"Saint Pierre and Miquelon"
						   },
					   @{
						   @"lat": @-24.703615,
						   @"long": @-127.439308,
						   @"name": @"Pitcairn Islands"
						   },
					   @{
						   @"lat": @18.220833,
						   @"long": @-66.590149,
						   @"name": @"Puerto Rico"
						   },
					   @{
						   @"lat": @31.952162,
						   @"long": @35.233154,
						   @"name": @"Palestinian Territories"
						   },
					   @{
						   @"lat": @39.399872,
						   @"long": @-8.224454,
						   @"name": @"Portugal"
						   },
					   @{
						   @"lat": @7.51498,
						   @"long": @134.58252,
						   @"name": @"Palau"
						   },
					   @{
						   @"lat": @-23.442503,
						   @"long": @-58.443832,
						   @"name": @"Paraguay"
						   },
					   @{
						   @"lat": @25.354826,
						   @"long": @51.183884,
						   @"name": @"Qatar"
						   },
					   @{
						   @"lat": @-21.115141,
						   @"long": @55.536384,
						   @"name": @"Réunion"
						   },
					   @{
						   @"lat": @45.943161,
						   @"long": @24.96676,
						   @"name": @"Romania"
						   },
					   @{
						   @"lat": @44.016521,
						   @"long": @21.005859,
						   @"name": @"Serbia"
						   },
					   @{
						   @"lat": @61.52401,
						   @"long": @105.318756,
						   @"name": @"Russia"
						   },
					   @{
						   @"lat": @-1.940278,
						   @"long": @29.873888,
						   @"name": @"Rwanda"
						   },
					   @{
						   @"lat": @23.885942,
						   @"long": @45.079162,
						   @"name": @"Saudi Arabia"
						   },
					   @{
						   @"lat": @-9.64571,
						   @"long": @160.156194,
						   @"name": @"Solomon Islands"
						   },
					   @{
						   @"lat": @-4.679574,
						   @"long": @55.491977,
						   @"name": @"Seychelles"
						   },
					   @{
						   @"lat": @12.862807,
						   @"long": @30.217636,
						   @"name": @"Sudan"
						   },
					   @{
						   @"lat": @60.128161,
						   @"long": @18.643501,
						   @"name": @"Sweden"
						   },
					   @{
						   @"lat": @1.352083,
						   @"long": @103.819836,
						   @"name": @"Singapore"
						   },
					   @{
						   @"lat": @-24.143474,
						   @"long": @-10.030696,
						   @"name": @"Saint Helena"
						   },
					   @{
						   @"lat": @46.151241,
						   @"long": @14.995463,
						   @"name": @"Slovenia"
						   },
					   @{
						   @"lat": @77.553604,
						   @"long": @23.670272,
						   @"name": @"Svalbard and Jan Mayen"
						   },
					   @{
						   @"lat": @48.669026,
						   @"long": @19.699024,
						   @"name": @"Slovakia"
						   },
					   @{
						   @"lat": @8.460555,
						   @"long": @-11.779889,
						   @"name": @"Sierra Leone"
						   },
					   @{
						   @"lat": @43.94236,
						   @"long": @12.457777,
						   @"name": @"San Marino"
						   },
					   @{
						   @"lat": @14.497401,
						   @"long": @-14.452362,
						   @"name": @"Senegal"
						   },
					   @{
						   @"lat": @5.152149,
						   @"long": @46.199616,
						   @"name": @"Somalia"
						   },
					   @{
						   @"lat": @3.919305,
						   @"long": @-56.027783,
						   @"name": @"Suriname"
						   },
					   @{
						   @"lat": @0.18636,
						   @"long": @6.613081,
						   @"name": @"São Tomé and Príncipe"
						   },
					   @{
						   @"lat": @13.794185,
						   @"long": @-88.89653,
						   @"name": @"El Salvador"
						   },
					   @{
						   @"lat": @34.802075,
						   @"long": @38.996815,
						   @"name": @"Syria"
						   },
					   @{
						   @"lat": @-26.522503,
						   @"long": @31.465866,
						   @"name": @"Swaziland"
						   },
					   @{
						   @"lat": @21.694025,
						   @"long": @-71.797928,
						   @"name": @"Turks and Caicos Islands"
						   },
					   @{
						   @"lat": @15.454166,
						   @"long": @18.732207,
						   @"name": @"Chad"
						   },
					   @{
						   @"lat": @-49.280366,
						   @"long": @69.348557,
						   @"name": @"French Southern Territories"
						   },
					   @{
						   @"lat": @8.619543,
						   @"long": @0.824782,
						   @"name": @"Togo"
						   },
					   @{
						   @"lat": @15.870032,
						   @"long": @100.992541,
						   @"name": @"Thailand"
						   },
					   @{
						   @"lat": @38.861034,
						   @"long": @71.276093,
						   @"name": @"Tajikistan"
						   },
					   @{
						   @"lat": @-8.967363,
						   @"long": @-171.855881,
						   @"name": @"Tokelau"
						   },
					   @{
						   @"lat": @-8.874217,
						   @"long": @125.727539,
						   @"name": @"Timor-Leste"
						   },
					   @{
						   @"lat": @38.969719,
						   @"long": @59.556278,
						   @"name": @"Turkmenistan"
						   },
					   @{
						   @"lat": @33.886917,
						   @"long": @9.537499,
						   @"name": @"Tunisia"
						   },
					   @{
						   @"lat": @-21.178986,
						   @"long": @-175.198242,
						   @"name": @"Tonga"
						   },
					   @{
						   @"lat": @38.963745,
						   @"long": @35.243322,
						   @"name": @"Turkey"
						   },
					   @{
						   @"lat": @10.691803,
						   @"long": @-61.222503,
						   @"name": @"Trinidad and Tobago"
						   },
					   @{
						   @"lat": @-7.109535,
						   @"long": @177.64933,
						   @"name": @"Tuvalu"
						   },
					   @{
						   @"lat": @23.69781,
						   @"long": @120.960515,
						   @"name": @"Taiwan"
						   },
					   @{
						   @"lat": @-6.369028,
						   @"long": @34.888822,
						   @"name": @"Tanzania"
						   },
					   @{
						   @"lat": @48.379433,
						   @"long": @31.16558,
						   @"name": @"Ukraine"
						   },
					   @{
						   @"lat": @1.373333,
						   @"long": @32.290275,
						   @"name": @"Uganda"
						   },
					   @{
						   @"lat": @37.09024,
						   @"long": @-95.712891,
						   @"name": @"United States"
						   },
					   @{
						   @"lat": @-32.522779,
						   @"long": @-55.765835,
						   @"name": @"Uruguay"
						   },
					   @{
						   @"lat": @41.377491,
						   @"long": @64.585262,
						   @"name": @"Uzbekistan"
						   },
					   @{
						   @"lat": @41.902916,
						   @"long": @12.453389,
						   @"name": @"Vatican City"
						   },
					   @{
						   @"lat": @12.984305,
						   @"long": @-61.287228,
						   @"name": @"Saint Vincent and the Grenadines"
						   },
					   @{
						   @"lat": @6.42375,
						   @"long": @-66.58973,
						   @"name": @"Venezuela"
						   },
					   @{
						   @"lat": @18.420695,
						   @"long": @-64.639968,
						   @"name": @"British Virgin Islands"
						   },
					   @{
						   @"lat": @18.335765,
						   @"long": @-64.896335,
						   @"name": @"U.S. Virgin Islands"
						   },
					   @{
						   @"lat": @14.058324,
						   @"long": @108.277199,
						   @"name": @"Vietnam"
						   },
					   @{
						   @"lat": @-15.376706,
						   @"long": @166.959158,
						   @"name": @"Vanuatu"
						   },
					   @{
						   @"lat": @-13.768752,
						   @"long": @-177.156097,
						   @"name": @"Wallis and Futuna"
						   },
					   @{
						   @"lat": @-13.759029,
						   @"long": @-172.104629,
						   @"name": @"Samoa"
						   },
					   @{
						   @"lat": @42.602636,
						   @"long": @20.902977,
						   @"name": @"Kosovo"
						   },
					   @{
						   @"lat": @15.552727,
						   @"long": @48.516388,
						   @"name": @"Yemen"
						   },
					   @{
						   @"lat": @-12.8275,
						   @"long": @45.166244,
						   @"name": @"Mayotte"
						   },
					   @{
						   @"lat": @-30.559482,
						   @"long": @22.937506,
						   @"name": @"South Africa"
						   },
					   @{
						   @"lat": @-13.133897,
						   @"long": @27.849332,
						   @"name": @"Zambia"
						   },
					   @{
						   @"lat": @-19.015438,
						   @"long": @29.154857,
						   @"name": @"Zimbabwe"
						   }
					   ];
		a = [a sortedArrayUsingComparator:^NSComparisonResult(NSDictionary* obj1, NSDictionary* obj2) {
			NSString* name1 = [obj1 objectForKey: @"name"];
			NSString* name2 = [obj2 objectForKey: @"name"];
			return [name1 compare: name2];
		}];
		NSMutableArray* array = [NSMutableArray arrayWithArray:a];
		[array insertObject:@{@"lat": @0,@"long": @0,@"name": @"None selected"} atIndex:0];
		countries = [array copy];
	}
	return countries;
}

@end
