//
//  RMInmuebleMarcador.m
//  Inmovic
//
//  Created by Felipe on 1/03/14.
//  Copyright (c) 2014 Felipe. All rights reserved.
//

#import "RMInmuebleMarcador.h"

@implementation RMInmuebleMarcador


-(id)initWithInmueble:(RMInmuebleArriendo *)aInmueble{
    if (self = [super init]) {
        _inmueble = aInmueble;
    }
    return self;
}

@end
