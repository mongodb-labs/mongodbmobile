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

#import "contacts.h"
#import "mongoc.h"

@interface MasterViewController ()

@property NSMutableArray *objects;
@end

@implementation MasterViewController

@synthesize contacts = _contacts;
@synthesize bundle = _bundle;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"HEREEEEEE %@", [[UIDevice currentDevice] name]);
    
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    UIBarButtonItem *runCommand = [[UIBarButtonItem alloc] initWithTitle:@"Test" style:UIBarButtonItemStyleDone target:self action:@selector(runCommand:)];
    self.navigationItem.leftBarButtonItem = runCommand;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    self.title = @"Mongo Contacts";
    _searchBar.placeholder = @"Search For Contact";
    
    AppDelegate* ad = [[UIApplication sharedApplication] delegate];
    self.bundle = ad.db;
    
    [self findAndReload];
    
    if ([_contacts count] == 0) {
        Contact *c1 = [[Contact alloc] initWithName:NULL name:@"Tyler Kaye" phoneNumber:@"914-582-9330"  address:@"Upper West Side, NY" notes:@"He works at mongodb" ];
        Contact *c2 = [[Contact alloc] initWithName:NULL name:@"Ben Shteinfeld" phoneNumber:@"432-567-9989"  address:@"Boston, MA" notes:@"He also works at mongodb" ];
        Contact *c3 = [[Contact alloc] initWithName:NULL name:@"Ted Tuckman" phoneNumber:@"123-456-4321"  address:@"New York, NY" notes:@"Works at mongodb" ];
        Contact *c4 = [[Contact alloc] initWithName:NULL name:@"Andrew Morrow" phoneNumber:@"987-9876-098"  address:@"UWS New York" notes:@"Manager at mongodb" ];
        Contact *c5 = [[Contact alloc] initWithName:NULL name:@"Gabriel Russel" phoneNumber:@"444-555-6666"  address:@"Lower East Side" notes:@"he is the build baron" ];
        Contact *c6 = [[Contact alloc] initWithName:NULL name:@"Sam Ritter" phoneNumber:@"111-222-3333"  address:@"Brooklyn" notes:@"She went to princeton" ];
        Contact *c7 = [[Contact alloc] initWithName:NULL name:@"Mark B" phoneNumber:@"999-888-98767"  address:@"Somewhere" notes:@"uses windows" ];
        Contact *c8 = [[Contact alloc] initWithName:NULL name:@"Spencer Jackson" phoneNumber:@"123-456-78788"  address:@"OPther place" notes:@"loves security work" ];
        
        NSMutableArray *allContacts = [NSMutableArray arrayWithObjects:c1, c2, c3, c4, c5, c6, c7, c8, nil];
        // NSMutableArray *allContacts = [NSMutableArray arrayWithObjects:c1, nil];
        [allContacts sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]];
        _contacts = allContacts;
        _searchResults = allContacts;
        
        for (Contact *c in allContacts) {
            c_contact *c_c = [Contact createC_ContactFromContact:c];
            insertContact(self.bundle, c_c);
            destroyContact(c_c);
        }
        
        NSLog(@"Inserted documents");
    }
    
    [self findAndReload];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self filterContentForSearchText:searchText scope:@""];
}


- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    if ([searchText length] == 0) {
        _searchResults = _contacts;
    }
    else {
        NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"name contains[c] %@", searchText];
        _searchResults = [_contacts filteredArrayUsingPredicate:resultPredicate];

    }
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
    [self.tableView reloadData];
    
    [super viewWillAppear:animated];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)runCommand:(id)sender {
    char* reply = executeCommand(self.bundle, "collStats");
    printf("%s\n", reply);
    
    [self performSegueWithIdentifier:@"collStats" sender:self];
    
    bson_free(reply);
}

- (NSString*) collStats {
    char* reply = executeCommand(self.bundle, "collStats");
    
    // begin experiment -- pushed to git for reference later
//    const unsigned char * cmd ="{ \"collStats\": \"contacts\" }\0";
//    mongoc_cursor_t * cursor = executeCollectionCommand(self.bundle, cmd);
//    char * reply = getCharCursorNext(cursor);
//    bool needFree = true;
//    if (reply == NULL) {reply = "{}"; needFree = false;}
    // end experiment
    
    NSString* s = [NSString stringWithUTF8String:reply];
    if(reply) {bson_free(reply); } else { reply = "{}"; }

    NSError* e;
    
    //1. convert string to NSData
    NSData* jsonData = [s dataUsingEncoding:NSUTF8StringEncoding];
    
    //2. convert JSON data to JSON object
    NSObject* jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:nil error:&e];
    
    //3. convert back to JSON data by setting .PrettyPrinted option
    NSData* prettyJsonData = [NSJSONSerialization dataWithJSONObject:jsonObject options:NSJSONWritingPrettyPrinted error:&e];
    
    //4. convert NSData back to NSString (use NSString init for convenience), later you can convert to String.
    NSString* prettyPrintedJson = [NSString stringWithUTF8String:[prettyJsonData bytes]];
    //[NSString initWithData: prettyJsonData encoding:NSUTF8StringEncoding];
    
    return prettyPrintedJson;
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
        Contact *c = [[Contact alloc] initWithName:NULL name:nameField.text phoneNumber:phoneField.text  address:addressField.text notes:notesField.text ];
        [self addNewContact:c];
        
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)addNewContact:(Contact *)newContact {
    c_contact* c_c = [Contact createC_ContactFromContact:newContact];
    insertContact(self.bundle, c_c);
    printf("name: %s oid: %s\n", c_contact_get_name(c_c), (char*) c_contact_get_oid(c_c));
    destroyContact(c_c);
    
    [self findAndReload];
}

- (void)removeContactAtIndexPath:(NSIndexPath *)indexPath {
    Contact* con = [_contacts objectAtIndex:indexPath.row];
    c_contact* c_c = [Contact createC_ContactFromContact:con];
    deleteContact(self.bundle, c_c);
    printf("name: %s oid: %s\n", c_contact_get_name(c_c), (char*) c_contact_get_oid(c_c));
    destroyContact(c_c);
        
    [self findAndReload];
}

- (void)findAndReload {
    mongoc_cursor_t* cursor = findAll(self.bundle);
    
    NSLog(@"Found documents");
    
    c_contact* c;
    NSMutableArray *contactsFromDB = [[NSMutableArray alloc] init];
    while ((c = getCursorNext(cursor))) {
        NSLog(@"In cursorl loop");
        Contact *con = [Contact createContactFromC_Contact:c];
        [contactsFromDB addObject: con];
    }
    [contactsFromDB sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES selector:@selector(caseInsensitiveCompare:)]]];
    _searchResults = contactsFromDB;
    _contacts = contactsFromDB;
    [self.tableView reloadData];
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Contact *contact = _searchResults[indexPath.row];
        DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
        [controller setMvc:self];
        [controller setContactItem:contact];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
    if ([[segue identifier] isEqualToString:@"collStats"]) {
        CollStatsViewController *con = (CollStatsViewController*)[segue destinationViewController];
        con.collStats = [self collStats];
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _searchResults.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = (UITableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Display recipe in the table cell
    Contact *c = _searchResults[indexPath.row];
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
