//
//  RMServicioWS.m
//  Inmovic
//
//  Created by Felipe on 2/02/14.
//  Copyright (c) 2014 Felipe. All rights reserved.
//

#import "RMServicioWS.h"
#import "RMInmuebleWS.h"
#import "RMPuntuacionWS.h"
#import "RMSoap.h"

@interface RMServicioWS()

@property (nonatomic, strong) RMSoap * theSoap;
@property (nonatomic, strong) NSArray * puntuaciones;
@property (nonatomic, strong) RMInmuebleWS * inmuebleActual;


@end


@implementation RMServicioWS

-(id)initWithWebService:(NSString *)aUrl{
    if (self = [super init]) {
        _theSoap = [[RMSoap alloc]initWithNSString:aUrl];
        //[self servidorAvailable];
    }
    return self;
}

-(void)seachrInmuebleId:(NSString *)aId name:(NSString *)aName{
    NSString * slc = NSStringFromSelector(@selector(createRMInmueble:etiquetas:));
    NSString * method = @"ConsultarInmueble";
    NSArray * params = @[@"id", aId, @"nombre", aName];
    [self soapRequesWithParams:params method:method elSelector:slc];
}
-(void)searhPuntuacionesWithId:(NSString *)aId{
    NSString * slc = NSStringFromSelector(@selector(createRMPuntuaciones:etiquetasPuntaciones:));
    NSString * method = @"ConsultarPuntuacion";
    NSArray * params = @[@"idInmueble", aId];
    [self soapRequesWithParams:params method:method elSelector:slc];
}

-(void)sendPuntuacion:(NSString *)aId puntuacion:(int)aPuntuacion comentario:(NSString *)aComent{
    NSString * slc = NSStringFromSelector(@selector(responseEnviarPuntuacion:etiquetas:));
    NSString * method = @"CrearPuntuacion";
    NSArray * params = @[@"idInmueble", aId, @"puntuacion", [NSString stringWithFormat:@"%d", aPuntuacion], @"comentario", aComent];
    [self soapRequesWithParams:params method:method elSelector:slc];
    
}

-(void)servidorAvailable{
    NSString * slc = NSStringFromSelector(@selector(responseAvailable:etiquetasPuntaciones:));
    NSString * method = @"ConsultarInmueble";
    NSArray * params = @[@"idInmueble", @"id", @"puntuacion", @"punt"];
    [self soapRequesWithParams:params method:method elSelector:slc];
}

-(void)sendNewInmueble:(NSString *)aId nombre:(NSString *)aName descripcion:(NSString *)aDescrip{
    NSString * slc = NSStringFromSelector(@selector(createRMInmueble:etiquetas:));
    NSString * method = @"CrearInmueble";
    NSArray * params = @[@"id", aId, @"nombre", aName, @"descripcion", aDescrip, @"puntuacionPromedio", @0];
    [self soapRequesWithParams:params method:method elSelector:slc];
}


//Método que realiza una petición POST segun el método que se ingrese
-(void)soapRequesWithParams: (NSArray *) aParams method : (NSString *) aMethod elSelector : (NSString*) aSelector{
    
    SEL slct = NSSelectorFromString(aSelector);
    //SEL slct = @selector(createRMInmueble:etiquetas:);
    NSMethodSignature *theSignature = [self methodSignatureForSelector:slct];
    NSInvocation *anInvocation = [NSInvocation invocationWithMethodSignature:theSignature];
    [anInvocation setSelector:slct];
    [anInvocation setTarget:self];
    
    [self.theSoap executeWebMethod:aMethod :aParams :anInvocation];
    
}
-(void)responseEnviarPuntuacion: (NSArray *) aRequest etiquetas : (NSMutableArray *) aEtiqueta{
    if (aRequest && [aRequest count] != 0) {
        [self searhPuntuacionesWithId:self.inmuebleId];
        NSNotification * noti = [NSNotification notificationWithName:ENVIE_PUNTUACION object:nil
                                                            userInfo:@{@"response": @"Enviada correctamente"}];
        [[NSNotificationCenter defaultCenter] postNotification:noti];
        
    }else{
        NSNotification * noti = [NSNotification notificationWithName:ENVIE_PUNTUACION object:nil
                                                            userInfo:@{@"response": @"Error al enviar"}];
        [[NSNotificationCenter defaultCenter] postNotification:noti];
    }
}

//Método que crea los objetos RMPuntuaciones de las puntuaciones consumidas del WS
//El parametro estiqueta contiene el nombre del registro asociado a cada atributo de la puntuacion en el WS
-(void)createRMPuntuaciones: (NSArray *) puntuacionesConsumidas etiquetasPuntaciones : (NSArray *) aEtiqueta{
    //Si el response retorno nulo, o no retorno nada
    if (!puntuacionesConsumidas || [puntuacionesConsumidas count] == 0 || [[puntuacionesConsumidas objectAtIndex:0] isEqualToString:@""]) {
        self.puntuaciones = @[]; //Array vacio
    }else{
        self.existeInmuebleWS = YES;
        NSMutableArray * comentarios = [[NSMutableArray alloc]init];
        for (int i=0; i < [puntuacionesConsumidas count]; i++) {
            
            RMPuntuacionWS * puntWS = [[RMPuntuacionWS alloc]initWithIdPuntuacion: [[puntuacionesConsumidas objectAtIndex:i] intValue] inmuebleWS:[puntuacionesConsumidas objectAtIndex:i+1] vlrPuntuacion:[[puntuacionesConsumidas objectAtIndex:i+2] intValue] fecha:[puntuacionesConsumidas objectAtIndex:i+3] comentario:[puntuacionesConsumidas objectAtIndex:i+4]];
            i = i+4;
            [comentarios addObject:puntWS];
            
        }
        self.puntuaciones = [comentarios copy];
    }

    //Creo una notificación informando que terminé de crear las puntuacionesWS
    NSNotification * noti = [NSNotification notificationWithName:CONSUMI_PUNTUACIONES object:self];
    [[NSNotificationCenter defaultCenter] postNotification:noti];
}

//Método que crea los objetos RMInmueble del inmueble consumido del WS
//El parametro estiqueta contiene el nobmre del registro asociado a cada atributo del inmueble en el WS
-(void)createRMInmueble: (NSMutableArray *) inmuebleConsumido etiquetas : (NSMutableArray *) aEtiqueta{
    
    if (!inmuebleConsumido || [inmuebleConsumido count] == 0) {
        self.existeInmuebleWS = NO;
        return;
    }
    
    int i = 0;
    
    RMInmuebleWS * puntWS = [[RMInmuebleWS alloc]initWithId: [inmuebleConsumido objectAtIndex:i] name:[inmuebleConsumido objectAtIndex:i+1] descripcion:[inmuebleConsumido objectAtIndex:i+2] puntuacionProm:[[inmuebleConsumido objectAtIndex:i+3]intValue]];
    i = i+3;
    
    self.inmuebleActual = puntWS;
    self.existeInmuebleWS = YES;
}

//Metodo para ver si hubo respuesta en el servidor;
-(void)responseAvailable: (NSArray *) puntuacionesConsumidas etiquetasPuntaciones : (NSArray *) aEtiqueta{
    if ([[puntuacionesConsumidas objectAtIndex:0] isEqualToString:@""]) {
        self.FuncionaWS = NO;
    }else{
        self.FuncionaWS = YES;
    }
}


-(RMInmuebleWS *)returnInmuebleWS{
    return self.inmuebleActual;
}

-(NSArray *)returnPuntuacionesWS{
    return self.puntuaciones;
}

@end
