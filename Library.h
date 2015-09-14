//
//  Library.h
//  AdventureBooks
//
//  Created by Agust Rafnsson on 18/08/14.
//  Copyright (c) 2014 Agust Rafnsson. All rights reserved.
//
//  this object represents the library for the app.
//  localLibraryUrl is the folder in wich all the books are stored.
//    This could theoretically be an array pointing to many locations but for now only this one.
//
//  books is an array containing all the books.

#import <Foundation/Foundation.h>
#import "Book.h"

@interface Library : NSObject

@property (nonatomic,retain, readonly) NSURL *libraryUrl;

@property (nonatomic,retain, readonly) NSMutableArray *books;

-(id) initWithLibraryFolderUrl:(NSURL*) LibraryFolderURL;
-(BOOL)addLibraryUrl: (NSURL*)libraryURL;
-(BOOL) deleteBook: (Book*) delBook;

@end


