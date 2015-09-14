//
//  Page.m
//  AdventureBooks
//
//  Created by Agust Rafnsson on 18/08/14.
//  Copyright (c) 2014 Agust Rafnsson. All rights reserved.
//

#import "Page.h"

@implementation Page

-(id)initWithImageURL:(NSURL*) imageURL AudioURL:(NSURL *) audioURL andTextURL:(NSURL *) textURL{
    self=[super init];
    if (self) {
        
        [self setimageURL:imageURL];
        [self setaudioURL:audioURL];
        [self settextURL:textURL];
        NSLog(@"imageurl:%@ \n audiourl: %@ \n texturl:%@",self.imageURL.path,self.audioURL.path, self.textURL.path);
        if ((self.imageURL!=nil) && (self.audioURL!=nil)) {
            NSLog(@"page init returns self");
            return self;
        }
        else{
            NSLog(@"page init returns nil");
            return nil;
        }
    }
    else{
        NSLog(@"page init returns nil");
        return nil;
    }
}

@synthesize textURL = _textURL;

-(void)settextURL:(NSURL *)textURL{
    NSLog(@"page settextURL called");
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
        NSLog(@"audioresource not reachable");
        _audioURL = nil;
        //return NO;
    }
    
    //check if the file is a jpg
    if (![[audioURL pathExtension]  isEqual: @"m4a"]) {
        NSLog(@"audio path extention is not m4a");
        _audioURL=nil;
        //return NO;
    }
    NSLog(@"the audio url is set to : %@", audioURL.path);
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
