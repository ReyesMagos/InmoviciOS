//
//  RMInmuebleArriendoViewController.h
//  Inmovic
//
//  Created by Felipe on 27/01/14.
//  Copyright (c) 2014 Felipe. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RMInmuebleArriendo;

@interface RMInmuebleArriendoViewController : UIViewController <UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) RMInmuebleArriendo *inmuebleArriendo;

// Propiedades del view
@property (strong, nonatomic) IBOutlet UIScrollView *splitFotos;
@property (strong, nonatomic) IBOutlet UITextView *descripcionTxtV;
@property (weak, nonatomic) IBOutlet UIButton *btnMapa;
@property (weak, nonatomic) IBOutlet UIScrollView *splitInfo;

//Botones del view
- (IBAction)mapaBtn:(id)sender;
- (IBAction)formularioBtn:(id)sender;
- (IBAction)puntuacionesBtn:(id)sender;
- (IBAction)compartirBtn:(id)sender;


-(id)initWithInmueble:(RMInmuebleArriendo *) aInmueble;

@end
