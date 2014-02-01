//
//  RMTipoBusquedaViewController.h
//  Inmovic
//
//  Created by imaclis on 30/01/14.
//  Copyright (c) 2014 Felipe. All rights reserved.
//

#import <UIKit/UIKit.h>
#define TEXT_ON_LABELCELL_FOR_INMUEBLE @"Inmuebles"
#define TEXT_ON_LABELCELL_FOR_aBIEN @"Bienes en venta"

@class RMInmuebleArriendo;
@class RMBienVenta;

@interface RMTipoBusquedaViewController : UITableViewController

-(id)initWithInmueble: (NSArray *) aInmueble style:(UITableViewStyle) aStyle;

-(id)initWithBien: (NSArray *) aBien style:(UITableViewStyle) aStyle;

-(id)initWithArray: (NSArray *) aArray style:(UITableViewStyle) aStyle;

@end
