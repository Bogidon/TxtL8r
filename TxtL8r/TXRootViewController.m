//
//  TXRootViewController.m
//  TxtL8r
//
//  Created by Bogdan Vitoc on 2/20/14.
//  Copyright (c) 2014 Bogdan Vitoc. All rights reserved.
//

#import "TXRootViewController.h"

#import <Parse/Parse.h>

@interface TXRootViewController ()

@end

@implementation TXRootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    void (^matchingFriends)() = ^ (){
      
        FBRequest* friendsRequest = [FBRequest requestForMyFriends];
        [friendsRequest startWithCompletionHandler: ^(FBRequestConnection *connection,
                                                      NSDictionary* result,
                                                      NSError *error) {
            // result will contain an array with your user's friends in the "data" key
            NSArray *friendObjects = [result objectForKey:@"data"];
            NSMutableArray *friendIds = [NSMutableArray arrayWithCapacity:friendObjects.count];
            // Create a list of friends' Facebook IDs
            for (NSDictionary *friendObject in friendObjects) {
                [friendIds addObject:[friendObject objectForKey:@"id"]];
            }
            
            // Construct a PFUser query that will find friends whose facebook ids
            // are contained in the current user's friend list.
            PFQuery *friendQuery = [PFUser query];
            
            [friendQuery whereKey:@"fbId" containedIn:friendIds];
            
            // findObjects will return a list of PFUsers that are friends
            // with the current user
            NSArray *friendUsers = [friendQuery findObjects];
            NSLog(@" %@ ", friendUsers);
        }];
    };
    
    [PFFacebookUtils logInWithPermissions:@[@"basic_info", @"email", @"user_likes"] block:^(PFUser *user, NSError *error) {
        if (!user) {
            if (!error) {
                NSLog(@"Uh oh. The user cancelled the Facebook login.");
            } else {
                NSLog(@"Uh oh. An error occured %@", error);
            }
            
        } else if (user.isNew) {
            [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                if (!error) {
                    // Store the current user's Facebook ID on the user
                    user.username = [result objectForKey:@"name"];
                    [[PFUser currentUser] setObject:[result objectForKey:@"id"]
                                             forKey:@"fbId"];

                    [[PFUser currentUser] saveInBackground];
                }
            }];
            NSLog(@"User signed up and logged in through Facebook!");
            matchingFriends();
            
        } else {
            NSLog(@"User logged in through Facebook!");
            matchingFriends();
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
