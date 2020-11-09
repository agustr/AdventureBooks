#import <Foundation/Foundation.h>
#import "Book.h"

@interface Library : NSObject

@property (nonatomic,retain) NSString *title;
@property (nonatomic,retain, readonly) NSURL *libraryUrl;
@property (nonatomic,retain, readonly) NSMutableArray *books;

-(id) initWithLibraryFolderUrl:(NSURL*) LibraryFolderURL andName: (NSString*) name;
-(BOOL)addLibraryUrl: (NSURL*)libraryURL;
-(BOOL) deleteBook: (Book*) delBook;

@end


