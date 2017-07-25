//
//  CollStatsViewController.m
//  MongoEmbeddedContacts
//
//  Created by Ben Shteinfeld on 7/24/17.
//  Copyright © 2017 MongoDB. All rights reserved.
//

#import "CollStatsViewController.h"

@interface CollStatsViewController ()

@end

@implementation CollStatsViewController

@synthesize collStatsBox = _collStatsBox;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.collStatsBox.text = self.collStats;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
