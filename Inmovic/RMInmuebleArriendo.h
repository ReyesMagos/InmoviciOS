//
//  RMInmuebleArriendo.h
//  Inmovic
//
//  Created by Felipe on 27/01/14.
//  Copyright (c) 2014 Felipe. All rights reserved.
//

#import <Foundation/Foundation.h>
#define TITLES_OF_ATTRIBUTES @[@"Nombre", @"Departamento", @"Municipio", @"Número de baños", @"Número de habitaciones", @"Canon de arrendamiento"]

@class AsyncImageView;

@interface RMInmuebleArriendo : NSObject

//Defino los atributos de un inmueble en arriendo
@property(nonatomic, copy) NSString * partitionKey;
@property(nonatomic, copy) NSString * rowKey;
@property(nonatomic, copy) NSString * departamento;
@property(nonatomic, copy) NSString * municipio;
@property(nonatomic, copy) NSString * tipodeinmueble;
@property(nonatomic, copy) NSString * tipodebien;
@property(nonatomic, copy) NSString * usodelbien;
@property(nonatomic, copy) NSString * nombredelbien;
@property(nonatomic, copy) NSString * foliodematriculainmobiliaria;
@property(nonatomic, copy) NSString * areadelterreno;
@property(nonatomic, copy) NSString * areaconstruida;
@property(nonatomic, copy) NSString * descripcion;
@property(nonatomic) int numerodebanos;
@property(nonatomic) int numerodehabitaciones;
@property(nonatomic, copy) NSString* coordenadas;
@property(nonatomic, copy) NSString * contacto;
@property(nonatomic) int puntuaciondelinmueble;
@property(nonatomic) int canondearrendamiento;

@property(nonatomic, strong) NSArray * linksfotos;
@property(nonatomic, strong) NSMutableArray * fotos;
@property(nonatomic, strong) NSArray * atributos;
@property (nonatomic, strong) AsyncImageView * portadaV;

// Designado para diccionario
-(id)initWithDictionary: (NSDictionary *) aDictionary;

-(BOOL)isInmuebleByArray: (NSArray * ) aArray;
-(void)consumeFirstImage;

@end
