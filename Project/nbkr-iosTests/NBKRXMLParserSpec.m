//
//  NBKRXMLParserSpec.m
//  nbkr-ios
//
//  Created by Kalys Osmonov on 3/12/14.
//  Copyright (c) 2014 Kalys Osmonov. All rights reserved.
//

#define EXP_SHORTHAND

#import "Specta.h"
#import "Expecta.h"
#import "Nocilla.h"

#import "NBKRXMLParser.h"


SpecBegin(NBKRXMLParser)

describe(@"parse", ^{
    it(@"should parse data", ^{
        NSString *dailyFixturesPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"daily_valid_currencies" ofType:@"xml"];
        NBKRXMLParser *parser = [NBKRXMLParser new];
        NSDictionary *result = [parser parse:[NSData dataWithContentsOfFile:dailyFixturesPath]];
        expect(result).to.beKindOf([NSDictionary class]);
        expect([result allKeys]).to.beSupersetOf(@[@"date", @"rates"]);
        NSString *dateString = [result objectForKey:@"date"];
        NSArray *rates = [result objectForKey:@"rates"];
        
        expect([[rates objectAtIndex:0] objectForKey:@"currency"]).to.equal(@"USD");
        expect(dateString).to.equal(@"15.12.2013");
    });
});

SpecEnd