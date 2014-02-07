//
//  RMInmuebleWS.m
//  prueba
//
//  Created by Felipe on 2/02/14.
//  Copyright (c) 2014 Felipe. All rights reserved.
//

#import "RMInmuebleWS.h"

@implementation RMInmuebleWS

-(id)initWithId:(id)aID name:(NSString *)aName descripcion:(NSString *)aDescripcion puntuacionProm:(int)aProm{
    if (self = [super init]) {
        _idInmueble = aID;
        _descripcion = aDescripcion;
        _nombre = aName;
        _puntuacionPromedio = aProm;
    }
    return self;
}

@end
