//
//  RMComboBox.h
//  Inmovic
//
//  Created by imaclis on 30/01/14.
//  Copyright (c) 2014 Felipe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIResponder.h>

@protocol RMComboBoxDelegate;

@interface RMComboBox : UIView <UIPickerViewDelegate, UIPickerViewDataSource>
{
    BOOL active;
}

@property (nonatomic, strong) NSArray *values;
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) NSString *currentValue;
@property (nonatomic, strong) id<RMComboBoxDelegate> delegate;

@property (readwrite, strong) UIView *inputView;
@property (readwrite, strong) UIView *inputAccessoryView;

@end

@protocol RMComboBoxDelegate <NSObject>
@optional
- (void) comboboxOpened:(RMComboBox *)combobox;
- (void) comboboxChanged:(RMComboBox *)combobox toValue:(NSString *)toValue;
@end
