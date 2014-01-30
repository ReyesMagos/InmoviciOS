//
//  RMInmuebleArriendo.m
//  Inmovic
//
//  Created by Felipe on 27/01/14.
//  Copyright (c) 2014 Felipe. All rights reserved.
//

#import "RMInmuebleArriendo.h"
#import "AsyncImageView.h"

@interface RMInmuebleArriendo ()



@end

@implementation RMInmuebleArriendo


// Designado
-(id)initWithDictionary: (NSDictionary *) aDictionary{
    
    if (self = [super init]) {
        _partitionKey = [aDictionary objectForKey:@"PartitionKey"];
        _rowKey = [aDictionary objectForKey:@"RowKey"];
        _departamento = [aDictionary objectForKey:@"departamento"];
        _municipio = [aDictionary objectForKey:@"municipio"];
        _tipodeinmueble = [aDictionary objectForKey:@"tipodeinmueble"];
        _tipodebien = [aDictionary objectForKey:@"tipodebien"];
        _usodelbien = [aDictionary objectForKey:@"usodelbien"];
        _nombredelbien = [aDictionary objectForKey:@"nombredelbien"];
        _foliodematriculainmobiliaria = [aDictionary objectForKey:@"foliodematriculainmobiliaria"];
        _areadelterreno = [aDictionary objectForKey:@"areadelterreno"];
        _areaconstruida = [aDictionary objectForKey:@"areaconstruida"];
        _descripcion = [aDictionary objectForKey:@"descripcion"];
        _numerodebanos = [[aDictionary objectForKey:@"numerodebanos"] intValue];
        _numerodehabitaciones = [[aDictionary objectForKey:@"numerodehabitaciones"] intValue];
        _coordenadas = [aDictionary objectForKey:@"coordenadas"];
        _contacto = [aDictionary objectForKey:@"contacto"];
        _puntuaciondelinmueble = [[aDictionary objectForKey:@"puntuaciondelinmueble"] intValue];
        _canondearrendamiento = [[aDictionary objectForKey:@"canondearrendamiento"] intValue];
        _linksfotos = [self captureLinksFromDicctionary:aDictionary];
        _fotos = [[NSMutableArray alloc] init];
        //_portada = [self retornaPrimeraImagen];
        
    }
    return self;
}
//Capturo todos los links de las fotos del inmueble qué están en el diccionario
-(NSArray*)captureLinksFromDicctionary: (NSDictionary *) aDictionary{
    int i = 1;
    NSMutableArray * retorno = [[NSMutableArray alloc]init];
    NSURL * url = [[NSURL alloc]init];
    do {
        NSString * paraDiccionario = [NSString stringWithFormat:@"imagen%d", i];
        NSString* pp = [aDictionary objectForKey:paraDiccionario];
        url = [NSURL URLWithString:pp];
        if (url != nil){
            [retorno addObject:url];
        }
        i++;
    } while (url != nil);
    
    

    return [retorno copy];
}
-(UIImage * ) retornaPrimeraImagen{
    //Cargo la imagen para la portada
    if ([self.linksfotos count] == 0) {
        return [UIImage imageNamed: @"escenariodefecto.png"];
    }
    NSData * datosImagen = [NSData dataWithContentsOfURL: [self.linksfotos objectAtIndex:0]];
    UIImage * lol = [UIImage imageWithData:datosImagen];
    return lol;
}

@end
