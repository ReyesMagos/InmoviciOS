//
//  RMMapaViewController.h
//  Inmovic
//
//  Created by Felipe on 29/01/14.
//  Copyright (c) 2014 Felipe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface RMMapaViewController : UIViewController <MKMapViewDelegate>

//Defino el constructor
-(id)initWithName: (NSString *) aName
         location:(NSString *) aLocation
       coordinate: (NSString *) aCoordinate;

@end
