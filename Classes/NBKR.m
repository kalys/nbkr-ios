//
//  NBKR.m
//  nbkr-ios
//
//  Created by Kalys Osmonov on 12/14/13.
//  Copyright (c) 2013 Kalys Osmonov. All rights reserved.
//

#import "NBKR.h"
#import "NBKRXMLParser.h"

@implementation NBKR

- (instancetype) init {
    self = [super init];
    if (self) {
        self.parser = [NBKRXMLParser new];
    }
    return self;
}

- (void) weeklyCurrencyRates:(void (^)(NSDictionary *))completeBlock error:(void (^)(NSError *))errorBlock {
    [self requestCurrencyRates:@"weekly" complete:completeBlock error:errorBlock];
}

- (void) dailyCurrencyRates:(void (^)(NSDictionary *))completeBlock error:(void (^)(NSError *))errorBlock {
    [self requestCurrencyRates:@"daily" complete:completeBlock error:errorBlock];
}

- (void) requestCurrencyRates:(NSString *)type complete:(void (^)(NSDictionary *))completeBlock error:(void (^)(NSError *))errorBlock {

    NSString *urlString = [NSString stringWithFormat:@"http://www.nbkr.kg/XML/%@.xml", type, nil];
    NSURLRequest *request = [NSURLRequest requestWithURL: [NSURL URLWithString:urlString]];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                               if (connectionError) {
                                   errorBlock(connectionError);
                                   return;
                               }
                               
                               if ([httpResponse statusCode] == 200) {
                                   completeBlock([self.parser parse:data]);
                                   
                               } else {
                                   NSString *errorMessage = [NSString stringWithFormat:@"NBKR %@ rates. Invalid status code.", type, nil];
                                   errorBlock([NSError errorWithDomain:errorMessage code:-1 userInfo:nil]);
                               }
                           }
     ];
}

@end
