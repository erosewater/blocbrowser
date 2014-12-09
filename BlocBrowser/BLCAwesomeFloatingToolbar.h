//
//  BLCAwesomeFloatingToolbar.h
//  BlocBrowser
//
//  Created by dbk-dev on 12/2/14.
//  Copyright (c) 2014 Bloc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BLCAwesomeFloatingToolbar;

@protocol BLCAwesomeFloatingToolbarDelegate <NSObject>

@optional

-(void) floatingToolbar:(BLCAwesomeFloatingToolbar *)toolbar didSelectButtonWithTitle:(NSString *)title;
-(void) floatingToolbar:(BLCAwesomeFloatingToolbar *)toolbar didTryToPanWithOffset:(CGPoint)offset;
-(void) floatingToolbar:(BLCAwesomeFloatingToolbar *)toolbar didTryToPinchWithScale:(CGFloat)scale;
-(void) floatingToolbar:(BLCAwesomeFloatingToolbar *)toolbar didTryToLongPress:(CGPoint)offset;


@end


@interface BLCAwesomeFloatingToolbar : UIView

-(instancetype) initWithFourTitles:(NSArray *)titles;

-(void) setEnabled:(BOOL)enabled forButtonWithTitle:(NSString *)title;


@property (nonatomic, weak) id <BLCAwesomeFloatingToolbarDelegate> delegate;



@end
