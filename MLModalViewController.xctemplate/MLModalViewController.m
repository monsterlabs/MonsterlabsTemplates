//
//  MLModalViewController.m
//  ___PROJECTNAME___
//
//  Created by Juan Germán Castañeda Echevarría.
//  Copyright 2011 Monsterlabs. All rights reserved.
//

#import "MLModalViewController.h"

@implementation MLModalViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (void)dealloc
{
  [super dealloc];
}

- (void)didReceiveMemoryWarning
{
  // Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];

  // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
  [super viewDidLoad];
  if (!overlayScreen) {
    overlayScreen = [[[UIView alloc] initWithFrame:CGRectMake(0, 20, 320, 460)] retain];
    [overlayScreen setOpaque:NO];
    [overlayScreen setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0]];
    overlayScreen.alpha = 0.0;
  }
}

- (void)viewDidUnload
{
  [super viewDidUnload];
}

#pragma mark - Modal Presentation

- (void)presentModalWithOverlay {
  NSUInteger viewHeight = self.view.frame.size.height;

  self.view.frame = CGRectMake(0, 480, self.view.frame.size.width, viewHeight);

  [[[UIApplication sharedApplication] keyWindow] addSubview:overlayScreen];
  [[[UIApplication sharedApplication] keyWindow] addSubview:self.view];

  [UIView animateWithDuration:0.6
                   animations:^{
                     self.view.frame = CGRectMake(0, 480 - viewHeight, self.view.frame.size.width, viewHeight);
                     overlayScreen.alpha = 0.5;
                   }];
}

- (void)dismissModalWithOverlay {
  NSUInteger viewHeight = self.view.frame.size.height;

  [UIView animateWithDuration:0.6
                   animations:^{
                     self.view.frame = CGRectMake(0, 480, self.view.frame.size.width, viewHeight);
                     overlayScreen.alpha = 0.0;
                   }
                   completion:^(BOOL finished){
                     [self.view removeFromSuperview];
                     [overlayScreen removeFromSuperview];
                   }];
}

@end
