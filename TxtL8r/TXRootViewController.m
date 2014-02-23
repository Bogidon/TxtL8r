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
    
    PFObject *testObject = [PFObject objectWithClassName:@"TestObject"];
    testObject[@"foo"] = @"bar";
    [testObject saveInBackground];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
