//
//  LibraryViewController.m
//  AdventureBooks
//
//  Created by Agust Rafnsson on 18/08/14.
//  Copyright (c) 2014 Agust Rafnsson. All rights reserved.
//

#import "LibraryViewController.h"
#import "Library.h"
#import "BookViewController.h"
#import <StoreKit/StoreKit.h>
#import "StoryIAPHelper.h"
#import "StoreTableViewCell.h"


@interface LibraryViewController () <UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *libraryList;
@property (strong, nonatomic) Library *library;
@property (strong, nonatomic) NSArray *products;

@end

@implementation LibraryViewController

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //a row has been selected.
    if (indexPath.section == 0) {
        //This is a local story that has been selected and is dealt with in a segue
    }
    else{
        //Subject has chosen to buy a story.
        [[StoryIAPHelper sharedInstance] buyProduct: [self.products objectAtIndex:indexPath.row]];
    }
}
- (IBAction)restoreButton:(id)sender {
    [[StoryIAPHelper sharedInstance] restoreCompletedTransactions];
}

// Override to support conditional editing of the table view.
// This only needs to be implemented if you are going to be returning NO
// for some items. By default, all items are editable.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return YES;
    }
    return NO;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSLog(@"you have chosen to delete story %@", indexPath);
        [self.library deleteBook:[self.library.books objectAtIndex:indexPath.row]];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.section==0) {
        UITableViewCell *bookCell = [self.libraryList dequeueReusableCellWithIdentifier:@"bookCell"];
        Book *currentbook = [self.library.books objectAtIndex:indexPath.row];
        bookCell.textLabel.text = currentbook.title;
        bookCell.detailTextLabel.text = currentbook.author;
        bookCell.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:currentbook.icon]];
        //bookCell.imageView.contentMode = UIViewContentModeCenter ;
        CGRect imageFrame = bookCell.imageView.frame;
        imageFrame.size.height = bookCell.frame.size.height -2;
        imageFrame.size.width = bookCell.frame.size.height -2;
        bookCell.tag = indexPath.row;
        bookCell.imageView.frame = imageFrame;
        bookCell.imageView.layer.cornerRadius = 10;
        bookCell.imageView.layer.borderWidth = 1;
        return bookCell;
    }
    if (indexPath.section==1) {
        
        //get a cell
        StoreTableViewCell *storeCell = [self.libraryList dequeueReusableCellWithIdentifier:@"StoreBookCell"];
        
        //get current product
        SKProduct* currentProduct = [self.products objectAtIndex:indexPath.row];
        
        //post product name
        storeCell.textLabel.text = currentProduct.localizedTitle;
        
        //get price
        NSNumberFormatter *priceFormatter = [[NSNumberFormatter alloc] init];
        [priceFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
        [priceFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        [priceFormatter setLocale:currentProduct.priceLocale];
        storeCell.detailTextLabel.text = [priceFormatter stringFromNumber:currentProduct.price];
        
        [storeCell listenForDownloadOf:currentProduct.productIdentifier];
        
        
        //get the icon for the story
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            if ([self getProductsIcon:currentProduct]) {
                //NSLog(@"we have an image");
                UIImage *icon = [self getProductsIcon:currentProduct];
                if (icon) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (storeCell.tag == indexPath.row) {
                            [storeCell.imageView setImage:icon];
                            [storeCell setNeedsLayout];
                        }
                    });
                }
            }
        });
        
        BOOL bought = [[StoryIAPHelper sharedInstance] productPurchased:currentProduct.productIdentifier];
        
        if (bought) {
            storeCell.textLabel.textColor = [UIColor greenColor];
            storeCell.detailTextLabel.text = @"press to restore";
        }
        
        storeCell.tag = indexPath.row;
        //storeCell.imageView.frame = imageFrame;
        storeCell.imageView.layer.cornerRadius = 10;
        storeCell.imageView.layer.borderWidth = 1;
        //[storeCell showProgress:YES];
        return storeCell;
    }
    return nil;
}

#define BASEWEBURL @"http://www.aevintyri.com/products/"
#define LOCALPRODUCTSFOLDER @"products/"

-(UIImage* )getProductsIcon:(SKProduct*) myProduct{
    
    NSFileManager *myFM = [[NSFileManager alloc]init];
    NSURL *myLibraryDir = [[myFM URLsForDirectory:NSLibraryDirectory inDomains:NSUserDomainMask]objectAtIndex:0 ];
    NSURL *myProductIcon = [[myLibraryDir URLByAppendingPathComponent:LOCALPRODUCTSFOLDER] URLByAppendingPathComponent:[NSString stringWithFormat:@"%@/icon.jpg",myProduct.productIdentifier]];
    UIImage * myImage;
    
    if ([myFM fileExistsAtPath:myProductIcon.path]) {
        //the icon exists locally. no need to check outside. return local image.
        NSLog(@"The icon exists locally at the path:%@\n\n\n\n\n\n",myProductIcon.path);
        myImage = [[UIImage alloc] initWithContentsOfFile:myProductIcon.path];
    }
    else{
        //check online for image
        NSLog(@"Try to fetch from web...");
        NSData *myData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@/icon.jpg",BASEWEBURL,myProduct.productIdentifier]]];
        if (myData) {
            NSURL *myProductDir = myProductIcon;
            [myFM createDirectoryAtURL:[myProductDir URLByDeletingLastPathComponent] withIntermediateDirectories:YES attributes:nil error:nil];
           
            [myFM createFileAtPath:myProductIcon.path contents:myData attributes:nil];
            //[myData writeToFile:myProductIcon.path atomically:YES];
        }
        else{
            NSLog(@"NO File Found ONline");
        }
        myImage = [[UIImage alloc] initWithData:myData];
    }
    NSLog(@"STOP checking for icon %@",myProduct.localizedTitle);
    return myImage;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSArray * names = [NSArray arrayWithObjects:@"Sögur",@"Verslun", nil];
    return [names objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"the number of cells in the tableview is: %tu", self.library.books.count);
    if (section==0) {
        NSLog(@"section zero set");
        return self.library.books.count;
    }
    if (section==1) {
        NSLog(@"section one set");
        return self.products.count;
    }
    else{
        return 0;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.products.count) {
        NSLog(@"two sections");
        return 2;
    }
    else{
        NSLog(@"One section");
        return 1;
    }
}

- (IBAction)settingButtonPressed:(id)sender {
    NSLog(@"settings button pressed");
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"iPhone" bundle:nil];
    UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"settingsViewController"];
    //vc.view.backgroundColor = [UIColor clearColor];
    self.modalPresentationStyle = UIModalPresentationCurrentContext;
    self.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:vc animated:YES completion:Nil];
}

-(void) getProducts {
    [[StoryIAPHelper sharedInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
        if (success) {
            self.products = products;
            NSLog(@"the number of products found were : %lu", (unsigned long)self.products.count);
            [self createStoreLibrary];
            dispatch_async(dispatch_get_main_queue(), ^(void){
                [self.libraryList reloadData];
            });
        }
    }];
}

-(void)createStoreLibrary{
    for (SKProduct *product in self.products) {
        NSLog(@"Found product: %@ %@ %0.2f",
              product.productIdentifier,
              product.localizedTitle,
              product.price.floatValue);
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSURL *bundeledStoriesURL = [[NSBundle mainBundle] URLForResource:@"BundeledStories" withExtension:nil];
    NSLog(@"this is the url for 'stories':%@", bundeledStoriesURL);
    
    self.library = [[Library alloc] initWithLibraryFolderUrl:bundeledStoriesURL];
    [self.library addLibraryUrl:[[[[NSFileManager defaultManager] URLsForDirectory:NSLibraryDirectory inDomains:NSUserDomainMask]objectAtIndex:0 ] URLByAppendingPathComponent:@"stories"]];
    
    // Do any additional setup after loading the view.
    [self.libraryList setDataSource:self];
    [self.libraryList setDelegate:self];
    [self getProducts];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshTableView)
                                                 name:@"LibraryChanged"
                                               object:nil];
}

-(void)refreshTableView{
    NSLog(@"Refresh table view function is called.");
    [self.libraryList reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        UITableViewCell *cell = (UITableViewCell*) sender;
        NSLog(@"the tag of the sender is %ld", (long)cell.tag);
        
        BookViewController *destination = segue.destinationViewController;
        
        Book* selectedBook = [self.library.books objectAtIndex:cell.tag];
        
        destination.book = selectedBook;
        
        NSLog(@"its a tableviewclass sending the segue");
    }
    NSLog(@"Segueing!");
    
    
}

@end
