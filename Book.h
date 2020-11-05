#import <Foundation/Foundation.h>

@interface Book : NSObject

@property (nonatomic, retain) NSURL *icon;
@property (nonatomic, retain) NSURL *bookUrl;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSURL *coverURL;

@property (nonatomic, retain) NSString *author;
@property (nonatomic, retain) NSString *narrator;
@property (nonatomic, retain) NSString *illustrator;
@property (nonatomic, retain) NSString *about;
@property (nonatomic, retain) NSString *strExcerpt;
@property (nonatomic, retain) NSURL *audioExcerpt;
@property (nonatomic, retain) NSMutableArray *pages;


-(id) initWithBookFolderURL: (NSURL *) bookFolderUrl;


@end

