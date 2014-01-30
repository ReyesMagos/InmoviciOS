//
//  RMMyJSON.h
//  Inmovic
//
//  Created by Felipe on 27/01/14.
//  Copyright (c) 2014 Felipe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RMMyJSON : NSObject

@property (nonatomic, strong) NSArray * datos;

-(id)initWithContentOfUrlString: (NSString *) aString;

@end
