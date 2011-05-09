//
//  MLModalViewController.h
//  ___PROJECTNAME___
//
//  Created by Juan Germán Castañeda Echevarría.
//  Copyright 2011 Monsterlabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MLModalViewController : UIViewController {
  UIView *overlayScreen;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;
- (void)presentModalWithOverlay;
- (void)dismissModalWithOverlay;
@end