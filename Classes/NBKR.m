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

static dispatch_once_t once_token = 0;

+ (id) sharedInstance {
    
    __strong static id _sharedObject = nil;
    
    dispatch_once(&once_token, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

+ (void) resetInstance {
    once_token = 0;
}

- (void) dailyCurrencyRates:(void (^)(NSArray *))completeBlock error:(void (^)(NSError *))errorBlock {
    self.result = [NSMutableArray new];
    NSURLRequest *request = [NSURLRequest requestWithURL: [NSURL URLWithString:@"http://www.nbkr.kg/XML/daily.xml"]];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               if (connectionError) {
                                   errorBlock(connectionError);
                               }
                               
                               NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:data];
                               [xmlParser setDelegate:self];
                               [xmlParser parse];
                               completeBlock(self.result);
                           }
    ];
}

- (void) currencyRates:(void (^)(NSDictionary *))completeBlock error:(void (^)(NSError *))errorBlock {
    NSOperationQueue *opQueue = [[NSOperationQueue alloc] init];
    
    // TODO: validate currency codes
    
    self.result = [NSMutableDictionary new];
    __weak NBKR *weakSelf = self;
    
    // let's do sync (yes, sync) requests in new thread. that'll be ok i guess.
    [opQueue addOperationWithBlock:^{
        // synchronously fetch daily currency rates
        NSXMLParser *xmlParser = nil;
        NSData *data = [self getContentsOfUrlString:@"http://www.nbkr.kg/XML/daily.xml"];
        if (data) {
            xmlParser = [[NSXMLParser alloc] initWithData:data];
            [xmlParser setDelegate:weakSelf];
            [xmlParser parse];
        }
        
        data = [self getContentsOfUrlString:@"http://www.nbkr.kg/XML/weekly.xml"];
        if (data) {
            xmlParser = [[NSXMLParser alloc] initWithData:data];
            [xmlParser setDelegate:weakSelf];
            [xmlParser parse];
        }
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            completeBlock(weakSelf.result);
        }];

    }];
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
