//
//  RMInmuebleArriendoViewController.h
//  Inmovic
//
//  Created by Felipe on 27/01/14.
//  Copyright (c) 2014 Felipe. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RMInmuebleArriendo;

@interface RMInmuebleArriendoViewController : UIViewController <UIScrollViewDelegate>

@property (nonatomic, strong) RMInmuebleArriendo *inmuebleArriendo;

// Propiedades del view
@property (strong, nonatomic) IBOutlet UIScrollView *splitFotos;
@property (strong, nonatomic) IBOutlet UILabel *nombreLB;
@property (strong, nonatomic) IBOutlet UILabel *deptoLB;
@property (strong, nonatomic) IBOutlet UILabel *municipioLB;
@property (strong, nonatomic) IBOutlet UILabel *nroBanosLB;
@property (strong, nonatomic) IBOutlet UILabel *nroPiezasLB;
@property (strong, nonatomic) IBOutlet UILabel *canonArLB;
@property (strong, nonatomic) IBOutlet UILabel *telefonoLB;
@property (strong, nonatomic) IBOutlet UITextView *descripcionTxtV;

//Botones del view
- (IBAction)mapaBtn:(id)sender;
- (IBAction)formularioBtn:(id)sender;


-(id)initWithInmueble:(RMInmuebleArriendo *) aInmueble;

@end
