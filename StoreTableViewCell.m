#import "StoreTableViewCell.h"

@interface StoreTableViewCell ()

@property (nonatomic, strong) UIProgressView* progressView;

@end

@implementation StoreTableViewCell

@synthesize progressView = _progressView;

-(UIProgressView *)progressView
{
    NSLog(@"before instantiating progressview");
    if (!_progressView) {
        NSLog(@"instantiating progressview");
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
        _progressView.trackTintColor = [UIColor grayColor];
    }
    return _progressView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)showProgress:(NSNotification*) notification {
    
    if (!notification) {
        NSLog(@"no download received");
        return;
    }
    SKDownload* download;
    if ([notification.object isMemberOfClass:[SKDownload class]]) {
        download = notification.object;
    }
    
    //NSLog(@"the type of object found in the notification %@",  [download.object class] );
                                                                                   
    NSLog(@"\n notification received about the download of %@ \n progress is %f \n remaining time is %f", download.transaction.payment.productIdentifier, download.progress, download.timeRemaining);
    
    if(download) {
        
        if(self.accessoryView != self.progressView) {
            NSLog(@"placing the progressview");
            //self.progressView.frame = self.accessoryView.bounds;
            self.accessoryView = self.progressView;
        }

        [self.progressView setProgress:download.progress animated:YES];
        
        if (download.progress == 1) {
            self.accessoryView = nil;
            [self setAccessoryType:UITableViewCellAccessoryCheckmark];
        }
        
    }
    else {
        self.accessoryView = nil;
    }
}

-(void)listenForDownloadOf:(NSString*)productIdentifier{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if ([productIdentifier isEqual:@""]) {
        return;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showProgress:) name:productIdentifier object:nil];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
