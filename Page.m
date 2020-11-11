#import "Page.h"

@implementation Page

-(id)initWithImageURL:(NSURL*) imageURL AudioURL:(NSURL *) audioURL andTextURL:(NSURL *) textURL{
    self = [super init];
    if (self) {
        [self setimageURL:imageURL];
        [self setaudioURL:audioURL];
        [self settextURL:textURL];

        return self;
    }
    else{
        return nil;
    }
}

@synthesize textURL = _textURL;

-(void)settextURL:(NSURL *)textURL {
    if (![textURL checkResourceIsReachableAndReturnError:nil]) {
        _textURL = nil;
    }
    if (![[textURL pathExtension]  isEqual: @"txt"]) {
        _textURL=nil;
    }
    _textURL = textURL;
}

@synthesize audioURL = _audioURL;

-(void)setaudioURL:(NSURL *)audioURL{
    if (![audioURL checkResourceIsReachableAndReturnError:nil]) {
        _audioURL = nil;
    }
    
    if (![[audioURL pathExtension]  isEqual: @"m4a"]) {
        _audioURL=nil;
    }
    _audioURL = audioURL;
}

@synthesize imageURL = _imageURL;

-(void)setimageURL:(NSURL *)imageURL{
    if (![imageURL checkResourceIsReachableAndReturnError:nil]) {
        _imageURL = nil;
    }
    if (![[imageURL pathExtension]  isEqual: @"jpg"]) {
        _imageURL=nil;
    }
    _imageURL = imageURL;
}


@end
