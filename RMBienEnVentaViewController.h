//
//  RMBienEnVentaViewController.h
//  Inmovic
//
//  Created by Felipe on 30/01/14.
//  Copyright (c) 2014 Felipe. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RMBienVenta;

@interface RMBienEnVentaViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *splitViewFotos;
@property (strong, nonatomic) IBOutlet UITextView *descripcionTxtV;
@property (strong, nonatomic) IBOutlet UIImageView *imageViewGrande;

-(id)initWithBienVenta: (RMBienVenta *) aBienV;

@end