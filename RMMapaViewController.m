//
//  RMMapaViewController.m
//  Inmovic
//
//  Created by Felipe on 29/01/14.
//  Copyright (c) 2014 Felipe. All rights reserved.
//

#import "RMMapaViewController.h"
#import <MapKit/MapKit.h>

@interface RMMapaViewController ()

//Defino los atributos
@property(nonatomic, copy) NSString * Nombre;
@property(nonatomic, copy) NSString * ubicacion;
@property (nonatomic, assign) CLLocationCoordinate2D coordenada;
@property (strong, nonatomic) IBOutlet MKMapView *mapa;

@end

@implementation RMMapaViewController

-(id)initWithName:(NSString *)aName location:(NSString *)aLocation coordinate:(NSString *)aCoordinate{
    
    if (self = [super initWithNibName:nil bundle:nil]) {
        _Nombre = aName;
        _ubicacion = aLocation;
        
        //Saco la latitud y la longitud que están en el string aCoordinate
        NSArray * coords = [aCoordinate componentsSeparatedByString:@";"];
        _coordenada.latitude = [[coords objectAtIndex:0] floatValue];
        _coordenada.longitude = [[coords lastObject] floatValue];
        
        self.title = @"Ubicación Inmueble";
    }
    
    return self;
}

-(void)viewDidAppear:(BOOL)animated{
    [self viewWillAppear:animated];
    
    //Asigno el delegado del mapa
    self.mapa.delegate = self;
    
    //Creo la anotación para representar la ubicación del inmueble
    MKPointAnnotation * anotacion = [[MKPointAnnotation alloc] init];
    anotacion.coordinate = self.coordenada;
    anotacion.title = self.Nombre;
    anotacion.subtitle = self.ubicacion;

    //Lo pongo en el mapa
    [self.mapa addAnnotation:anotacion];
    
    //Hago un acercamiento a la anotación
    [self zoomToFitMapAnnotations:self.mapa];
    
}

- (void)zoomToFitMapAnnotations:(MKMapView *)mapView {
    if ([mapView.annotations count] == 0) return;
    
    CLLocationCoordinate2D topLeftCoord;
    topLeftCoord.latitude = -90;
    topLeftCoord.longitude = 180;
    
    CLLocationCoordinate2D bottomRightCoord;
    bottomRightCoord.latitude = 90;
    bottomRightCoord.longitude = -180;
    
    for(id<MKAnnotation> annotation in mapView.annotations) {
        if ([[annotation title] isEqualToString:@"Current Location"]) {
            continue;
        }
        topLeftCoord.longitude = fmin(topLeftCoord.longitude, annotation.coordinate.longitude);
        topLeftCoord.latitude = fmax(topLeftCoord.latitude, annotation.coordinate.latitude);
        bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, annotation.coordinate.longitude);
        bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, annotation.coordinate.latitude);
    }
    
    MKCoordinateRegion region;
    region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5;
    region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5;
    region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 1.1;
    
    // Añado un pequeño espacio en los sides
    region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 1.1;
    
    region = [mapView regionThatFits:region];
    [mapView setRegion:region animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
