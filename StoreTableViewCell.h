//
//  StoreTableViewCell.h
//  AdventureBooks
//
//  Created by Agust Rafnsson on 20/08/15.
//  Copyright (c) 2015 Agust Rafnsson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>

@interface StoreTableViewCell : UITableViewCell



-(void)listenForDownloadOf:(NSString*)productIdentifier;
- (void)showProgress:(SKDownload*) notification;
@end
