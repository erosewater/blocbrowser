//
//  BLCAwesomeFloatingToolbar.m
//  BlocBrowser
//
//  Created by dbk-dev on 12/2/14.
//  Copyright (c) 2014 Bloc. All rights reserved.
//

#import "BLCAwesomeFloatingToolbar.h"

#define kBLCWebBrowserBackString NSLocalizedString(@"Back", @"Back command")
#define kBLCWebBrowserForwardString NSLocalizedString(@"Forward", @"Forward command")
#define kBLCWebBrowserStopString NSLocalizedString(@"Stop", @"Stop command")
#define kBLCWebBrowserRefreshString NSLocalizedString(@"Refresh", @"Reload command")

@interface BLCAwesomeFloatingToolbar ()

@property (nonatomic, strong) NSArray *currentTitles;
@property (nonatomic, strong) NSArray *colors;
@property (nonatomic, strong) NSArray *buttons;
@property (nonatomic, strong) NSMutableArray *rotatedColors;
@property (nonatomic, strong) UIButton *currentButton;
//@property (nonatomic, weak) UILabel *currentLabel;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, strong) UIPinchGestureRecognizer *pinchGesture;
@property (nonatomic, assign) NSUInteger colorCycle;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPress;
@property (nonatomic, assign) CGFloat scale;
//@property (nonatomic, strong) UIScrollView *scrollView;






-(void)pinchFired:(UIPinchGestureRecognizer *)pinchGestureRecognizer;
-(void)longPressFired:(UILongPressGestureRecognizer *)longPressGestureRecognizer;
-(void)buttonPressed:(UIButton *)sender;

@end

@implementation BLCAwesomeFloatingToolbar

- (instancetype) initWithFourTitles:(NSArray *)titles {
    
    self = [super init];
    
    if (self) {
        
        // Save the titles and set the four colors
        self.currentTitles = titles;
        self.colors = @[[UIColor colorWithRed:107/255.0 green:94/255.0 blue:81/255.0 alpha:1],
                        [UIColor colorWithRed:0/255.0 green:82/255.0 blue:194/255.0 alpha:1],
                        [UIColor colorWithRed:217/255.0 green:0/255.0 blue:59/255.0 alpha:1],
                        [UIColor colorWithRed:201/255.0 green:194/255.0 blue:184/255.0 alpha:1]];
        
        NSMutableArray *buttonsArray = [[NSMutableArray alloc] init];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
        
        // Make the 4 labels
        for (NSString *currentTitle in self.currentTitles) {
            UIButton *button = [[UIButton alloc] init];
            button.userInteractionEnabled = NO;
            button.alpha = 0.25;
            
            NSUInteger currentTitleIndex = [self.currentTitles indexOfObject:currentTitle]; // 0 through 3
            NSString *titleForThisButton = [self.currentTitles objectAtIndex:currentTitleIndex];
            UIColor *colorForThisButton = [self.colors objectAtIndex:currentTitleIndex];
            
         //   label.textAlignment = NSTextAlignmentCenter;
            [button setTitle: titleForThisButton forState:UIControlStateNormal];
            
            button.font = [UIFont systemFontOfSize:10];
       //     label.text = titleForThisLabel;
            button.backgroundColor = colorForThisButton;
         //   label.textColor = [UIColor whiteColor];
            
            [buttonsArray addObject:button];
            self.colorCycle = 1;
        }
        
        self.buttons = buttonsArray;
        
        for (UIButton *thisButton in self.buttons) {
            [thisButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:thisButton];
        }
      // self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapFired:)];
       // [self addGestureRecognizer:self.tapGesture];
        
        
       
        
      

        
        self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panFired:)];
        [self addGestureRecognizer:self.panGesture];
        
        self.pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchFired:)];
        [self addGestureRecognizer:self.pinchGesture];
        
        self.longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressFired:)];
        [self addGestureRecognizer:self.longPress];
       
        
        
    }
    
    return self;
}

// Question for Steve - is layoutSubviews a standard method?  I can't see where this is being called otherwise
//does not get called on rotation



#pragma mark Layout


- (void) layoutSubviews {
    
   
    // set the frames for the 4 labels
    
    for (UIButton *thisButton in self.buttons) {
        NSUInteger currentButtonIndex = [self.buttons indexOfObject:thisButton];
        
        
        
        CGFloat labelHeight = CGRectGetHeight(self.bounds) / 2 ;
        CGFloat labelWidth = CGRectGetWidth(self.bounds) / 2  ;
        CGFloat labelX = 0;
        CGFloat labelY = 0;
        
        // adjust labelX and labelY for each label
        if (currentButtonIndex < 2) {
            // 0 or 1, so on top
            labelY = 0;
        } else {
            // 2 or 3, so on bottom
            labelY = CGRectGetHeight(self.frame) / 2;
        }
        
        if (currentButtonIndex % 2 == 0) { // is currentLabelIndex evenly divisible by 2?
            // 0 or 2, so on the left
            labelX = 0;
        } else {
            // 1 or 3, so on the right
            labelX = CGRectGetWidth(self.bounds) / 2;
        }
        
       // if (self.scale > 0) {
        //    self.frame = CGRectMake(labelX, labelY, labelWidth*self.scale, labelHeight*self.scale);
        //} else {
        
        thisButton.frame = CGRectMake(labelX, labelY, labelWidth, labelHeight);
   // }

    }
    }

#pragma mark - Touch Handling

//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
//    return YES;
//}

#pragma mark - Adding these back in for Exercise
- (UIButton *) buttonFromTouches:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    UIView *subview = [self hitTest:location withEvent:event];
    return (UIButton *)subview;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UIButton *button = [self buttonFromTouches:touches withEvent:event];
    self.currentButton = button;
    self.currentButton.alpha = 0.5;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UIButton *button = [self buttonFromTouches:touches withEvent:event];
    
    if (self.currentButton != button) {
        // The label being touched is no longer the initial label
        self.currentButton.alpha = 1;
    } else {
        // The label being touched is the initial label
        self.currentButton.alpha = 0.5;
    }
}


//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
//    UIButton *button = [self buttonFromTouches:touches withEvent:event];
//    
//    if (self.currentButton == button) {
//        NSLog(@"Label tapped: %@", self.currentButton.currentTitle);
//        
//        if ([self.delegate respondsToSelector:@selector(floatingToolbar:didSelectButtonWithTitle:)]) {
//            [self.delegate floatingToolbar:self didSelectButtonWithTitle:button.currentTitle];
//        }
//    }
//    
//    self.currentButton.alpha = 1;
//    self.currentButton = nil;
//}

- (void) buttonPressed:(UIButton *)sender {
    
    NSLog(@"I got here.");
    UIButton *button = sender;
    
        NSLog(@"Label tapped: %@", button.currentTitle);
        
        
          [self.delegate floatingToolbar:self didSelectButtonWithTitle:button.currentTitle];
        }


         
  - (void) tapFired:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        CGPoint location = [sender locationInView:self];
        UIView *tappedView = [self hitTest:location withEvent:nil];
    
      if ([self.buttons containsObject:tappedView]) {
          
      ([self.delegate respondsToSelector:@selector(floatingToolbar:didSelectButtonWithTitle:)]); {
            [self.delegate floatingToolbar:self.currentButton didSelectButtonWithTitle:((NSString *)tappedView)];
            }
        }
    }

}
- (void) panFired:(UIPanGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [recognizer translationInView:self];
        
        NSLog(@"New translation: - I recognize pan %@", NSStringFromCGPoint(translation));
        
       
        
        if ([self.delegate respondsToSelector:@selector(floatingToolbar:didTryToPanWithOffset:)]) {
            [self.delegate floatingToolbar:self didTryToPanWithOffset:translation];
        }
        
        
        [recognizer setTranslation:CGPointZero inView:self];
    }
}
- (void) colorRotation:(NSUInteger *)colorCycle {
    
    // logic, store original color somewhere and retrieve ie later
   
   // NSMutableArray *rotatedColors = [[NSMutableArray alloc]init];
    
    if (self.colorCycle == 2) {
        
        self.rotatedColors = [self.colors mutableCopy];
        NSString *startingColor = self.colors[3];
        
        
        self.rotatedColors[3] = self.rotatedColors[2];
        self.rotatedColors[2] = self.rotatedColors[1];
        self.rotatedColors[1] = self.rotatedColors[0];
        self.rotatedColors[0] = startingColor;

      //  self.colors[0] = self.rotatedColors[0];
//        self.colors[1] = self.rotatedColors[1];
//        self.colors[2] = self.rotatedColors[2];
//        self.colors[3] = self.rotatedColors[3];
//     //   self.colors[0] = self.rotatedColors[0];
        
    
        
        
    } else if (self.colorCycle > 2) {
        
        NSString *startingColor = self.rotatedColors[3];
        
        self.rotatedColors[3] = self.rotatedColors[2];
        self.rotatedColors[2] = self.rotatedColors[1];
        self.rotatedColors[1] = self.rotatedColors[0];
        self.rotatedColors[0] = startingColor;


        
    }
    

  
    NSMutableArray *buttonsArray = [[NSMutableArray alloc] init];
    
    // Make the 4 labels
    for (NSString *currentTitle in self.currentTitles) {
        UIButton *button = [[UIButton alloc] init];
        button.userInteractionEnabled = NO;
        button.alpha = 0.25;
        
        NSUInteger currentTitleIndex = [self.currentTitles indexOfObject:currentTitle]; // 0 through 3
        NSString *titleForThisButton = [self.currentTitles objectAtIndex:currentTitleIndex];
        UIColor *colorForThisButton = [self.rotatedColors objectAtIndex:currentTitleIndex];
//   
//        label.textAlignment = NSTextAlignmentCenter;
        button.font = [UIFont systemFontOfSize:10];
        [button setTitle: titleForThisButton forState:UIControlStateNormal];
   
        button.backgroundColor = colorForThisButton;
       // label.textColor = [UIColor whiteColor];
        
        [buttonsArray addObject:button];
       // self.colorCycle = 1;
    
    
    self.buttons = buttonsArray;
    
    for (UILabel *thisButton in self.buttons) {
        [self addSubview:thisButton];
    }
    
    
    self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapFired:)];
    [self addGestureRecognizer:self.tapGesture];
    
    self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panFired:)];
    [self addGestureRecognizer:self.panGesture];
    
    self.pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchFired:)];
    
    
    
    
    [self addGestureRecognizer:self.pinchGesture];
    
    
    self.longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressFired:)];
    [self addGestureRecognizer:self.longPress];
    
}
    






}


- (void) pinchFired:(UIPinchGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateChanged) {
       NSLog(@"Pinch and Zoom works");
        
        
        
        }
    
    NSLog(@"%f", recognizer.scale);
    CGFloat scale = [recognizer scale];
    
   
if ([self.delegate respondsToSelector:@selector(floatingToolbar:didTryToPinchWithScale:)]) {
    [self.delegate floatingToolbar:self didTryToPinchWithScale:recognizer.scale];
        }
   
    
      /**
        //self.transform = CGAffineTransformScale(self.transform, recognizer.scale, recognizer.scale);
    //recognizer.scale = 1.0;
        //CGRectApplyAffineTransform(self.frame, self.transform);
       **/
    
    

}

-(void) longPressFired:(UILongPressGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        NSLog(@"Do I get here?");
        self.colorCycle ++ ;
        
        [self colorRotation:self.colorCycle];
     
    }
}
    



#pragma mark - Button Enabling

- (void) setEnabled:(BOOL)enabled forButtonWithTitle:(NSString *)title {
    NSUInteger index = [self.currentTitles indexOfObject:title];
    
    if (index != NSNotFound) {
        UIButton *button = [self.buttons objectAtIndex:index];
        button.userInteractionEnabled = enabled;
        button.alpha = enabled ? 1.0 : 0.25;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
