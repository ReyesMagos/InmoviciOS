//
//  RMMyJSON.m
//  Inmovic
//
//  Created by Felipe on 27/01/14.
//  Copyright (c) 2014 Felipe. All rights reserved.
//

#import "RMMyJSON.h"

@implementation RMMyJSON

-(id)initWithContentOfUrlString: (NSString *) aString{
    if (self = [super init]) {
        _datos = [self jsonConContenidoDeURLString:aString];
    }
    return self;
}

/*
 Este metodo permite obtener los datos en formato JSON del set de datos.
 Serializa los datos y lo retorna en formato NSDictionary.
 @params url: direccion web de la localizacion del set de datos
 @return NSDictionary con la informacion JSON Serializada
 */
-(NSArray*) jsonConContenidoDeURLString: (NSString*) url{
    
    //Codificamos la url que entra en el formato UTF 8. Esto a raiz de si la url contiene tildes o espacios
    NSString *codificado = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //NSLog(@"imprimo codificado: %@", codificado);
    
    //Se obtiene el contenido de la url, se almacena como NSData
    NSData* data = [NSData dataWithContentsOfURL: [NSURL URLWithString: codificado]];
    
    
    //NSString * fileLocation = @"inmueble.json";
    //NSString *filePath = [[NSBundle mainBundle] pathForResource:[fileLocation stringByDeletingPathExtension] ofType:[fileLocation pathExtension]];
    //NSData* data = [NSData dataWithContentsOfFile:filePath];
    
    //NSData* data = [NSData dataWithContentsOfFile: @"inmueble.json"];
    
    __autoreleasing NSError* error = nil;
    if (data == nil) {
        NSLog(@"Error al descargar datos de internet");
        return nil;
    }
    
    //Se inicializa el diccionario
    //del NSData usando el metodo JSONOBjectData se serializa los datos y se guarga en el diccionario
    
    NSDictionary * diccionario = [NSJSONSerialization JSONObjectWithData: data options:kNilOptions error:&error];
    if (error != nil) {
        
        return nil ;
    }
    NSArray *retorno = [diccionario objectForKey:@"d"];
    return retorno;
}

@end
