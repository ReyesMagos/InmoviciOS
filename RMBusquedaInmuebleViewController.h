//
//  RMBusquedaInmuebleViewController.h
//  Inmovic
//
//  Created by imaclis on 30/01/14.
//  Copyright (c) 2014 Felipe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iOSCombobox.h"


@interface RMBusquedaInmuebleViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIScrollViewDelegate, iOSComboboxDelegate>


- (IBAction)searchInmueble:(id)sender;

@property (weak, nonatomic) IBOutlet UITableView *parametrosTView;
@property (weak, nonatomic) IBOutlet UILabel *tituloLB;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollViews;


-(id)initWithCase: (int) aCase;

@end
