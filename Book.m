#import "Book.h"
#import "Ævintýri-swift.h"

@implementation Book

-(id)initWithBookFolderURL: (NSURL *) bookFolderUrl {

    if (self=[super init]) {
        
        self.bookUrl = bookFolderUrl;
        self.title = bookFolderUrl.lastPathComponent;
        
        NSArray *folderContents = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:bookFolderUrl includingPropertiesForKeys:nil options:0 error:nil];
    
        NSURL *tmpurl = [bookFolderUrl URLByAppendingPathComponent:@"icon.jpg"];
        if ([tmpurl checkResourceIsReachableAndReturnError:nil]) {
            self.icon = tmpurl;
        }
        
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
        

        int numberOfPages =(int) MAX( MAX(pageImageURLs.count, pageAudioURLs.count), pageTextURLs.count);
        
        for (int iterator=0; iterator<numberOfPages; iterator++) {
            NSURL *imageURL = iterator < pageImageURLs.count ? [pageImageURLs objectAtIndex:iterator] : nil;
            NSURL *audioURL = iterator < pageAudioURLs.count ? [pageAudioURLs objectAtIndex:iterator] : nil;
            NSURL *textURL = iterator < pageTextURLs.count ? [pageTextURLs objectAtIndex:iterator] : nil;
            
            Page *tmpPage = [[Page alloc] initWithImage:imageURL audio:audioURL text:textURL book:self];
            [self.pages addObject:tmpPage];
        }
        
        tmpurl = [bookFolderUrl URLByAppendingPathComponent:@"cover.jpg"];
        if ([tmpurl checkResourceIsReachableAndReturnError:nil]) {
            self.coverURL = [pageImageURLs objectAtIndex:0];
        }else{
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
