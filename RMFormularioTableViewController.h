//
//  RMFormularioTableViewController.h
//  Inmovic
//
//  Created by Felipe on 1/02/14.
//  Copyright (c) 2014 Felipe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
@class RMBienVenta;
@class RMInmuebleArriendo;

@interface RMFormularioTableViewController : UITableViewController <UITextFieldDelegate,  MFMailComposeViewControllerDelegate>

-(id)initWithObject:(id) aObject;

@end
