//
//  TXRootViewController.m
//  TxtL8r
//
//  Created by Bogdan Vitoc on 2/20/14.
//  Copyright (c) 2014 Bogdan Vitoc. All rights reserved.
//

#import "TXRootViewController.h"

#import <Parse/Parse.h>

#pragma mark - 
#pragma mark Interface
@interface TXRootViewController ()

@end

#pragma mark -
#pragma mark Implementation
@implementation TXRootViewController{
    NSMutableArray *parseFriends;
}

@synthesize drivingButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    void (^findMatchingFriends)() = ^ (){
        
        FBRequest* friendsRequest = [FBRequest requestForMyFriends];
        [friendsRequest startWithCompletionHandler: ^(FBRequestConnection *connection,
                                                      NSDictionary* result,
                                                      NSError *error) {
            
            // result will contain an array with your user's friends in the "data" key
            NSArray *friendObjects = [result objectForKey:@"data"];
            NSMutableArray *friendIDs = [NSMutableArray arrayWithCapacity:friendObjects.count];
            
            // Create a list of friends' Facebook IDs
            for (NSDictionary *friendObject in friendObjects) {
                [friendIDs addObject:[friendObject objectForKey:@"id"]];
            }
            
            //Use parse CloudCode to put the fbIds of friends that also use app into an array
            [PFCloud callFunctionInBackground:@"parseFriends"
                                withParameters:@{@"friendIDs": friendIDs}
                                block:^(NSArray *friends, NSError *error){
                if (!error) {
                    parseFriends = [[NSMutableArray alloc] init];
                    
                    for (PFUser *user in friends) {
                        [parseFriends addObject:user[@"fbId"]];
                    }
                    NSLog(@"%@", parseFriends);
                }
            }];
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
                    [[PFUser currentUser] setObject:[NSNumber numberWithBool:NO] forKey:@"drving"];
                    [[PFUser currentUser] saveInBackground];
                    
                    [[PFInstallation currentInstallation] setObject:[result objectForKey:@"id"]
                                                             forKey:@"fbId"];
                    [[PFInstallation currentInstallation] saveInBackground];
                }
                else{
                    NSLog(@"%@", error);
                }
            }];

            findMatchingFriends();
            NSLog(@"User signed up and logged in through Facebook!");
            
        } else {
            findMatchingFriends();
            NSLog(@"User logged in through Facebook!");
        }
    }];
    
    //Set driving button title
    if ([[[PFUser currentUser] objectForKey:@"driving"] boolValue] == YES)
        [self.drivingButton setTitle:NSLocalizedString(@"isDriving", nil) forState:UIControlStateNormal];
    else
        [self.drivingButton setTitle:NSLocalizedString(@"notDriving", nil) forState:UIControlStateNormal];
}

- (IBAction)changeDriving:(id)sender {
    
    if ([[[PFUser currentUser] objectForKey:@"driving"] boolValue] == YES){
        [self.drivingButton setTitle:NSLocalizedString(@"notDriving", nil) forState:UIControlStateNormal];
        
        [[PFUser currentUser] setObject:[NSNumber numberWithBool:NO]
                                 forKey:@"driving"];
        
        // Find devices associated with these users
//        PFQuery *pushQuery = [PFInstallation query];
//        [pushQuery whereKey:@"User" matchesQuery:friendsQuery];
        
        // Send push notification to query
//        [PFPush sendPushMessageToQueryInBackground:pushQuery
//                                       withMessage:@"Hello World!"];
        
    } else{
        [self.drivingButton setTitle:NSLocalizedString(@"isDriving", nil) forState:UIControlStateNormal];
        [[PFUser currentUser] setObject:[NSNumber numberWithBool:YES]
                                 forKey:@"driving"];
        
        // Find devices associated with these users
        PFQuery *pushQuery = [PFInstallation query];
        [pushQuery whereKey:@"fbId" containedIn:parseFriends];
        
        // Send push notification to query
        NSDictionary *messageData = [NSDictionary dictionaryWithObjectsAndKeys:
            @"Don't text me! I'm driving!", @"alert",
            [PFUser currentUser].username, @"title",
            @"Increment", @"badge",
            nil];
        
        [PFPush sendPushDataToQueryInBackground:pushQuery
                                       withData:messageData];
        
    }
    [[PFUser currentUser] saveInBackground];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
