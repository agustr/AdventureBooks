//
//  BookViewController.h
//  AdventureBooks
//
//  Created by Agust Rafnsson on 04/09/14.
//  Copyright (c) 2014 Agust Rafnsson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookPageViewController.h"
#import "Book.h"

@interface BookViewController : UIPageViewController

@property (strong, nonatomic)  Book* book;

- (void)turnToPageAfterViewController:(UIViewController *)viewController;
-(void)dismissSelf;

@end
