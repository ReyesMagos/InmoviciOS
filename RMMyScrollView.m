//
//  RMMyScrollView.m
//  Inmovic
//
//  Created by imaclis on 29/01/14.
//  Copyright (c) 2014 Felipe. All rights reserved.
//

#import "RMMyScrollView.h"

@implementation RMMyScrollView

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self.nextResponder touchesBegan:touches withEvent:event];
}

@end
