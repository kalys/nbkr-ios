//
//  ViewController.m
//  nbkr-ios
//
//  Created by Kalys Osmonov on 12/14/13.
//  Copyright (c) 2013 Kalys Osmonov. All rights reserved.
//

#import "ViewController.h"
#import "NBKR.h"

@interface ViewController ()

@property (nonatomic, retain) NSDictionary *result;

@end

@implementation ViewController

@synthesize result;

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    UITableView *tv = [[UITableView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:tv];
    [tv setDataSource:self];
    
    [[NBKR sharedInstance] currencyRates:^(NSDictionary* response) {
        self.result = response;
        [tv reloadData];
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
    NSString *key = [[self.result allKeys] objectAtIndex:indexPath.row];
    NSDictionary *currencyRate = [self.result objectForKey:key];
    cell.textLabel.text = key;
    cell.detailTextLabel.text = [currencyRate objectForKey:@"rate"];
    return cell;
}

@end
