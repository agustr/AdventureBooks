#import "LibraryViewController.h"
#import "Library.h"
#import "BookViewController.h"
#import <StoreKit/StoreKit.h>



@interface LibraryViewController () <UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) Library *bundledLibrary;
@property (strong, nonatomic) Library *userLibrary;
@property (strong, nonatomic) NSMutableArray *libraries;
@property (strong, nonatomic) IBOutlet UITableView *libraryListView;
@property (weak, nonatomic) IBOutlet UIButton *dictateButton;

@end

#define BASEWEBURL @"http://www.aevintyri.com/products/"
#define LOCALPRODUCTSFOLDER @"products/"
#define USERSSTORIES @"userstories/"

@implementation LibraryViewController

- (NSMutableArray*)libraries
{
    if (!_libraries) {
        _libraries = [[NSMutableArray alloc] init];
    }
    return _libraries;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Book *book = [self bookAtIndexPath:indexPath];
    if ([self.dictateButton isSelected] && ![[NSFileManager defaultManager] isWritableFileAtPath:book.bookUrl.path]){
        // we are attempting to edit an item but it is stored in a write protected area.
        // copy the item and rename.
        if (![[NSFileManager defaultManager] fileExistsAtPath:[LibraryViewController userStoriesURL].path] ) {
            // user folder does not exist
            NSError *err;
            if (![[NSFileManager defaultManager] createDirectoryAtPath:[LibraryViewController userStoriesURL].path withIntermediateDirectories:YES attributes:nil error:&err]){
                NSLog(@"could not create folder: %@", err);
            }
        }
        NSURL *newBookURL = [[LibraryViewController userStoriesURL] URLByAppendingPathComponent:book.title];
        NSError *err;
        if ([[NSFileManager defaultManager] copyItemAtURL:book.bookUrl toURL:newBookURL error:&err]) {
            NSArray *folderContents = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:newBookURL includingPropertiesForKeys:nil options:NSDirectoryEnumerationSkipsHiddenFiles error:&err];
            for (NSURL *url in folderContents) {
                if ([[url lastPathComponent] containsString:@"audio"]){
                    NSLog(@"audiofile: %@", url);
                    [[NSFileManager defaultManager] removeItemAtURL:url error:nil];
                }
            }
            
            [self.userLibrary getBooks];
            book = [[Book alloc] initWithBookFolderURL:newBookURL];
            
        } else {
            NSLog(@"could not copy the book because of error: %@", err);
        }

    }
    BookViewController *bookVC = [[BookViewController alloc] init];
    bookVC.book = book;
    [self.navigationController pushViewController:bookVC animated:YES];
}



- (Book *) bookAtIndexPath: (NSIndexPath *) indexPath {
    Library *selectedLibrary = [self.libraries objectAtIndex:indexPath.section];
    Book *selectedBook = [selectedLibrary.books objectAtIndex:indexPath.item];
    return selectedBook;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.bundledLibrary deleteBook:[self.bundledLibrary.books objectAtIndex:indexPath.row]];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Book *book = [self bookAtIndexPath:indexPath];
    if (book) {
        UITableViewCell *bookCell = [self.libraryListView dequeueReusableCellWithIdentifier:@"bookCell"];
        bookCell.textLabel.text = book.title;
        bookCell.detailTextLabel.text = book.author;
        bookCell.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:book.icon]];
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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    Library *library = self.libraries[section];
    return library.title;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    Library *library = self.libraries[section];
    return library.books.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSLog(@"number of libraries: %lu", (unsigned long)self.libraries.count);
    return self.libraries.count;
}

- (IBAction)dictateModeButtonPressed:(id)sender {
    self.dictateButton.selected = !self.dictateButton.selected;
    if (self.dictateButton.selected) {
//        self.dictateButton.tintColor = UIColor.redColor;
    } else {
//        self.dictateButton.tintColor = UIColor.blackColor;
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

+ (NSURL *) userStoriesURL {
    NSURL *userStoriesURL = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask].firstObject;
    userStoriesURL = [userStoriesURL URLByAppendingPathComponent: @"userstories"];
    return userStoriesURL;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.dictateButton setImage:[UIImage imageNamed:@"mic"] forState:UIControlStateNormal];
    [self.dictateButton setImage:[[UIImage imageNamed:@"mic.fill"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateSelected];
    [self.dictateButton setTintColor: UIColor.redColor];
    
    NSURL *bundeledStoriesURL = [[NSBundle mainBundle] URLForResource:@"BundeledStories" withExtension:nil];
    NSLog(@"bundeled stories : %@", bundeledStoriesURL.path);
    self.bundledLibrary = [[Library alloc] initWithLibraryFolderUrl: bundeledStoriesURL andTitle:@"Ævintýri"];
    [self.bundledLibrary addLibraryUrl:[[[[NSFileManager defaultManager] URLsForDirectory:NSLibraryDirectory inDomains:NSUserDomainMask]objectAtIndex:0 ] URLByAppendingPathComponent:@"stories"]];
    [self.libraries addObject: self.bundledLibrary];
    
    NSURL * userStoriesURL = [LibraryViewController userStoriesURL];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath: userStoriesURL.path]) {
        NSLog(@"there is no path %@", userStoriesURL.path);
    }
    
    NSLog(@"Searchpaths for documents in domain: \n %@", userStoriesURL);
    self.userLibrary = [[Library alloc] initWithLibraryFolderUrl:userStoriesURL andTitle:@"Mínar Sögur"];
    [self.libraries addObject: self.userLibrary];
    
    
    [self.libraryListView setDataSource:self];
    [self.libraryListView setDelegate:self];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshTableView)
                                                 name:@"LibraryChanged"
                                               object:nil];
}

-(void)refreshTableView{
    [self.libraryListView reloadData];
}

@end
