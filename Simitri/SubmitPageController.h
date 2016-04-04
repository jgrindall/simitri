//
//  SubmitPageController.h
//  Simitri
//
//  Created by John on 11/06/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubmitPageController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>

- (NSDictionary*) getData;
- (void) warn;
- (void) disableAll;
- (void) enableAll;
@end
