//
//  DetailViewController.m
//  MongoEmbeddedContacts
//
//  Created by Tyler Kaye on 7/19/17.
//  Copyright © 2017 MongoDB. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)configureView {
    // Update the user interface for the detail item.
    if (self.contactItem) {
        self.nameLabel.text = [self.contactItem name];
        self.phoneLabel.text = [self.contactItem phoneNumber];
        self.addressLabel.text = [self.contactItem address];
        self.notesLabel.text = [self.contactItem notes];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Managing the detail item

- (void)setDetailItem:(Contact *)newDetailItem {
    if (_contactItem != newDetailItem) {
        _contactItem = newDetailItem;         
        // Update the view.
        [self configureView];
    }
}


@end
