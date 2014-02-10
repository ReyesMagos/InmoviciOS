//
//  RMDestacadosTableViewController.h
//  Inmovic
//
//  Created by Felipe on 27/01/14.
//  Copyright (c) 2014 Felipe. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RMInmobiliariaModel;


#define INMUEBLES_ARRIENDO_SECTION 0
#define BIENES_VENTA_SECTION 1

@interface RMDestacadosTableViewController : UITableViewController <UIActionSheetDelegate>

@property (nonatomic, strong) RMInmobiliariaModel * inmobiliaria;


-(id)initWithInmobiliaria: (RMInmobiliariaModel *) aInmobiliaria
                style:(UITableViewStyle) aStyle;

@end
