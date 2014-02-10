//
//  RMInmobiliariaModel.m
//  Inmovic
//
//  Created by Felipe on 27/01/14.
//  Copyright (c) 2014 Felipe. All rights reserved.
//

#import "RMInmobiliariaModel.h"
#import "RMInmuebleArriendo.h"
#import "RMBienVenta.h"
#import "RMMyJSON.h"
#import "Reachability.h"

#define URL_SET_DATOS_INMUEBLES_ARRIENDO @"http://servicedatosabiertoscolombia.cloudapp.net/v1/Atencion_Reparacion_Integral_Victimas/inmueblesenarriendouariv?$format=json"
#define URL_SET_DATOS_INMUEBLES_ARRIENDO2 @"http://servicedatosabiertoscolombia.cloudapp.net/v1/Atencion_Reparacion_Integral_Victimas/inmueblesenarriendouariv?$filter=nombredelbien eq 'finca villa melisa'&$format=json"
#define URL_SET_DATOS_BIENES_VENTA @"http://servicedatosabiertoscolombia.cloudapp.net/v1/Atencion_Reparacion_Integral_Victimas/bienesalaventauariv?$format=json"

@interface RMInmobiliariaModel ()

@property (nonatomic, strong) NSMutableArray * bienesVenta;
@property (nonatomic, strong) NSMutableArray * inmueblesArriendo;

@property (nonatomic, strong) NSMutableArray * inmuArriendoAleatorio;

@end

@implementation RMInmobiliariaModel

+(RMInmobiliariaModel *)sharedManager{
    static RMInmobiliariaModel * shareMyManager = nil;
    if (!shareMyManager) {
        shareMyManager = [[self alloc]init];
    }
    return shareMyManager;
}

-(id)init{
    
    if (self = [super init]) {
        
        //Si no hay conexión retorne
        if (![[Reachability reachabilityWithHostname:@"www.google.com"] isReachable]) {
            return self;
        }
        //Encargo a la clase elJSON que consuma los datos de los inmuebles del set de datos
        RMMyJSON * elJSON = [[RMMyJSON alloc] initWithContentOfUrlString:URL_SET_DATOS_INMUEBLES_ARRIENDO];
        
        //Inicializo las categorias
        _inDepartamentos = [[NSMutableArray alloc] init];
        _inMunicipios	 = [[NSMutableArray alloc] init];
        _inTiposInmuebles = [[NSMutableArray alloc] init];
        _inTiposdeBienes = [[NSMutableArray alloc] init];
        _inUsos = [[NSMutableArray alloc] init];
        _inValor = [[NSMutableArray alloc] init];
        
        //Valores iniciales
        [_inDepartamentos addObject:@"-Seleccione"];
        [_inMunicipios addObject:@"-Seleccione"];
        [_inTiposInmuebles addObject:@"-Seleccione"];
        [_inTiposdeBienes addObject:@"-Seleccione"];
        [_inUsos addObject:@"-Seleccione"];
        [_inValor addObject:@"-Seleccione"];
        
        //Obtengo el arreglo con los datos
        NSArray * inmuebles = elJSON.datos;
        if (inmuebles != nil) {
            //Saco todos los inmuebles del array, los creo por el diccionario y los almaceno en el NSMutableArray
            for (NSDictionary *dicc in inmuebles) {
                RMInmuebleArriendo * inmueble = [[RMInmuebleArriendo alloc] initWithDictionary:dicc];
                if (!self.inmueblesArriendo) {
                    self.inmueblesArriendo = [NSMutableArray arrayWithObject:inmueble];
                    self.inmuArriendoAleatorio = [[NSMutableArray alloc] init];
                }else{
                    [self.inmueblesArriendo addObject: inmueble];
                }
                
                //Añado los diferentes tipos de datos
                [self addObject:inmueble.departamento InArray:_inDepartamentos];
                [self addObject:inmueble.municipio InArray:_inMunicipios];
                [self addObject:inmueble.tipodebien InArray:_inTiposdeBienes];
                [self addObject:inmueble.tipodeinmueble InArray:_inTiposInmuebles];
                [self addObject:inmueble.usodelbien InArray:_inUsos];
                [self addObject:[NSString stringWithFormat:@"%d", inmueble.canondearrendamiento] InArray:_inValor];
                
                //[self addObject:inmueble.canondearrendamiento InArray:_inValor];
                
            }
            [self generateRandomInmueblesInit:0];
            
        }else{
            //Se ha producido un error al parsear el JSON
            NSLog(@"Error al parsear el JSON");
        }
        
        //Ordeno los arrays alfabeticamente
        [_inDepartamentos sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        [_inMunicipios sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        [_inTiposdeBienes sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        [_inTiposInmuebles sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        [_inUsos sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        [_inValor sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    }
    
    return  self;
}

-(void)consumeBienesVenta{
    if (!self.bienesVenta) {
        self.bienesVenta = [[NSMutableArray alloc] init];
        
        //Encargo a la clase elJSON que consuma los datos de los inmuebles del set de datos
        RMMyJSON * elJSON = [[RMMyJSON alloc] initWithContentOfUrlString:URL_SET_DATOS_BIENES_VENTA];
        //Obtengo el arreglo con los datos
        NSArray * bienes = elJSON.datos;
        
        if (bienes != nil) {
            //Inicializo las categorias para bienes en venta
            _bnTiposdeBienes = [[NSMutableArray alloc] init];
            _bnUbicaciones = [[NSMutableArray alloc] init];
            _bnValor = [[NSMutableArray alloc] init];
            
            [_bnTiposdeBienes addObject:@"-Seleccione"];
            [_bnUbicaciones addObject:@"-Seleccione"];
            [_bnValor addObject:@"-Seleccione"];
            
            
            //Saco todos los inmuebles del array, los creo por el diccionario y los almaceno en el NSMutableArray
            for (NSDictionary *dicc in bienes) {
                RMBienVenta * bien = [[RMBienVenta alloc] initWithDictionary:dicc];
                [self.bienesVenta addObject: bien];
                
                //Añado los diferentes tipos de datos
                [self addObject:bien.tipodebien InArray:_bnTiposdeBienes];
                [self addObject:bien.ubicacion InArray:_bnUbicaciones];
                [self addObject:[NSString stringWithFormat:@"%d", bien.valordeventa] InArray:_bnValor];
            }
            
            //Ordeno los arrays alfabeticamente
            [_bnTiposdeBienes sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
            [_bnUbicaciones sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
            [_bnValor sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
            
        }else{
            //Se ha producido un error al parsear el JSON
            NSLog(@"Error al parsear el JSON");
        }
    }
}

-(RMInmuebleArriendo *) inmuebleArriendoAtIndex: (int) index{
    return  [self.inmueblesArriendo objectAtIndex:index];
}

-(RMBienVenta *) bienVentaAtIndex: (int) index{
    return [self.bienesVenta objectAtIndex:index];
}

-(RMInmuebleArriendo *)inmuebleAleatorioArriendoAtIndex:(int)index{
    return  [self.inmuArriendoAleatorio objectAtIndex:index];
}

-(void) addObject: (NSString *) aString InArray: (NSMutableArray *) aArray{
    if (![aArray containsObject:aString]) {
        [aArray addObject:aString];
    }
}

-(void)generateRandomInmueblesInit:(int)ini{
    if (ini > 4) {
        return;
    }
    int ran = arc4random_uniform([self inmuebleArriendoCount]);
    RMInmuebleArriendo* inmu = [self.inmueblesArriendo objectAtIndex:ran];
    
    if ([self.inmuArriendoAleatorio containsObject:inmu]) {
        [self generateRandomInmueblesInit:ini];
    }else{
        [self.inmuArriendoAleatorio addObject:inmu];
        [self generateRandomInmueblesInit:ini+1];
    }
}

#pragma mark - Properties

-(int)inmuebleArriendoCount{
    return [self.inmueblesArriendo count];
}

-(int)bienVentaCount{
    return [self.bienesVenta count];
}
-(NSArray *)inmueblesArray{
    return [self.inmueblesArriendo copy];
}
-(NSArray *)bienesArray{
    return [self.bienesVenta copy];
}
-(NSArray *)inArriAleatorioArray{
    return [self.inmuArriendoAleatorio copy];
}

@end
