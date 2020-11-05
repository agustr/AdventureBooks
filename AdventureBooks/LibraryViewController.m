#import "LibraryViewController.h"
#import "Library.h"
#import "BookViewController.h"
#import <StoreKit/StoreKit.h>



@interface LibraryViewController () <UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *libraryList;
@property (strong, nonatomic) Library *library;

@end

@implementation LibraryViewController

// Override to support conditional editing of the table view.
// This only needs to be implemented if you are going to be returning NO
// for some items. By default, all items are editable.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return YES;
    }
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //a row has been selected.
    if (indexPath.section == 0) {
        //This is a local story that has been selected and is dealt with in a segue
    }
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
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
        myImage = [[UIImage alloc] initWithContentsOfFile:myProductIcon.path];
    }
    else{
        //check online for image
        NSData *myData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@/icon.jpg",BASEWEBURL,myProduct.productIdentifier]]];
        if (myData) {
            NSURL *myProductDir = myProductIcon;
            [myFM createDirectoryAtURL:[myProductDir URLByDeletingLastPathComponent] withIntermediateDirectories:YES attributes:nil error:nil];
            
            [myFM createFileAtPath:myProductIcon.path contents:myData attributes:nil];
            //[myData writeToFile:myProductIcon.path atomically:YES];
        }
        myImage = [[UIImage alloc] initWithData:myData];
    }
    return myImage;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSArray * names = [NSArray arrayWithObjects:@"Sögur",@"Verslun", nil];
    return [names objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.library.books.count;
    }
    else{
        return 0;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (IBAction)dictateModeButtonPressed:(id)sender {
    if ([sender isKindOfClass:[UIButton class]]){
        UIButton* senderButton = (UIButton*) sender;
        senderButton.selected = !senderButton.selected;
        if (senderButton.selected) {
            [senderButton setImage:[[UIImage imageNamed: @"mic.fill"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState: UIControlStateSelected];
            [senderButton.imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            senderButton.tintColor = UIColor.redColor;
        } else {
            senderButton.tintColor = UIColor.blackColor;
        }
    }
}

- (IBAction)settingButtonPressed:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"iPhone" bundle:nil];
    UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"settingsViewController"];
    //vc.view.backgroundColor = [UIColor clearColor];
    self.modalPresentationStyle = UIModalPresentationCurrentContext;
    self.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:vc animated:YES completion:Nil];
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
    
    self.library = [[Library alloc] initWithLibraryFolderUrl:bundeledStoriesURL];
    [self.library addLibraryUrl:[[[[NSFileManager defaultManager] URLsForDirectory:NSLibraryDirectory inDomains:NSUserDomainMask]objectAtIndex:0 ] URLByAppendingPathComponent:@"stories"]];
    
    // Do any additional setup after loading the view.
    [self.libraryList setDataSource:self];
    [self.libraryList setDelegate:self];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshTableView)
                                                 name:@"LibraryChanged"
                                               object:nil];
}

-(void)refreshTableView{
    [self.libraryList reloadData];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        UITableViewCell *cell = (UITableViewCell*) sender;
        
        BookViewController *destination = segue.destinationViewController;
        
        Book* selectedBook = [self.library.books objectAtIndex:cell.tag];
        
        destination.book = selectedBook;
    }
}

@end
