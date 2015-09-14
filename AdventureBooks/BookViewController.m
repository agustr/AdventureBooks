//
//  BookViewController.m
//  AdventureBooks
//
//  Created by Agust Rafnsson on 04/09/14.
//  Copyright (c) 2014 Agust Rafnsson. All rights reserved.
//

#import "BookViewController.h"


@interface BookViewController () <UIPageViewControllerDataSource>

@end

@implementation BookViewController 

@synthesize book;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (BookPageViewController *)viewControllerAtIndex:(NSUInteger)index
{
    // Return the data view controller for the given index.
    if (([self.book.pages count] == 0) ||
        (index >= [self.book.pages count])) {
        return nil;
    }
    
    UIStoryboard *storyboard =
    [UIStoryboard storyboardWithName:@"iPhone"
                              bundle:[NSBundle mainBundle]];
    
    BookPageViewController *dataViewController =
    [storyboard
     instantiateViewControllerWithIdentifier:@"pageView2"];
    
    dataViewController.myPage = self.book.pages[index];
    return dataViewController;
}

- (NSUInteger)indexOfViewController:(BookPageViewController *)viewController
{
    return [self.book.pages indexOfObject:viewController.myPage];
}

- (UIViewController *)pageViewController:
(UIPageViewController *)pageViewController viewControllerBeforeViewController:
(UIViewController *)viewController
{
    NSLog(@"before viewcontroller");
    NSUInteger index = [self indexOfViewController:
                        (BookPageViewController *)viewController];
    if ((index == 0) || (index == NSNotFound)) {
        NSLog(@"returns no controller.");
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSLog(@"- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController");
    NSUInteger index = [self indexOfViewController:
                        (BookPageViewController *)viewController];
    if (index == NSNotFound) {
        NSLog(@"returns no controller.");
        return nil;
    }
    
    index++;
    if (index == [self.book.pages count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}
- (void)turnToPageAfterViewController:(UIViewController *)viewController{
    
    UIViewController* dataViewController = [self pageViewController:(UIPageViewController*)self viewControllerAfterViewController:viewController];
    if (dataViewController) {
        
        NSMutableArray* viewControllers = [[NSMutableArray alloc]init];
        [viewControllers addObject:dataViewController];
        
        [self setViewControllers:viewControllers
                       direction:UIPageViewControllerNavigationDirectionForward
                        animated:YES
                      completion:nil];
    }
}
- (IBAction)singleTapGesture:(id)sender {
    NSLog(@"single tap recognized");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   // NSLog(@"the path is: %@", self.book.bookUrl.path);
    NSLog(@"self is datasource");
    self.dataSource = self;
    
    UIStoryboard *storyboard =[UIStoryboard storyboardWithName:@"iPhone"
                                                        bundle:[NSBundle mainBundle]];
    
    BookPageViewController *dataViewController =[storyboard instantiateViewControllerWithIdentifier:@"pageView2"];
    
    NSLog(@"how many pages in the book: %lu",(unsigned long)[self.book.pages count]);
    Page* firsPage = [self.book.pages objectAtIndex:0];
    NSLog(@"the first pages image url is: %@", firsPage.imageURL.path);
    dataViewController.myPage = self.book.pages[0];
    
    NSMutableArray* viewControllers = [[NSMutableArray alloc]init];
    [viewControllers addObject:dataViewController];
    
    [self setViewControllers:viewControllers
                   direction:UIPageViewControllerNavigationDirectionForward
                    animated:NO
                  completion:nil];
    
    //self.view.gestureRecognizers = self.pageViewController.gestureRecognizers;
    
    // Find the tap gesture recognizer so we can remove it!
    UIGestureRecognizer* tapRecognizer = nil;
    for (UIGestureRecognizer* recognizer in self.gestureRecognizers) {
        if ( [recognizer isKindOfClass:[UITapGestureRecognizer class]] ) {
            tapRecognizer = recognizer;
            break;
        }
    }
    if ( tapRecognizer ) {
        [self.view removeGestureRecognizer:tapRecognizer];
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];


}

-(void)dismissSelf{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)tapGestureGrabbed{
    NSLog(@"tap taken");
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
