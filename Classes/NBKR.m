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

- (void) weeklyCurrencyRates:(void (^)(NSArray *))completeBlock error:(void (^)(NSError *))errorBlock {
    [self requestCurrencyRates:@"weekly" complete:completeBlock error:errorBlock];
}

- (void) dailyCurrencyRates:(void (^)(NSArray *))completeBlock error:(void (^)(NSError *))errorBlock {
    [self requestCurrencyRates:@"daily" complete:completeBlock error:errorBlock];
}

- (void) requestCurrencyRates:(NSString *)type complete:(void (^)(NSArray *))completeBlock error:(void (^)(NSError *))errorBlock {

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
                                   completeBlock([[[NBKRXMLParser alloc] initWithData:data] parse]);
                                   
                               } else {
                                   NSString *errorMessage = [NSString stringWithFormat:@"NBKR %@ rates. Invalid status code.", type, nil];
                                   errorBlock([NSError errorWithDomain:errorMessage code:-1 userInfo:nil]);
                               }
                           }
     ];
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
