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

@property (nonatomic, strong) NSMutableArray*  atributosEnArray;

@end

@implementation RMInmuebleArriendo


// Designado
-(id)initWithDictionary: (NSDictionary *) aDictionary{
    
    if (self = [super init]) {
        _partitionKey = [aDictionary objectForKey:@"PartitionKey"];
        _rowKey = [aDictionary objectForKey:@"RowKey"];
        _departamento = [self completeIfIsNilNSString:[aDictionary objectForKey:@"departamento"]];
        _municipio = [self completeIfIsNilNSString:[aDictionary objectForKey:@"municipio"]];
        _tipodeinmueble = [self completeIfIsNilNSString:[aDictionary objectForKey:@"tipodeinmueble"]];
        _tipodebien = [self completeIfIsNilNSString:[aDictionary objectForKey:@"tipodebien"]];
        _usodelbien = [self completeIfIsNilNSString:[aDictionary objectForKey:@"usodelbien"]];
        _nombredelbien = [self completeIfIsNilNSString:[aDictionary objectForKey:@"nombredelbien"]];
        _foliodematriculainmobiliaria = [self completeIfIsNilNSString:[aDictionary objectForKey:@"foliodematriculainmobiliaria"]];
        _areadelterreno = [self completeIfIsNilNSString:[aDictionary objectForKey:@"areadelterreno"]];
        _areaconstruida = [self completeIfIsNilNSString:[aDictionary objectForKey:@"areaconstruida"]];
        _descripcion = [self completeIfIsNilNSString:[aDictionary objectForKey:@"descripcion"]];
        _numerodebanos = [[aDictionary objectForKey:@"numerodebanos"] intValue];
        _numerodehabitaciones = [[aDictionary objectForKey:@"numerodehabitaciones"] intValue];
        _coordenadas = [self completeIfIsNilNSString:[aDictionary objectForKey:@"coordenadas"]];
        _contacto = [self completeIfIsNilNSString:[aDictionary objectForKey:@"contacto"]];
        _puntuaciondelinmueble = [[aDictionary objectForKey:@"puntuaciondelinmueble"] intValue];
        _canondearrendamiento = [[aDictionary objectForKey:@"canondearrendamiento"] intValue];
        _linksfotos = [self captureLinksFromDicctionary:aDictionary];
        _fotos = [[NSMutableArray alloc] init];
        _atributosEnArray = [[NSMutableArray alloc] init];
        //_portadaV = [self retornaPrimeraImagen];
        
        
        //Asigno los atributos que me interesan para búsquedas futuras
        [_atributosEnArray addObject:[aDictionary objectForKey:@"departamento"]];
        [_atributosEnArray addObject:[aDictionary objectForKey:@"municipio"]];
        [_atributosEnArray addObject:[aDictionary objectForKey:@"tipodeinmueble"]];
        [_atributosEnArray addObject:[aDictionary objectForKey:@"tipodebien"]];
        [_atributosEnArray addObject:[aDictionary objectForKey:@"usodelbien"]];
        [_atributosEnArray addObject:[aDictionary objectForKey:@"nombredelbien"]];
        [_atributosEnArray addObject:[aDictionary objectForKey:@"numerodebanos"]];
        [_atributosEnArray addObject:[aDictionary objectForKey:@"numerodehabitaciones"]];
        [_atributosEnArray addObject:[aDictionary objectForKey:@"canondearrendamiento"]];
        [_atributosEnArray addObject:[aDictionary objectForKey:@"contacto"]];
        [_atributosEnArray addObject:[aDictionary objectForKey:@"foliodematriculainmobiliaria"]];
        [_atributosEnArray addObject:[aDictionary objectForKey:@"areaconstruida"]];
        
        
        _atributos = TITLES_OF_ATTRIBUTES;
       
    }
    return self;
}
-(NSString*)completeIfIsNilNSString: (NSString*)aString{
    if ([aString isEqualToString:@""]) {
        return SIN_INFORMACION;
    }
    return aString;
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
        if (url != nil && ![pp isEqualToString:@""]){
            [retorno addObject:url];
        }
        i++;
    } while (url != nil);
    
    return [retorno copy];
}

-(AsyncImageView * ) retornaPrimeraImagen{
    AsyncImageView *imageView = [[AsyncImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 44.0f, 44.0f)];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    //[[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:imageView];
    //Cargo la imagen para la portada
    if ([self.linksfotos count] == 0) {
        imageView.image = [UIImage imageNamed: @"logouariv.png"];
        //return [UIImage imageNamed: @"escenariodefecto.png"];
    }else{
        
        imageView.imageURL = [self.linksfotos objectAtIndex:0];
    }
    //NSData * datosImagen = [NSData dataWithContentsOfURL: [self.linksfotos objectAtIndex:0]];
    //UIImage * lol = [UIImage imageWithData:datosImagen];
    //return lol;
    return imageView;
}

-(void)consumeFirstImage{
    AsyncImageView *imageView = [[AsyncImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    
    //Cargo la imagen para la portada
    if ([self.linksfotos count] == 0) {
        imageView.image = [UIImage imageNamed: @"logouariv.png"];
        //return [UIImage imageNamed: @"escenariodefecto.png"];
    }else{
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:imageView];
        imageView.imageURL = [self.linksfotos objectAtIndex:0];
    }
    self.portadaV = imageView;
}


//Método que dice si este inmueble coincide con los párametros en el aArray
-(BOOL)isInmuebleByArray:(NSArray *)aArray{
    BOOL existe = YES;
    for (NSString* txt in aArray) {
        if (![self.atributosEnArray containsObject:txt]) {
            existe = NO;
            break;
        }
    }
    return existe;
}

@end
