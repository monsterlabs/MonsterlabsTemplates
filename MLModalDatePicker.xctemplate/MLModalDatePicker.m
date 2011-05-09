//
//  DatePickerViewController.m
//  TimeOut
//
//  Created by Juan Germán Castañeda Echevarría on 4/24/11.
//  Copyright 2011 UNAM. All rights reserved.
//

#import "DatePickerViewController.h"
#import "Child.h"


@implementation DatePickerViewController

@synthesize date, dateDelegate;

- (id)initWithDate:(NSDate *)aDate {
  self = [super initWithNibName:@"DatePickerViewController" bundle:nil];
  self.date = aDate;
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
    if (date) {
        datePicker.date = date;   
    }
}

- (IBAction)returnDate:(id)sender {
  if (dateDelegate) {
    [dateDelegate datePickerViewControllerDidFinish:self withDate:[datePicker date]];
  }
}

- (IBAction)cancel:(id)sender {
  [self dismissModalWithOverlay];
}

@end
