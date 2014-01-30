//
//  RMBienVenta.h
//  Inmovic
//
//  Created by Felipe on 27/01/14.
//  Copyright (c) 2014 Felipe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RMBienVenta : NSObject
//Defino los atributos de un bien a la venta
@property(nonatomic, copy) NSString * partitionKey;
@property(nonatomic, copy) NSString * rowKey;
@property(nonatomic, copy) NSString * tipodebien;
@property(nonatomic, copy) NSString * descripcion;
@property(nonatomic, copy) NSString * ubicacion;
@property(nonatomic, copy) NSString * informaciondecontacto;
@property(nonatomic) float valordeventa;
@property(nonatomic, strong) NSArray * fotos;

//Designado
-(id)initWithDictionary: (NSDictionary *) aDictionary;
@end
