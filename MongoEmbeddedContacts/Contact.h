//
//  Contact.h
//  MongoEmbeddedContacts
//
//  Created by Tyler Kaye on 7/19/17.
//  Copyright © 2017 MongoDB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Contact : NSObject

@property (nonatomic, assign) NSInteger contactId;
@property (strong) NSString *name;
@property (assign) NSString *phoneNumber;
@property (assign) NSString *address;
@property (assign) NSString *notes;

- (id)initWithName:(NSInteger)contactId name:(NSString*)name phoneNumber:(NSString*)phoneNumber address:(NSString*)address notes:(NSString*)notes;

@end

