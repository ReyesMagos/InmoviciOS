//
//  RMInmuebleArriendoViewController.h
//  Inmovic
//
//  Created by Felipe on 27/01/14.
//  Copyright (c) 2014 Felipe. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RMInmuebleArriendo;

@interface RMInmuebleArriendoViewController : UIViewController <UIScrollViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) RMInmuebleArriendo *inmuebleArriendo;

// Propiedades del view
@property (strong, nonatomic) IBOutlet UIScrollView *splitFotos;
@property (strong, nonatomic) IBOutlet UITextView *descripcionTxtV;

//Botones del view
- (IBAction)mapaBtn:(id)sender;
- (IBAction)formularioBtn:(id)sender;


-(id)initWithInmueble:(RMInmuebleArriendo *) aInmueble;

@end
