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
        NSArray * rates = [parser parse:[NSData dataWithContentsOfFile:dailyFixturesPath]];
        expect(rates).notTo.beEmpty();
        expect([[rates objectAtIndex:0] objectForKey:@"currency"]).to.equal(@"USD");
    });
});

SpecEnd