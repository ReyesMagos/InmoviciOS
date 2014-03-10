//
//  RMPuntuacionWS.m
//  prueba
//
//  Created by Felipe on 1/02/14.
//  Copyright (c) 2014 Felipe. All rights reserved.
//

#import "RMPuntuacionWS.h"

@implementation RMPuntuacionWS

-(id)initWithIdPuntuacion: (int) aId inmuebleWS: (RMInmuebleWS *) aInmuebleWS vlrPuntuacion: (int) aPuntuacion fecha : (NSString *) aFecha comentario : (NSString *) aComent{
    
    if (self = [super init]) {
        _idPuntuacionWS = aId;
        _comentarioWS = aComent;
        _fechaWS = aFecha;
        _valorPuntuacionWS = aPuntuacion;
        _inmuebleWS = aInmuebleWS;
    }
    return self;
}

-(id)initWithInmuebleWS:(RMInmuebleWS *)aInmuebleWS vlrPuntuacion:(int)aPuntuacion comentario:(NSString *)aComent{
    return [self initWithIdPuntuacion:0 inmuebleWS:aInmuebleWS vlrPuntuacion:aPuntuacion fecha:nil comentario:aComent];
}

-(NSString *)getNSStringForComent{
    return [NSString stringWithFormat:@"Puntuación: %d \n\n%@", [self valorPuntuacionWS], [self comentarioWS]];
}

@end
