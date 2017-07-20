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
        self.nameTextField.text = [self.contactItem name];
        self.numberTextField.text = [self.contactItem phoneNumber];
        self.addressTextField.text = [self.contactItem address];
        [self.notesTextField setText: [self.contactItem notes]];
        NSLog(@"Noteshere: %@", self.notesTextField.text);
    }
}
-(void)updateButtonPressed:(id)sender
{
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
