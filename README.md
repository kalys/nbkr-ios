# nbkr-ios

[![Version](http://cocoapod-badges.herokuapp.com/v/nbkr-ios/badge.png)](http://cocoadocs.org/docsets/nbkr-ios)
[![Platform](http://cocoapod-badges.herokuapp.com/p/nbkr-ios/badge.png)](http://cocoadocs.org/docsets/nbkr-ios)

## Usage

To run the example project; clone the repo, and run `pod install` from the Project directory first.

### Daily currency rates for USD, RUR, KZT, EUR
```
[[NBKR sharedInstance] dailyCurrencyRates:^(NSDictionary *rates)
	{
		NSLog(@"%@", [rates objectForKey:@"USD"]);
		NSLog(@"%@", [rates objectForKey:@"RUR"]);
		NSLog(@"%@", [rates objectForKey:@"KZT"]);
		NSLog(@"%@", [rates objectForKey:@"EUR"]);
	}
	error:^(NSError *error) {
		NSLog(@"%@", error);
	}
];
```

## Requirements

## Installation

nbkr-ios is available through [CocoaPods](http://cocoapods.org), to install
it simply add the following line to your Podfile:

    pod "nbkr-ios"

## Author

Kalys Osmonov, kalys@osmonov.com

## License

nbkr-ios is available under the MIT license. See the LICENSE file for more info.

