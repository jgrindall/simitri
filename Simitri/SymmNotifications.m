//
//  SymmNotifications.m
//  Symmetry
//
//  Created by John on 19/05/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "SymmNotifications.h"

@implementation SymmNotifications

NSString* const SYMM_NOTIF_ENABLE_UNDO = @"Symm::enableUndo";
NSString* const SYMM_NOTIF_ENABLE_REDO = @"Symm::enableRedo";
NSString* const SYMM_NOTIF_PERFORM_UNDO = @"Symm::performUndo";
NSString* const SYMM_NOTIF_PERFORM_REDO = @"Symm::performRedo";
NSString* const SYMM_NOTIF_PERFORM_INFO = @"Symm::performInfo";
NSString* const SYMM_NOTIF_PERFORM_SHARE = @"Symm::performShare";
NSString* const SYMM_NOTIF_CHANGE_COLOR = @"Symm::changeColor";
NSString* const SYMM_NOTIF_PERFORM_SAVE = @"Symm::performSave";
NSString* const SYMM_NOTIF_PERFORM_CLR = @"Symm::performClr";
NSString* const SYMM_NOTIF_FILE_CHANGED = @"Symm::fileChanged";
NSString* const SYMM_NOTIF_CHANGE_WIDTH = @"Symm::changeWidth";
NSString* const SYMM_NOTIF_START_NEW_FILE = @"Symm::startNewFile";
NSString* const SYMM_NOTIF_DELETE_FILE = @"Symm::delFile";
NSString* const SYMM_NOTIF_OPEN_FILE = @"Symm::openFile";
NSString* const SYMM_NOTIF_BG_CHANGE_COLOR = @"Symm::bgChangeColor";
NSString* const SYMM_NOTIF_SET_BG = @"Symm::bgsetBg";
NSString* const SYMM_NOTIF_HIDE_POPUP = @"Symm:hidePopup";
NSString* const SYMM_NOTIF_FILE_SAVE_SUCCESS = @"Symm:fileSaveSuccess";
NSString* const SYMM_NOTIF_CURRENT_SAVE = @"Symm:currentSave";
NSString* const SYMM_NOTIF_CURRENT_SKIP = @"Symm:currentSkip";
NSString* const SYMM_NOTIF_CURRENT_FILE_CHANGE = @"Symm:currentFileChanged";
NSString* const SYMM_NOTIF_FACEBOOK = @"Symm:facebook";
NSString* const SYMM_NOTIF_TWITTER = @"Symm:twitter";
NSString* const SYMM_NOTIF_CAMERA = @"Symm:camera";
NSString* const SYMM_NOTIF_GALLERY = @"Symm:gallery";
NSString* const SYMM_NOTIF_ACCEPT_TERMS = @"Symm:acceptTerms";
NSString* const SYMM_NOTIF_WILL_ROTATE = @"Symm:willRotate";
NSString* const SYMM_NOTIF_DID_ROTATE = @"Symm:didRotate";
NSString* const SYMM_NOTIF_SHOW_SPINNER = @"Symm:showSpinner";
NSString* const SYMM_NOTIF_HIDE_SPINNER = @"Symm:hideSpinner";
NSString* const SYMM_NOTIF_ALERT = @"Symm:alert";
NSString* const SYMM_NOTIF_SHOW_TPL_INFO = @"Symm:showTplInfo";
NSString* const SYMM_NOTIF_STOP_ANIM = @"Symm:stopAnim";
NSString* const SYMM_NOTIF_PREV_YES = @"Symm:prevYes";
NSString* const SYMM_NOTIF_PREV_NO = @"Symm:prevNo";
NSString* const SYMM_NOTIF_MEMORY = @"Symm:memory";
NSString* const SYMM_NOTIF_CLOSE_EXAMPLE = @"Symm:closeExample";
NSString* const SYMM_NOTIF_CLOSE_HELP = @"Symm:closeHelp";
NSString* const SYMM_NOTIF_EXAMPLE_SWIPE_RIGHT = @"Symm:exRight";
NSString* const SYMM_NOTIF_EXAMPLE_SWIPE_LEFT = @"Symm:exLeft";
@end
