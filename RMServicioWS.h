//
//  RMServicioWS.h
//  Inmovic
//
//  Created by Felipe on 2/02/14.
//  Copyright (c) 2014 Felipe. All rights reserved.
//

#import <Foundation/Foundation.h>
#define CONSUMI_PUNTUACIONES @"PuntuacionesConsumidas"
#define ENVIE_PUNTUACION @"EnviadaPuntuacion"
#define ERROR_ENVAR_PUNTUACION @"ErrorEnvioPuntuacion"

@class RMInmuebleWS;


@interface RMServicioWS : NSObject

-(id)initWithWebService: (NSString *) aUrl;

//Busca un inmueble que esté en el WS
-(void)seachrInmuebleId: (NSString*) aId name:(NSString*) aName;
-(void)searhPuntuacionesWithId: (NSString*) aId;

//Envio datos al WS
-(void)sendPuntuacion : (NSString*) aId puntuacion : (int) aPuntuacion comentario : (NSString*) aComent ;

-(NSArray *) returnPuntuacionesWS;
-(RMInmuebleWS*) returnInmuebleWS;

@end
