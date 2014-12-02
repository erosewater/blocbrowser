//
//  BLCWebBrowserViewController.h
//  BlocBrowser
//
//  Created by dbk-dev on 12/1/14.
//  Copyright (c) 2014 Bloc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BLCWebBrowserViewController : UIViewController

/**
 
 Replaces the webview with a fresh one, erasing all history.  Also updates the URL field and toolbar buttons appropriately 
 */

-(void) resetWebView;




@end
