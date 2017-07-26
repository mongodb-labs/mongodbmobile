//
//  CollStatsViewController.h
//  MongoEmbeddedContacts
//
//  Created by Ben Shteinfeld on 7/24/17.
//  Copyright © 2017 MongoDB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollStatsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextView *collStatsBox;

@property (strong) NSString *collStats;

@end
