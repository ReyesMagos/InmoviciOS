//
//  RMCellDestacados.m
//  Inmovic
//
//  Created by imaclis on 1/02/14.
//  Copyright (c) 2014 Felipe. All rights reserved.
//

#import "RMCellDestacados.h"

@implementation RMCellDestacados

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
    self.areaLB.font = [UIFont fontWithName:@"FuturaStd-Heavy" size:17];
    self.nombreLB.font = [UIFont fontWithName:@"FuturaStd-Book" size:17];
    self.valorLB.font = self.ubicacionLB.font = [UIFont fontWithName:@"FuturaLight" size:17];
}



@end
