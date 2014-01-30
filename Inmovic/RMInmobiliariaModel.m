//
//  RMInmobiliariaModel.m
//  Inmovic
//
//  Created by Felipe on 27/01/14.
//  Copyright (c) 2014 Felipe. All rights reserved.
//

#import "RMInmobiliariaModel.h"
#import "RMInmuebleArriendo.h"
#import "RMMyJSON.h"

#define URL_SET_DATOS_INMUEBLES_ARRIENDO @"http://servicedatosabiertoscolombia.cloudapp.net/v1/Atencion_Reparacion_Integral_Victimas/inmueblesenarriendouariv?$format=json"
#define URL_SET_DATOS_INMUEBLES_ARRIENDO2 @"http://servicedatosabiertoscolombia.cloudapp.net/v1/Atencion_Reparacion_Integral_Victimas/inmueblesenarriendouariv?$filter=nombredelbien eq 'finca villa melisa'&$format=json"

@interface RMInmobiliariaModel ()

@property (nonatomic, strong) NSMutableArray * bienesVenta;
@property (nonatomic, strong) NSMutableArray * inmueblesArriendo;

@end

@implementation RMInmobiliariaModel

-(id)init{
    
    if (self = [super init]) {
        
        //Encargo a la clase elJSON que consuma los datos de los inmuebles del set de datos
        RMMyJSON * elJSON = [[RMMyJSON alloc] initWithContentOfUrlString:URL_SET_DATOS_INMUEBLES_ARRIENDO2];
        
        //Obtengo el arreglo con los datos
        NSArray * inmuebles = elJSON.datos;
        int num = 1;
        if (inmuebles != nil) {
            //Saco todos los inmuebles del array, los creo por el diccionario y los almaceno en el NSMutableArray
            for (NSDictionary *dicc in inmuebles) {
                RMInmuebleArriendo * inmueble = [[RMInmuebleArriendo alloc] initWithDictionary:dicc];
                NSLog(@"%d", num);
                num++;
                if (!self.inmueblesArriendo) {
                    self.inmueblesArriendo = [NSMutableArray arrayWithObject:inmueble];
                }else{
                    [self.inmueblesArriendo addObject: inmueble];
                }
            }
        }else{
            //Se ha producido un error al parsear el JSON
            NSLog(@"Error al parsear el JSON");
        }
    }
    
    return  self;
}

-(RMInmuebleArriendo *) inmuebleArriendoAtIndex: (int) index{
    return  [self.inmueblesArriendo objectAtIndex:index];
}

-(RMBienVenta *) bienVentaAtIndex: (int) index{
    return [self.bienesVenta objectAtIndex:index];
}

#pragma mark - Properties

-(int)inmuebleArriendoCount{
    return [self.inmueblesArriendo count];
}
-(int)bienVentaCount{
    return [self.bienesVenta count];
}

@end
