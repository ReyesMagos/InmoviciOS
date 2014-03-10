//
//  RMCellDestacados.h
//  Inmovic
//
//  Created by imaclis on 1/02/14.
//  Copyright (c) 2014 Felipe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RMCellDestacados : UITableViewCell 

@property (strong, nonatomic) IBOutlet UITextView *nombreTxtView;
@property (weak, nonatomic) IBOutlet UILabel *areaLB;
@property (weak, nonatomic) IBOutlet UILabel *nombreLB;
@property (weak, nonatomic) IBOutlet UILabel *valorLB;
@property (weak, nonatomic) IBOutlet UILabel *ubicacionLB;
@property (weak, nonatomic) IBOutlet UIView *viewview;


@end
