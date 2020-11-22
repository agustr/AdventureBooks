#import "BookViewController.h"


@interface BookViewController () <UIPageViewControllerDataSource>

@end

@implementation BookViewController 

@synthesize book;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
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
    NSUInteger index = [self indexOfViewController:
                        (BookPageViewController *)viewController];
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:
                        (BookPageViewController *)viewController];
    if (index == NSNotFound) {
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.dataSource = self;
    
    UIStoryboard *storyboard =[UIStoryboard storyboardWithName:@"iPhone" bundle:[NSBundle mainBundle]];
    BookPageViewController *pageVC =[storyboard instantiateViewControllerWithIdentifier:@"pageView2"];
    
    pageVC.myPage = self.book.pages[0];
    
    NSMutableArray* viewControllers = [[NSMutableArray alloc]init];
    [viewControllers addObject:pageVC];
    
    [self setViewControllers:viewControllers
                   direction:UIPageViewControllerNavigationDirectionForward
                    animated:NO
                  completion:nil];
}

-(void)dismissSelf{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
