//
//  ViewController.m
//  nbkr-ios
//
//  Created by Kalys Osmonov on 12/14/13.
//  Copyright (c) 2013 Kalys Osmonov. All rights reserved.
//

#import "DailyRatesViewController.h"
#import "NBKR.h"

@interface DailyRatesViewController ()

@property (nonatomic, retain) NSArray *result;

@end

@implementation DailyRatesViewController

@synthesize result;

- (void) viewDidLoad
{
    [super viewDidLoad];
    

    [self.tableView setDataSource:self];
    
    [[NBKR new] dailyCurrencyRates:^(NSArray* response) {
        self.result = response;
        [self.tableView reloadData];
        }
                                   error:nil];
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark tableView datasource
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.result count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"aoeuaeou"];
    NSDictionary *currencyRate = [self.result objectAtIndex:indexPath.row];
    cell.textLabel.text = [currencyRate objectForKey:@"currency"];
    cell.detailTextLabel.text = [currencyRate objectForKey:@"rate"];
    return cell;
}

@end
