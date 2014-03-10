//
//  RMMapaViewController.m
//  Inmovic
//
//  Created by Felipe on 29/01/14.
//  Copyright (c) 2014 Felipe. All rights reserved.
//

#import "RMMapaViewController.h"
#import <MapKit/MapKit.h>
#import "RMInmuebleArriendo.h"
#import "RMInmuebleArriendoViewController.h"
#import "RMInmuebleMarcador.h"

@interface RMMapaViewController ()

//Defino los atributos
@property(nonatomic, copy) NSString * Nombre;
@property(nonatomic, copy) NSString * ubicacion;
@property (nonatomic, assign) CLLocationCoordinate2D coordenada;
@property (strong, nonatomic) IBOutlet MKMapView *mapa;
@property (nonatomic, strong) MKMapView * mapa2;

@property (nonatomic, strong) NSArray * inmuebles;

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
        [self loadMap];
    }
    
    return self;
}

-(id)initWithArray:(NSArray *)aArray{
    if (self = [super initWithNibName:nil bundle:nil]) {
        _inmuebles = aArray;
        [self loadMap];
    }
    
    return self;
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    //Una vez que aparece el View imprimo los marcadores en el mapa
    [self imprimeMarcadores];
    
}

-(void)loadMap{
    self.title = @"Ubicación";
    
    self.mapa2 = [[MKMapView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.mapa2.delegate = self;
    [self.view addSubview:self.mapa2];
    
    MKCoordinateRegion region;
    region.center.latitude = 4.60971;
    region.center.longitude = -74.08175;
    region.span.latitudeDelta = 14;
    region.span.longitudeDelta = 14;
    [self.mapa2 setRegion:region animated:NO];
    
    
}

//Metodo que pone los marcadores (annotation) del inmueble-s en el mapa
-(void) imprimeMarcadores{

    if (self.inmuebles) { //Si son muchos inmuebles los que se muestran ejecuta esto
 
        for (RMInmuebleArriendo * inmu in self.inmuebles) {
            
            NSArray * coords = [inmu.coordenadas componentsSeparatedByString:@";"];
            CLLocationCoordinate2D posicionMarcador;
            posicionMarcador.latitude = [[coords objectAtIndex:0] floatValue];
            posicionMarcador.longitude = [[coords lastObject] floatValue];
            
            if (posicionMarcador.latitude == 0 || posicionMarcador.longitude == 0) {
                continue;
            }
            
            //Creo la anotación para representar la ubicación del inmueble
            RMInmuebleMarcador * marcador = [[RMInmuebleMarcador alloc] initWithInmueble:inmu];
            marcador.coordinate = posicionMarcador;
            marcador.title = inmu.nombredelbien;
            marcador.subtitle = [NSString stringWithFormat:@"%@ - %@", inmu.departamento, inmu.municipio];
            
            //Lo pongo en el mapa
            [self.mapa2 addAnnotation:marcador];
    }
        //Acomodo el zoom del mapa para mostrar todos los marcadores
        [self zoomToFitMapAnnotations:self.mapa2];
        
    }else{
        //Creo la anotación para representar la ubicación del inmueble
        MKPointAnnotation * anotacion = [[MKPointAnnotation alloc] init];
        anotacion.coordinate = self.coordenada;
        anotacion.title = self.Nombre;
        anotacion.subtitle = self.ubicacion;
        
        //Lo pongo en el mapa
        [self.mapa2 addAnnotation:anotacion];
        
        //Hago un acercamiento a la anotación
        //[self zoomToFitMapAnnotations:self.mapa2];
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    static NSString *identifier = @"Marcador";
    if (self.inmuebles) {
        
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *) [self.mapa2 dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        } else {
            annotationView.annotation = annotation;
        }
        
        annotationView.enabled = YES;
        annotationView.pinColor = MKPinAnnotationColorGreen;
        annotationView.canShowCallout = YES;
        
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        [rightButton setTitle:annotation.title forState:UIControlStateNormal];
        [annotationView setRightCalloutAccessoryView:rightButton];
        
        return annotationView;
    }
    
    return nil;
}

- (void)mapView:(MKMapView *)mapView
 annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    
    if ([(UIButton*)control buttonType] == UIButtonTypeDetailDisclosure){
        
        RMInmuebleMarcador *capturado = (RMInmuebleMarcador*)[view annotation];
        RMInmuebleArriendoViewController * inmuVC = [[RMInmuebleArriendoViewController alloc] initWithInmueble:capturado.inmueble];
        [[self navigationController] pushViewController:inmuVC animated:YES];
    }
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
