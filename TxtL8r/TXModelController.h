//
//  TXModelController.h
//  TxtL8r
//
//  Created by Bogdan Vitoc on 2/20/14.
//  Copyright (c) 2014 Bogdan Vitoc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TXDataViewController;

@interface TXModelController : NSObject <UIPageViewControllerDataSource>

- (TXDataViewController *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard;
- (NSUInteger)indexOfViewController:(TXDataViewController *)viewController;

@end
