//
//  RMBusquedaInmuebleViewController.h
//  Inmovic
//
//  Created by imaclis on 30/01/14.
//  Copyright (c) 2014 Felipe. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RMBusquedaInmuebleViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>


- (IBAction)searchInmueble:(id)sender;

@property (weak, nonatomic) IBOutlet UITableView *parametrosTView;

-(id)initWithCase: (int) aCase;

@end
