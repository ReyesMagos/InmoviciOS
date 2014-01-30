//
//  RMInmobiliariaModel.h
//  Inmovic
//
//  Created by Felipe on 27/01/14.
//  Copyright (c) 2014 Felipe. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RMBienVenta;
@class RMInmuebleArriendo;

@interface RMInmobiliariaModel : NSObject

@property (nonatomic, readonly) int bienVentaCount;
@property (nonatomic, readonly) int inmuebleArriendoCount;

-(RMInmuebleArriendo *) inmuebleArriendoAtIndex: (int) index;
-(RMBienVenta *) bienVentaAtIndex: (int) index;

@end
