//
//  TXRootViewController.h
//  TxtL8r
//
//  Created by Bogdan Vitoc on 2/20/14.
//  Copyright (c) 2014 Bogdan Vitoc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TXRootViewController : UIViewController <UIPageViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *drivingButton;

- (IBAction)changeDriving:(id)sender;

@end
