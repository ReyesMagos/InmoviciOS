//
//  RMInmuebleWS.h
//  prueba
//
//  Created by Felipe on 2/02/14.
//  Copyright (c) 2014 Felipe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RMInmuebleWS : NSObject

@property (nonatomic, copy ) NSString * idInmueble;
@property (nonatomic, copy ) NSString * nombre;
@property (nonatomic, copy ) NSString * descripcion;
@property (nonatomic)  int puntuacionPromedio;

-(id)initWithId: aID name: (NSString *) aName descripcion : (NSString *) aDescripcion puntuacionProm : (int) aProm;

@end
