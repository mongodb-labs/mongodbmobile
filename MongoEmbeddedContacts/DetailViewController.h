//
//  DetailViewController.h
//  MongoEmbeddedContacts
//
//  Created by Tyler KAye on 7/19/17.
//  Copyright © 2017 MongoDB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) NSDate *detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

