//
//  DetailViewController.h
//  MongoEmbeddedContacts
//
//  Created by Tyler Kaye on 7/19/17.
//  Copyright © 2017 MongoDB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MasterViewController.h"
#import "Contact.h"

@interface DetailViewController : UIViewController

@property (strong, nonatomic) Contact * contactItem;

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *numberTextField;
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;
@property (weak, nonatomic) IBOutlet UITextField *notesTextField;

@property (weak) MasterViewController* mvc;

@end

