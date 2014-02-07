//
//  RMSoap.h
//  Inmovic
//
//  Created by Felipe on 2/02/14.
//  Copyright (c) 2014 Felipe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RMSoap : NSObject <NSXMLParserDelegate>{
    NSMutableData *webData;
	NSMutableString *soapResults;
	NSXMLParser *xmlParser;
	BOOL recordResults;
    
    
    NSString *_methodName;
    NSArray *_methodArguments;
    NSMutableArray *methodResultValues;
    NSMutableArray *methodResultNames;
    NSString* lastelement;
    NSString* parsed_chars;
    
    NSMutableString *webserviceurl;
}

-(void) executeWebMethod:(NSString*)aMethodName:(NSArray*)methodArguments:(NSInvocation*)callback;

-(id)initWithNSString: (NSString *) url;

@property (retain, nonatomic) NSString *_methodName;
@property (retain, nonatomic) NSArray *_methodArguments;
@property (retain, nonatomic) NSMutableString *webserviceurl;


@end
