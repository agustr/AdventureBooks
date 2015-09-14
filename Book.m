//
//  Book.m
//  AdventureBooks
//
//  Created by Agust Rafnsson on 18/08/14.
//  Copyright (c) 2014 Agust Rafnsson. All rights reserved.
//

#import "Book.h"
#import "Page.h"

@implementation Book

-(id)initWithBookFolderURL: (NSURL *) bookFolderUrl {
    
    NSLog(@"The book foler url is a reachable resource? - %d", [bookFolderUrl checkResourceIsReachableAndReturnError:nil]);

    if (self=[super init]) {
        
        self.bookUrl = bookFolderUrl;
        
        //if the URL is valid return initialized book.
        //if the URL is not valid return nil.
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSArray *folderContents = [fileManager contentsOfDirectoryAtURL:bookFolderUrl includingPropertiesForKeys:nil options:0 error:nil];
        
        //Set the title of the book.
        self.title = bookFolderUrl.lastPathComponent;
        NSLog(@"The book title is: %@", self.title);
        
        //Set the icon for the book
        NSURL *tmpurl = [bookFolderUrl URLByAppendingPathComponent:@"icon.jpg"];
        if ([tmpurl checkResourceIsReachableAndReturnError:nil]) {
            // there is no icon.jpg
            NSLog(@"there seems not to be an icon");
            self.icon = tmpurl;
        }else{
            // set the icon reference.
            NSLog(@"the icons name is : %@", tmpurl);

        }
        
        //all the files that contain the word audio
        NSPredicate *fltr = [NSPredicate predicateWithFormat:@"lastPathComponent contains 'audio'"];
        NSArray *pageAudioURLs = [folderContents filteredArrayUsingPredicate:fltr];
        pageAudioURLs = [pageAudioURLs sortedArrayUsingSelector:@selector(lastPathComponent)];
        pageAudioURLs = [pageAudioURLs sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            return [[obj1 lastPathComponent] compare:[obj2 lastPathComponent] options:NSNumericSearch];
        }];
        NSLog(@"Audio Filenames:\n");
        for (NSURL *url in pageAudioURLs) {
            NSLog(@"%@ \n", url.lastPathComponent);
        }
        
        //all the files that contain the word image
        fltr = [NSPredicate predicateWithFormat:@"lastPathComponent contains 'image'"];
        NSArray *pageImageURLs = [folderContents filteredArrayUsingPredicate:fltr];
        pageImageURLs = [pageImageURLs sortedArrayUsingSelector:@selector(lastPathComponent)];
        pageImageURLs = [[pageImageURLs reverseObjectEnumerator] allObjects];
        pageImageURLs = [pageImageURLs sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            return [[obj1 lastPathComponent] compare:[obj2 lastPathComponent] options:NSNumericSearch];
        }];
                         
        NSLog(@"Image Filenames:\n");
        for (NSURL *url in pageImageURLs) {
            NSLog(@"%@ \n", url.lastPathComponent);
        }

        //all the files that contain the word text
        fltr = [NSPredicate predicateWithFormat:@"lastPathComponent contains 'text'"];
        NSArray *pageTextURLs = [folderContents filteredArrayUsingPredicate:fltr];
        pageTextURLs = [pageTextURLs sortedArrayUsingSelector:@selector(lastPathComponent)];
                         
        pageTextURLs = [pageTextURLs sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            return [[obj1 lastPathComponent] compare:[obj2 lastPathComponent] options:NSNumericSearch];
        }];
                        
        NSLog(@"Text Filenames:\n");
        for (NSURL *url in pageTextURLs) {
            NSLog(@"%@ \n", url.lastPathComponent);
        }
        
        //create all the pages of the book
        //first check if there are as many images as audio
        //if ther is not there is something wrong with the book
        if (pageImageURLs.count == pageAudioURLs.count && pageAudioURLs.count == pageTextURLs.count) {
            for (int iterator=0; iterator<pageImageURLs.count; iterator++) {
                NSLog(@"pages count: %lu\n iterator count: %d",(unsigned long)[self.pages count], iterator);
                NSLog(@"Pages with text files were made");
                Page *tmpPage =[[Page alloc]
                                initWithImageURL:[pageImageURLs objectAtIndex:iterator]
                                AudioURL:[pageAudioURLs objectAtIndex:iterator]
                                andTextURL:[pageTextURLs objectAtIndex:iterator]];
                NSLog(@"tmpPage.imageURL:%@",tmpPage.imageURL.path);
                [self.pages addObject:tmpPage];
            }
        }
        else if (pageImageURLs.count == pageAudioURLs.count){
            for (int iterator=0; iterator<pageImageURLs.count; iterator++) {
                NSLog(@"pages count: %lu\n iterator count: %d",(unsigned long)[self.pages count], iterator);
                Page *tmpPage =[[Page alloc]
                                initWithImageURL:[pageImageURLs objectAtIndex:iterator]
                                AudioURL:[pageAudioURLs objectAtIndex:iterator]
                                andTextURL:nil];
                 NSLog(@"tmpPage.imageURL:%@",tmpPage.imageURL.path);
                [self.pages addObject:tmpPage];
            }
        }
        else{
            return nil;
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
