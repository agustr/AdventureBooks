#import "Book.h"
#import "Page.h"

@implementation Book

-(id)initWithBookFolderURL: (NSURL *) bookFolderUrl {

    if (self=[super init]) {
        
        self.bookUrl = bookFolderUrl;
        
        //if the URL is valid return initialized book.
        //if the URL is not valid return nil.
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSArray *folderContents = [fileManager contentsOfDirectoryAtURL:bookFolderUrl includingPropertiesForKeys:nil options:0 error:nil];
        
        //Set the title of the book.
        self.title = bookFolderUrl.lastPathComponent;
        
        //Set the icon for the book
        NSURL *tmpurl = [bookFolderUrl URLByAppendingPathComponent:@"icon.jpg"];
        if ([tmpurl checkResourceIsReachableAndReturnError:nil]) {
            self.icon = tmpurl;
        }
        
        //all the files that contain the word audio
        NSPredicate *fltr = [NSPredicate predicateWithFormat:@"lastPathComponent contains 'audio'"];
        NSArray *pageAudioURLs = [folderContents filteredArrayUsingPredicate:fltr];
        pageAudioURLs = [pageAudioURLs sortedArrayUsingSelector:@selector(lastPathComponent)];
        pageAudioURLs = [pageAudioURLs sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            return [[obj1 lastPathComponent] compare:[obj2 lastPathComponent] options:NSNumericSearch];
        }];
        
        //all the files that contain the word image
        fltr = [NSPredicate predicateWithFormat:@"lastPathComponent contains 'image'"];
        NSArray *pageImageURLs = [folderContents filteredArrayUsingPredicate:fltr];
        pageImageURLs = [pageImageURLs sortedArrayUsingSelector:@selector(lastPathComponent)];
        pageImageURLs = [[pageImageURLs reverseObjectEnumerator] allObjects];
        pageImageURLs = [pageImageURLs sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            return [[obj1 lastPathComponent] compare:[obj2 lastPathComponent] options:NSNumericSearch];
        }];

        //all the files that contain the word text
        fltr = [NSPredicate predicateWithFormat:@"lastPathComponent contains 'text'"];
        NSArray *pageTextURLs = [folderContents filteredArrayUsingPredicate:fltr];
        pageTextURLs = [pageTextURLs sortedArrayUsingSelector:@selector(lastPathComponent)];
                         
        pageTextURLs = [pageTextURLs sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            return [[obj1 lastPathComponent] compare:[obj2 lastPathComponent] options:NSNumericSearch];
        }];
        
        //create all the pages of the book
        //first check if there are as many images as audio
        //if ther is not there is something wrong with the book
        int numberOfPages =(int) MAX( MAX(pageImageURLs.count, pageAudioURLs.count), pageTextURLs.count);
        
        for (int iterator=0; iterator<numberOfPages; iterator++) {
            NSURL *imageURL = iterator < pageImageURLs.count ? [pageImageURLs objectAtIndex:iterator] : nil;
            NSURL *audioURL = iterator < pageAudioURLs.count ? [pageAudioURLs objectAtIndex:iterator] : nil;
            NSURL *textURL = iterator < pageTextURLs.count ? [pageTextURLs objectAtIndex:iterator] : nil;
            
            Page *tmpPage = [[Page alloc]
                            initWithImageURL:imageURL
                            AudioURL:audioURL
                            andTextURL:textURL];
            [self.pages addObject:tmpPage];
        }
        
        //Get the cover URL and if that does not exist use the first page instead
        tmpurl = [bookFolderUrl URLByAppendingPathComponent:@"cover.jpg"];
        if ([tmpurl checkResourceIsReachableAndReturnError:nil]) {
            // there is no cover.jpg
            // use the first page in its stead
            self.coverURL = [pageImageURLs objectAtIndex:0];
        }else{
            // set the icon reference.
            self.coverURL = tmpurl;
        }
        
        
        return self;
    }
    else{
        return nil;
    }
}



@synthesize pages = _pages;

-(NSMutableArray *) pages{
    if (!_pages) {
        _pages = [[NSMutableArray alloc] init];
    }
    return _pages;
}

@end
