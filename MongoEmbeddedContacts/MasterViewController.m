//
//  MasterViewController.m
//  MongoEmbeddedContacts
//
//  Created by Tyler Kaye on 7/19/17.
//  Copyright © 2017 MongoDB. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "Contact.h"

@interface MasterViewController ()

@property NSMutableArray *objects;
@end

@implementation MasterViewController

@synthesize contacts = _contacts;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    self.title = @"Mongo Contacts";
    
    Contact *c1 = [[Contact alloc] initWithName:1 name:@"Tyler Kaye" phoneNumber:@"914-582-9330"  address:@"MongoDB" notes:@"He is cool" ];
    Contact *c2 = [[Contact alloc] initWithName:2 name:@"Nicole Kaye" phoneNumber:@"914-582-9330"  address:@"MongoDB" notes:@"He is cool" ];
    Contact *c3 = [[Contact alloc] initWithName:3 name:@"Sydney Kaye" phoneNumber:@"914-582-9330"  address:@"MongoDB" notes:@"He is cool" ];
    
    NSMutableArray *allContacts = [NSMutableArray arrayWithObjects:c1, c2, c3, nil];
    [allContacts sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]];
    _contacts = allContacts;
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"name contains[c] %@", searchText];
    //_searchResults = [_contacts filteredArrayUsingPredicate:resultPredicate];
}

- (void)viewWillAppear:(BOOL)animated {
    self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
    [super viewWillAppear:animated];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)insertNewObject:(id)sender {
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle: @"Add New Contact"
                                                                              message: @"Please Fill Out The Below Information"
                                                                       preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Name";
        textField.textColor = [UIColor blueColor];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.borderStyle = UITextBorderStyleRoundedRect;
    }];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Phone Number";
        textField.textColor = [UIColor blueColor];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.borderStyle = UITextBorderStyleRoundedRect;
    }];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Address";
        textField.textColor = [UIColor blueColor];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.borderStyle = UITextBorderStyleRoundedRect;
    }];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Notes";
        textField.textColor = [UIColor blueColor];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.borderStyle = UITextBorderStyleRoundedRect;
    }];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSArray * textfields = alertController.textFields;
        UITextField * nameField = textfields[0];
        UITextField * phoneField = textfields[1];
        UITextField * addressField = textfields[2];
        UITextField * notesField = textfields[3];
        NSLog(@"%@:%@:%@:%@",nameField.text,phoneField.text, addressField.text, notesField.text);
        Contact *c = [[Contact alloc] initWithName:100 name:nameField.text phoneNumber:phoneField.text  address:addressField.text notes:notesField.text ];
        [self addNewContact:c];
        
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
//    if (!self.objects) {
//        self.objects = [[NSMutableArray alloc] init];
//    }
//    [self.objects insertObject:[NSDate date] atIndex:0];
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)addNewContact:(Contact *)newContact {
    if (!_contacts) {
        _contacts = [[NSMutableArray alloc] init];
    }
    [_contacts insertObject:newContact atIndex:0];
    [self.tableView reloadData];
}

- (void)removeContactAtIndexPath:(NSIndexPath *)indexPath {
    if (_contacts) {
        [_contacts removeObjectAtIndex:indexPath.row];
        [self.tableView reloadData];
        NSLog(@"REMOVING CONTACT");
    }
}


#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Contact *contact = _contacts[indexPath.row];
        DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
        [controller setDetailItem:contact];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _contacts.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = (UITableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Display recipe in the table cell
    Contact *c = _contacts[indexPath.row];
    cell.textLabel.text = [c name];
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self removeContactAtIndexPath:indexPath];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}


@end
