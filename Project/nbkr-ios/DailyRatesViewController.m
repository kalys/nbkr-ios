//
//  ViewController.m
//  nbkr-ios
//
//  Created by Kalys Osmonov on 12/14/13.
//  Copyright (c) 2013 Kalys Osmonov. All rights reserved.
//

#import "DailyRatesViewController.h"
#import "CurrencyRate.h"

@interface DailyRatesViewController ()

@property (nonatomic, retain) NSArray *rates;

@end

@implementation DailyRatesViewController

@synthesize rates;

- (void) viewDidLoad
{
    [super viewDidLoad];

    [self.tableView setDataSource:self];
    
    
    @weakify(self);
    [RACObserve(self, rates) subscribeNext:^(id x) {
        @strongify(self);
        [self.tableView reloadData];
    }];
    
    [self loadRates];
}

- (void) loadRates {

    [[CurrencyRate fetchRates] subscribeNext:^(NSArray* _rates) {
        self.rates = _rates;
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark tableView datasource

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [(NSDictionary *)[self.rates objectAtIndex:section] objectForKey:@"date"];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self ratesForSection:section] count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"aoeuaeou"];

    NSDictionary *currencyRate = [self ratesAtIndexPath:indexPath];
    cell.textLabel.text = [currencyRate objectForKey:@"currency"];
    cell.detailTextLabel.text = [currencyRate objectForKey:@"rate"];
    return cell;
}

- (NSDictionary *) ratesAtIndexPath:(NSIndexPath *)indexPath {
    return [[self ratesForSection:indexPath.section] objectAtIndex:indexPath.row];
}

- (NSArray *) ratesForSection:(NSInteger)section {
    return (NSArray *) [(NSDictionary *) [self.rates objectAtIndex:section] objectForKey:@"rates"];
}

@end
