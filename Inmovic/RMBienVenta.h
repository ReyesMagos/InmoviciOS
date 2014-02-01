//
//  RMBienVenta.h
//  Inmovic
//
//  Created by Felipe on 27/01/14.
//  Copyright (c) 2014 Felipe. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AsyncImageView;

#define TITLE_OF_ATTRIBUTES @[@"Tipo del Bien", @"Ubicación", @"Info Contacto", @"Valor"]

@interface RMBienVenta : NSObject
//Defino los atributos de un bien a la venta
@property(nonatomic, copy) NSString * partitionKey;
@property(nonatomic, copy) NSString * rowKey;
@property(nonatomic, copy) NSString * tipodebien;
@property(nonatomic, copy) NSString * descripcion;
@property(nonatomic, copy) NSString * ubicacion;
@property(nonatomic, copy) NSString * informaciondecontacto;
@property(nonatomic) int valordeventa;
@property(nonatomic, strong) NSArray * linksfotos;
@property(nonatomic, strong) NSMutableArray * fotos;
@property(nonatomic, strong) NSArray * atributos;
@property (nonatomic, strong) AsyncImageView * portadaV;


//Designado
-(id)initWithDictionary: (NSDictionary *) aDictionary;

-(BOOL)isABienByArray: (NSArray * ) aArray;
-(void)consumeFirstImage;

@end
