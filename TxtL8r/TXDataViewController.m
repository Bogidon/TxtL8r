//
//  TXDataViewController.m
//  TxtL8r
//
//  Created by Bogdan Vitoc on 2/20/14.
//  Copyright (c) 2014 Bogdan Vitoc. All rights reserved.
//

#import "TXDataViewController.h"

@interface TXDataViewController ()

@end

@implementation TXDataViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.dataLabel.text = [self.dataObject description];
}

@end
