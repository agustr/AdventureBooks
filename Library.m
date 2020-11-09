#import "Library.h"
#import "Book.h"

@interface Library()

@property (nonatomic, retain, readwrite) NSMutableArray *books;
@property (nonatomic, retain, readwrite) NSMutableArray *libraryUrls;  //all the floders where stories are stored
@property (nonatomic, retain, readwrite) NSString *name;

@end

@implementation Library

-(id)init{
    return nil;
}

-(BOOL) deleteBook: (Book*) delBook {
    NSError* err = nil;
    BOOL result = [[NSFileManager defaultManager] removeItemAtURL:delBook.bookUrl error:&err];
    
    [self getBooks];
    
    return result;
}

-(id) initWithLibraryFolderUrl:(NSURL*) LibraryFolderURL andName: (NSString*) name {
    
    if (self = [super init]) {
        self.books = [[NSMutableArray alloc] init];
        [self addLibraryUrl: LibraryFolderURL];
        self.name = name;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getBooks)
                                                 name:@"DownloadFinished"
                                               object:nil];
    return self;
}

-(int)getBooks{
    //get all the books that are in the libraries folder
    //put those books in the books array
    NSArray *bookFolders;
    NSFileManager *fm = [NSFileManager defaultManager];
    
    [self.books removeAllObjects];
    
    for (NSURL* libURL in self.libraryUrls) {
        bookFolders = [fm contentsOfDirectoryAtURL:libURL includingPropertiesForKeys:nil options:NSDirectoryEnumerationSkipsHiddenFiles error:nil];
        for (NSURL *bookFolderUrl in bookFolders) {
            
            Book *someBook = [[Book alloc] initWithBookFolderURL:bookFolderUrl];
            if (someBook) {
                [self.books addObject:someBook];
            }
        }
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LibraryChanged" object:nil];
    return 0;
}

-(BOOL)addLibraryUrl: (NSURL*)libraryURL{
    
    if (!self.libraryUrls) {
        self.libraryUrls = [[NSMutableArray alloc]init];
    }
    
    [self.libraryUrls addObject:libraryURL];
    [self getBooks];
    return TRUE;
}

@end


