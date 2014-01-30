//
//  RMBienVenta.m
//  Inmovic
//
//  Created by Felipe on 27/01/14.
//  Copyright (c) 2014 Felipe. All rights reserved.
//

#import "RMBienVenta.h"

@implementation RMBienVenta

-(id)initWithDictionary:(NSDictionary *)aDictionary{
    if (self = [super init]) {
        _partitionKey = [aDictionary objectForKey:@"PartitionKey"];
        _rowKey = [aDictionary objectForKey:@"RowKey"];
        _tipodebien = [aDictionary objectForKey:@"tipodebien"];
        _descripcion = [aDictionary objectForKey:@"descripcion"];
        _ubicacion = [aDictionary objectForKey:@"ubicacion"];
        _informaciondecontacto = [aDictionary objectForKey:@"informaciondecontacto"];
        _valordeventa = [[aDictionary objectForKey:@"valordeventa"] floatValue];
        
    }
    return self;
}

@end

