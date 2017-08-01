//
//  CustomCommandViewController.h
//  MongoEmbeddedContacts
//
//  Created by Edward Tuckman on 7/31/17.
//  Copyright © 2017 MongoDB. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "contacts.h"

@interface CustomCommandViewController : UIViewController<UITextFieldDelegate>
@property mongocBundle *bundle;


@property (weak, nonatomic) IBOutlet UITextField *commandBox;

@property (weak, nonatomic) IBOutlet UIButton *submitCommand;
@property (weak, nonatomic) IBOutlet UITextView *resultBox;

@property (weak, nonatomic) IBOutlet UIButton *collStatsButton;
@property (weak, nonatomic) IBOutlet UIButton *countButton;
@property (weak, nonatomic) IBOutlet UIButton *serverStatusButton;


@end
