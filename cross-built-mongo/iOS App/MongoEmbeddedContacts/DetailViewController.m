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

@synthesize mvc = _mvc;

- (void)configureView {
    // Update the user interface for the detail item.
    if (self.contactItem) {
        self.nameTextField.text = [self.contactItem name];
        self.numberTextField.text = [self.contactItem phoneNumber];
        self.addressTextField.text = [self.contactItem address];
        self.notesTextField.text = [self.contactItem notes];
    }
}
-(void)updateButtonPressed:(id)sender
{
    if (_contactItem == nil) return;
    if (![_contactItem.name isEqualToString:_nameTextField.text]) {
        _contactItem.name = _nameTextField.text;
    }
    if (![_contactItem.phoneNumber isEqualToString:_numberTextField.text]) {
       _contactItem.phoneNumber = _numberTextField.text;
    }
    if (![_contactItem.address isEqualToString:_addressTextField.text]) {
        _contactItem.address = _addressTextField.text;
    }
    if (![_contactItem.notes isEqualToString:_notesTextField.text]) {
        _contactItem.notes = _notesTextField.text;
    }
    
    updateContactByOid(self.mvc.bundle, _contactItem.oid, [Contact createC_ContactFromContact:_contactItem]);
    [self.mvc findAndReload];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIBarButtonItem *updateButton = [[UIBarButtonItem alloc] initWithTitle:@"Update" style:UIBarButtonItemStyleDone target:self action:@selector(updateButtonPressed:)];
    self.navigationItem.rightBarButtonItem = updateButton;
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
        //[self configureView];
    }
}


@end
