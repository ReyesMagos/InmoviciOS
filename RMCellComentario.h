//
//  RMCellComentario.h
//  Inmovic
//
//  Created by Felipe on 1/03/14.
//  Copyright (c) 2014 Felipe. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RSTapRateView;

@interface RMCellComentario : UITableViewCell
@property (strong, nonatomic) IBOutlet RSTapRateView *estrellasView;
@property (strong, nonatomic) IBOutlet UITextView *comentarioTxtView;

@end
