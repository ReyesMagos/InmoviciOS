//
//  RMBienVenta.m
//  Inmovic
//
//  Created by Felipe on 27/01/14.
//  Copyright (c) 2014 Felipe. All rights reserved.
//

#import "RMBienVenta.h"
#import "AsyncImageView.h"

@interface RMBienVenta ()


@property (nonatomic, strong) NSMutableArray*  atributosEnArray;

@end

@implementation RMBienVenta

-(id)initWithDictionary:(NSDictionary *)aDictionary{
    if (self = [super init]) {
        _partitionKey = [aDictionary objectForKey:@"PartitionKey"];
        _rowKey = [aDictionary objectForKey:@"RowKey"];
        _tipodebien = [self completeIfIsNilNSString:[aDictionary objectForKey:@"tipodebien"]];
        _descripcion = [self completeIfIsNilNSString:[aDictionary objectForKey:@"descripcion"]];
        _ubicacion = [self completeIfIsNilNSString:[aDictionary objectForKey:@"ubicacion"]];
        _informaciondecontacto = [self completeIfIsNilNSString:[aDictionary objectForKey:@"informaciondecontacto"]];
        _valordeventa = [[aDictionary objectForKey:@"valordeventa"] intValue];
        
        _linksfotos = [self captureLinksFromDicctionary:aDictionary];
        _atributosEnArray = [[NSMutableArray alloc] init];
        _fotos = [[NSMutableArray alloc] init];
        
        //Asigno los atributos que me interesan para búsquedas futuras
        [_atributosEnArray addObject:[aDictionary objectForKey:@"tipodebien"]];
        [_atributosEnArray addObject:[aDictionary objectForKey:@"ubicacion"]];
        [_atributosEnArray addObject:[aDictionary objectForKey:@"informaciondecontacto"]];
        [_atributosEnArray addObject:[aDictionary objectForKey:@"valordeventa"]];
        
        _atributos = TITLE_OF_ATTRIBUTES;
    }
    return self;
}

-(NSString*)completeIfIsNilNSString: (NSString*)aString{
    if ([aString isEqualToString:@""]) {
        return @"Sin información";
    }
    return aString;
}

//Capturo todos los links de las fotos del inmueble qué están en el diccionario
-(NSArray*)captureLinksFromDicctionary: (NSDictionary *) aDictionary{
    int i = 1;
    NSMutableArray * retorno = [[NSMutableArray alloc]init];
    NSURL * url = [[NSURL alloc]init];
    do {
        NSString * paraDiccionario = [NSString stringWithFormat:@"foto%d", i];
        NSString* pp = [aDictionary objectForKey:paraDiccionario];
        url = [NSURL URLWithString:pp];
        if (url != nil && ![pp isEqualToString:@""]){
            [retorno addObject:url];
        }
        i++;
    } while (url != nil);
    
    return [retorno copy];
}
//Consumo solo la primera foto para la portada
-(void)consumeFirstImage{
    AsyncImageView *imageView = [[AsyncImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 44.0f, 44.0f)];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    
    //Cargo la imagen para la portada
    if ([self.linksfotos count] == 0) {
        imageView.image = [UIImage imageNamed: @"escenariodefecto.png"];
        //return [UIImage imageNamed: @"escenariodefecto.png"];
    }else{
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:imageView];
        imageView.imageURL = [self.linksfotos objectAtIndex:0];
    }
    self.portadaV = imageView;
}

-(BOOL)isABienByArray:(NSArray *)aArray{
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

