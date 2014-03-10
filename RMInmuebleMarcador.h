//
//  RMInmuebleMarcador.h
//  Inmovic
//
//  Created by Felipe on 1/03/14.
//  Copyright (c) 2014 Felipe. All rights reserved.
//

#import <MapKit/MapKit.h>
@class RMInmuebleArriendo;

@interface RMInmuebleMarcador : MKPointAnnotation

@property (nonatomic, strong) RMInmuebleArriendo * inmueble;


-(id)initWithInmueble: (RMInmuebleArriendo *) aInmueble;

@end
