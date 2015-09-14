//
//  PageViewController.h
//  AdventureBooks
//
//  Created by Agust Rafnsson on 05/09/14.
//  Copyright (c) 2014 Agust Rafnsson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVAudioPlayer.h>
#import "Page.h"

@interface BookPageViewController : UIViewController <AVAudioPlayerDelegate>
@property (nonatomic,retain) Page *myPage;


@end
