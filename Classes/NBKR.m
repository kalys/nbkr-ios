//
//  NBKR.m
//  nbkr-ios
//
//  Created by Kalys Osmonov on 12/14/13.
//  Copyright (c) 2013 Kalys Osmonov. All rights reserved.
//

#import "NBKR.h"

@interface NBKR ()

@property (atomic, retain) NSString *dateString;
@property (atomic, retain) NSString *currencyCode;
@property (atomic, assign) BOOL rateNode;
@property (atomic, retain) NSString *currencyRate;



@end

@implementation NBKR

@synthesize result = _result;
@synthesize dateString = _dateString;
@synthesize currencyCode = _currencyCode;
@synthesize rateNode = _rateNode;

- (void) weeklyCurrencyRates:(void (^)(NSArray *))completeBlock error:(void (^)(NSError *))errorBlock {
    self.result = [NSMutableArray new];
    NSURLRequest *request = [NSURLRequest requestWithURL: [NSURL URLWithString:@"http://www.nbkr.kg/XML/weekly.xml"]];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                               if (connectionError) {
                                   errorBlock(connectionError);
                                   return;
                               }
                               
                               if ([httpResponse statusCode] == 200) {
                                   
                                   NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:data];
                                   [xmlParser setDelegate:self];
                                   [xmlParser parse];
                                   completeBlock(self.result);
                               } else {
                                   errorBlock([NSError errorWithDomain:@"NBKR weekly rates. Invalid status code." code:-1 userInfo:nil]);
                               }
                           }
     ];
}

- (void) dailyCurrencyRates:(void (^)(NSArray *))completeBlock error:(void (^)(NSError *))errorBlock {
    self.result = [NSMutableArray new];
    NSURLRequest *request = [NSURLRequest requestWithURL: [NSURL URLWithString:@"http://www.nbkr.kg/XML/daily.xml"]];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                               if (connectionError) {
                                   errorBlock(connectionError);
                                   return;
                               }
                               
                               if ([httpResponse statusCode] == 200) {
                               
                                   NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:data];
                                   [xmlParser setDelegate:self];
                                   [xmlParser parse];
                                   completeBlock(self.result);
                               } else {
                                   errorBlock([NSError errorWithDomain:@"NBKR daily rates. Invalid status code." code:-1 userInfo:nil]);
                               }
                           }
    ];
}

#pragma mark NSXMLParserDelegate methods

- (void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    if ([elementName isEqualToString:@"CurrencyRates"]) {
        self.dateString = [attributeDict objectForKey:@"Date"];
    } else if ([elementName isEqualToString:@"Currency"]) {
        self.currencyCode = [attributeDict objectForKey:@"ISOCode"];
    } else if ([elementName isEqualToString:@"Value"]) {
        self.rateNode = YES;
    }
}

- (void) parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if (self.rateNode) {
        self.currencyRate = string;
    }
}

- (void) parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if ([elementName isEqualToString:@"Value"]) {
        self.rateNode = NO;
    } else if ([elementName isEqualToString:@"Currency"]) {
        //[self.result setObject:@{@"rate": self.currencyRate, @"date": self.dateString} forKey:self.currencyCode];
        [self.result addObject:@{@"currency": self.currencyCode, @"rate": self.currencyRate, @"date": self.dateString}];
        
        self.currencyRate = nil;
        self.currencyCode = nil;
    }
}

#pragma mark Helper methods

- (NSData *) getContentsOfUrlString:(NSString *)url {
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL: [NSURL URLWithString:url]];
    NSURLResponse * response = nil;
    NSError *error = nil;
    

    NSData *data = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
    if (error) {
        return nil;
    }
    return data;
}

@end
