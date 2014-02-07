//
//  RMSoap.m
//  Inmovic
//
//  Created by Felipe on 2/02/14.
//  Copyright (c) 2014 Felipe. All rights reserved.
//

#import "RMSoap.h"


@interface RMSoap()
@property (nonatomic, strong ) NSInvocation *callbackfunction;
@end

@implementation RMSoap

@synthesize _methodName, _methodArguments, webserviceurl;


- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        
        ////default webservice loacation for this project
        ////if you want to set another url use initWithWebServiceURL
        webserviceurl = [[NSMutableString alloc] initWithString:@"http://190.12.157.123/UVInmuebles/ServicioInmueble.asmx"];
        
        
    }
    
    return self;
}

-(id)initWithNSString:(NSString *)url{
    if (self = [super init]) {
        webserviceurl = [[NSMutableString alloc] initWithString:url];
    }
    return self;
}

-(NSString*) createArgumentsTags:(NSArray*)arguments
{
    NSString *result = @"";
    
    if(arguments)
        for (int i = 0; i != [arguments count] ; i+=2) {
            result = [NSString stringWithFormat:
                      @"%@"
                      "<%@>"
                      "%@"
                      "</%@>\n"
                      ,result, [arguments objectAtIndex:i], [arguments objectAtIndex:i+1], [arguments objectAtIndex:i] ];
        }
    
    return  result;
    
}


-(void) executeWebMethod:(NSString*)methodName:(NSArray*)methodArguments:(NSInvocation*)callback
//      This function executes the desired method from the corresponding webservice
//      methodName: name of the method on the web service to call
//      methodArguments: arguments of the method with this syntax:
//                          arg1Name, arg1Value, arg2Name, arg2Value,...
//      callback: the NSInvocation of the callback function that will be called when the method execution ends
{
    recordResults = FALSE;
    
    self.callbackfunction = callback;
    methodResultValues = [[NSMutableArray alloc] init];
    methodResultNames = [[NSMutableArray alloc] init];
    lastelement = [[NSString alloc] init];
    parsed_chars = [[NSString alloc] init];
    
    self._methodName = methodName;
    self._methodArguments = methodArguments;
    
    
    NSString *soapMessage = [NSString stringWithFormat:
							 @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
							 "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
							 "<soap:Body>\n"
							 "<%@ xmlns=\"http://tempuri.org/\">\n"
                             "%@"
                             "</%@>\n"
							 "</soap:Body>\n"
							 "</soap:Envelope>\n", methodName, [self createArgumentsTags:methodArguments],methodName
							 ];
	NSLog(soapMessage,"");
	
	NSURL *url = [NSURL URLWithString:self.webserviceurl];
	NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
	NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
	
	[theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
	[theRequest addValue:[NSString stringWithFormat: @"http://tempuri.org/%@", methodName] forHTTPHeaderField:@"SOAPAction"];
	[theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
	[theRequest setHTTPMethod:@"POST"];
	[theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
	
	NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
	
	if( theConnection )
	{
		webData = [NSMutableData data];
	}
	else
	{
		NSLog(@"soap.m: theConnection is NULL");
	}
    
}


-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	[webData setLength: 0];
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[webData appendData:data];
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	NSLog(@"soap.m: ERROR with theConenction");
    
    if (self.callbackfunction) {
        [self.callbackfunction invoke];
    }
    
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	NSLog(@"soap.m: DONE. Received Bytes: %d", [webData length]);
	NSString *theXML = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
	NSLog(theXML,"");
    
	if ([webData length] == 0) {
        [self.callbackfunction setArgument:&methodResultValues atIndex:2];
        [self.callbackfunction setArgument:&methodResultNames atIndex:3];
        [self.callbackfunction invoke];
    }
	xmlParser = [[NSXMLParser alloc] initWithData: webData];
	[xmlParser setDelegate: self];
	[xmlParser setShouldResolveExternalEntities: YES];
	[xmlParser parse];
    
    
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *) namespaceURI qualifiedName:(NSString *)qName
   attributes: (NSDictionary *)attributeDict
{
    parsed_chars = nil;
    lastelement = elementName;
    
	if( [elementName isEqualToString:[NSString stringWithFormat: @"%@Result", self._methodName]])
	{
		recordResults = TRUE;
	}
    
}
-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	if( recordResults )
	{
        parsed_chars = string;
	}
}



-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if( [elementName isEqualToString:lastelement] )
    {
        if (parsed_chars)
            [methodResultValues addObject: parsed_chars];
        else
            [methodResultValues addObject: @""];
        
        [methodResultNames addObject:lastelement];
        
    }
    
    
	if( [elementName isEqualToString:[NSString stringWithFormat: @"%@Result", self._methodName]])
	{
		recordResults = FALSE;
        
        if(self.callbackfunction)
        {
            [self.callbackfunction setArgument:&methodResultValues atIndex:2];
            [self.callbackfunction setArgument:&methodResultNames atIndex:3];
            [self.callbackfunction invoke];
        }
	}
}


@end
