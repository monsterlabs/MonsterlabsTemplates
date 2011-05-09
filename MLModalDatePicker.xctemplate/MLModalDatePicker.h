//
//  DatePickerViewController.h
//  TimeOut
//
//  Created by Juan Germán Castañeda Echevarría on 4/24/11.
//  Copyright 2011 UNAM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLModalViewController.h"

@class Child;

@protocol DatePickerViewControllerDelegate;

@interface DatePickerViewController : MLModalViewController {
    IBOutlet UIDatePicker *datePicker;
    IBOutlet UINavigationItem *title;
    id<DatePickerViewControllerDelegate> dateDelegate;
    NSDate *date;
}

@property (nonatomic, readwrite, retain) NSDate *date;
@property (nonatomic, readwrite, assign) id<DatePickerViewControllerDelegate> dateDelegate;

- (id)initWithDate:(NSDate *)date;
- (IBAction)returnDate:(id)sender;
- (IBAction)cancel:(id)sender;

@end

@protocol DatePickerViewControllerDelegate
- (void)datePickerViewControllerDidFinish:(DatePickerViewController *)controller
                                 withDate:(NSDate *)date;
@end