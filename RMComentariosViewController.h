//
//  RMComentariosViewController.h
//  Inmovic
//
//  Created by Felipe on 2/02/14.
//  Copyright (c) 2014 Felipe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RSTapRateView.h"

@class RMInmuebleArriendo;


@interface RMComentariosViewController : UITableViewController <RSTapRateViewDelegate, UITextViewDelegate>



-(id)initWithInmueble: (RMInmuebleArriendo *) aInmueble style: (UITableViewStyle) aStyle;

@end
