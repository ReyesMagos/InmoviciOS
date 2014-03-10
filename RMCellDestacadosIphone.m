//
//  RMCellDestacadosIphone.m
//  Inmovic
//
//  Created by Felipe on 8/02/14.
//  Copyright (c) 2014 Felipe. All rights reserved.
//

#import "RMCellDestacadosIphone.h"

@implementation RMCellDestacadosIphone

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
    self.areaLB.font = [UIFont fontWithName:@"FuturaStd-Heavy" size:17];
    self.nombreTxtView.font = [UIFont fontWithName:@"FuturaStd-Book" size:16];
    self.nombreTxtView.editable = NO;
    self.nombreLB.font = [UIFont fontWithName:@"FuturaStd-Book" size:16];
    self.valorLB.font = self.ubicacionLB.font = [UIFont fontWithName:@"FuturaLight" size:15];
}



@end
