//
//  MasterViewController.h
//  MongoEmbeddedContacts
//
//  Created by Tyler Kaye on 7/19/17.
//  Copyright © 2017 MongoDB. All rights reserved.
//

#import <UIKit/UIKit.h>


@class DetailViewController;

@interface MasterViewController : UITableViewController

@property (strong, nonatomic) DetailViewController *detailViewController;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property NSMutableArray *contacts;


@end

