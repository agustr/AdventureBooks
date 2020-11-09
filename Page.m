#import "Page.h"

@implementation Page

-(id)initWithImageURL:(NSURL*) imageURL AudioURL:(NSURL *) audioURL andTextURL:(NSURL *) textURL{
    self=[super init];
    if (self) {
        
        [self setimageURL:imageURL];
        [self setaudioURL:audioURL];
        [self settextURL:textURL];

        if ((self.imageURL!=nil) && (self.audioURL!=nil)) {
            return self;
        }
        else{
            return nil;
        }
    }
    else{
        return nil;
    }
}

@synthesize textURL = _textURL;

-(void)settextURL:(NSURL *)textURL{
    //check if the file exists
    if (![textURL checkResourceIsReachableAndReturnError:nil]) {
        // if the url is not reachable return no and set the url to nil
        _textURL = nil;
        //return NO;
    }
    
    //check if the file is a txt
    if (![[textURL pathExtension]  isEqual: @"txt"]) {
        _textURL=nil;
        //return NO;
    }
    
    _textURL = textURL;
    //return YES;
}

@synthesize audioURL = _audioURL;

-(void)setaudioURL:(NSURL *)audioURL{
    
    //check if the file exists
    if (![audioURL checkResourceIsReachableAndReturnError:nil]) {
        // if the url is not reachable return no and set the url to nil
        _audioURL = nil;
        //return NO;
    }
    
    //check if the file is a jpg
    if (![[audioURL pathExtension]  isEqual: @"m4a"]) {
        _audioURL=nil;
        //return NO;
    }
    _audioURL = audioURL;
    //return YES;
}

@synthesize imageURL = _imageURL;

-(void)setimageURL:(NSURL *)imageURL{
    
    //check if the file exists
    if (![imageURL checkResourceIsReachableAndReturnError:nil]) {
        // if the url is not reachable return no and set the url to nil
        _imageURL = nil;
        //return NO;
    }
    
    //check if the file is a jpg
    if (![[imageURL pathExtension]  isEqual: @"jpg"]) {
        _imageURL=nil;
        //return NO;
    }
    
    _imageURL = imageURL;
    //return YES;
}


@end
