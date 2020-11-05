#import <Foundation/Foundation.h>

@interface Page : NSObject

@property (nonatomic, retain, readonly) NSURL *imageURL;
@property (nonatomic, retain, readonly) NSURL *audioURL;
@property (nonatomic, retain, readonly) NSURL *textURL;

-(id)initWithImageURL:(NSURL*) imageURL AudioURL:(NSURL *) audioURL andTextURL:(NSURL *) textURL;

@end
