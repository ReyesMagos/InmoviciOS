//
//  RMInmobiliariaModel.h
//  Inmovic
//
//  Created by Felipe on 27/01/14.
//  Copyright (c) 2014 Felipe. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RMBienVenta;
@class RMInmuebleArriendo;

@interface RMInmobiliariaModel : NSObject

@property (nonatomic, readonly) int bienVentaCount;
@property (nonatomic, readonly) int inmuebleArriendoCount;

@property (nonatomic, strong) NSMutableArray * parametrosBusqueda;
@property (nonatomic, strong) NSMutableArray * inDepartamentos;
@property (nonatomic, strong) NSMutableArray * inMunicipios;
@property (nonatomic, strong) NSMutableArray * inTiposdeBienes;
@property (nonatomic, strong) NSMutableArray * inTiposInmuebles;
@property (nonatomic, strong) NSMutableArray * inUsos;
@property (nonatomic, strong) NSMutableArray * inValor;


@property (nonatomic, strong) NSMutableArray * bnTiposdeBienes;
@property (nonatomic, strong) NSMutableArray * bnUbicaciones;
@property (nonatomic, strong) NSMutableArray * bnValor;

+(RMInmobiliariaModel *) sharedManager;

-(RMInmuebleArriendo *) inmuebleArriendoAtIndex: (int) index;
-(RMInmuebleArriendo *) inmuebleAleatorioArriendoAtIndex: (int) index;

-(NSArray *) inmueblesArray;
-(NSArray *) bienesArray;
-(NSArray *) inArriAleatorioArray;

-(void) generateRandomInmueblesInit: (int) ini;
-(RMBienVenta *) bienVentaAtIndex: (int) index;
-(void)consumeBienesVenta;

-(NSArray *) searchMunicipiosWithDepartamento: (NSString*) myDepto;

@end
