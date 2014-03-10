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

@property (nonatomic) BOOL FuncionaWS;
@property (nonatomic) BOOL existeInmuebleWS; //Esto bool para saber si ya está el inmueble en el WS
@property (nonatomic, copy) NSString * inmuebleId;


-(id)initWithWebService: (NSString *) aUrl;

//Busca un inmueble que esté en el WS
-(void)seachrInmuebleId: (NSString*) aId name:(NSString*) aName;
-(void)searhPuntuacionesWithId: (NSString*) aId;

//Envio datos al WS
-(void)sendPuntuacion : (NSString*) aId puntuacion : (int) aPuntuacion comentario : (NSString*) aComent ;
-(void)sendNewInmueble: (NSString *) aId nombre : (NSString *) aName descripcion : (NSString *) aDescrip;
-(void)servidorAvailable;

-(NSArray *) returnPuntuacionesWS;
-(RMInmuebleWS*) returnInmuebleWS;

@end
