//
//  Page.h
//  AdventureBooks
//
//  Created by Agust Rafnsson on 18/08/14.
//  Copyright (c) 2014 Agust Rafnsson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Page : NSObject

@property (nonatomic, retain, readonly) NSURL *imageURL;
@property (nonatomic, retain, readonly) NSURL *audioURL;
@property (nonatomic, retain, readonly) NSURL *textURL;

-(id)initWithImageURL:(NSURL*) imageURL AudioURL:(NSURL *) audioURL andTextURL:(NSURL *) textURL;

@end
