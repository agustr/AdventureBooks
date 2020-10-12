//
//  Library.m
//  AdventureBooks
//
//  Created by Agust Rafnsson on 18/08/14.
//  Copyright (c) 2014 Agust Rafnsson. All rights reserved.
//

#import "Library.h"
#import "Book.h"

@interface Library()

@property (nonatomic,retain, readwrite) NSMutableArray *books;
@property (nonatomic,retain,readwrite) NSMutableArray *libraryUrls;  //all the floders where stories are stored

@end

@implementation Library

-(id)init{
    return nil;
}

-(BOOL) deleteBook: (Book*) delBook{
    NSError* err = nil;
    BOOL result = [[NSFileManager defaultManager] removeItemAtURL:delBook.bookUrl error:&err];
    
    NSLog(@"The following book has been deleted %@",delBook.title);

    [self getBooks];
    
    return result;
}

-(id) initWithLibraryFolderUrl:(NSURL*) LibraryFolderURL{
    
    if (self = [super init]) {
        self.books = [[NSMutableArray alloc] init];
        [self addLibraryUrl: LibraryFolderURL];
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
        //NSLog(@"These are the directories %@", bookFolders);
        for (NSURL *bookFolderUrl in bookFolders) {
            
            //if the URLs in the array are to books create the book and insert it into the books array
            Book *someBook = [[Book alloc] initWithBookFolderURL:bookFolderUrl];
            if (someBook) {
                [self.books addObject:someBook];
            }

            NSLog(@"how many books in the library so far: %tu", self.books.count);
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


