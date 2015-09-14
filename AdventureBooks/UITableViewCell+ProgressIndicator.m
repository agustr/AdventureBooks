//
//  UITableViewCell+ProgressIndicator.m
//  AdventureBooks
//
//  Created by Agust Rafnsson on 19/08/15.
//  Copyright (c) 2015 Agust Rafnsson. All rights reserved.
//

/* UITableViewCell+ProgressIndicator.m - Show/hide a progress spinner on a table cell
 *
 * Copyright 2011 Last.fm Ltd.
 *   - Primarily authored by Sam Steele <sam@last.fm>
 *
 * This file is part of MobileLastFM.
 *
 * MobileLastFM is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * MobileLastFM is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with MobileLastFM.  If not, see <http://www.gnu.org/licenses/>.
 */

#import "UITableViewCell+ProgressIndicator.h"

@implementation UITableViewCell (ProgressIndicator)

- (void)showProgress:(BOOL)show {
    if(show) {
        UIProgressView *progress = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        
        if(self.accessoryView) {
            progress.frame = self.accessoryView.bounds;
        }
        progress.trackTintColor = [UIColor grayColor];
        progress.progress = 0;
        self.accessoryView = progress;
        
    }
    else {
        self.accessoryView = nil;
    }
}
-(void)listenForDownloadOf:(NSString *)productName{
    
}
@end