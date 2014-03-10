//
//  RMPuntuacionWS.h
//  prueba
//
//  Created by Felipe on 1/02/14.
//  Copyright (c) 2014 Felipe. All rights reserved.
//

#import <Foundation/Foundation.h>
@class RMInmuebleWS;

@interface RMPuntuacionWS : NSObject

@property (nonatomic) int idPuntuacionWS;
@property (nonatomic, copy) NSString * comentarioWS;
@property (nonatomic, strong) NSString * fechaWS;
@property (nonatomic) int valorPuntuacionWS;
@property (nonatomic, strong) RMInmuebleWS *inmuebleWS;

-(id)initWithIdPuntuacion: (int) aId inmuebleWS: (RMInmuebleWS *) aInmuebleWS vlrPuntuacion: (int) aPuntuacion fecha : (NSString *) aFecha comentario : (NSString *) aComent;

-(id)initWithInmuebleWS: (RMInmuebleWS *) aInmuebleWS vlrPuntuacion: (int) aPuntuacion comentario : (NSString *) aComent;

-(NSString *) getNSStringForComent;

@end
