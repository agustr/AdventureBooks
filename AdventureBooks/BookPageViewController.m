#import "BookPageViewController.h"
#import "BookViewController.h"
#import "Ævintýri-Swift.h"

@interface BookPageViewController ()

@property (weak, nonatomic) IBOutlet BookPageView *bookPageView;
@property (strong, nonatomic) AVAudioPlayer *pageAudio;
@property (strong, nonatomic) IBOutlet UIImageView *playButton;
@property (strong, nonatomic) IBOutlet UIImageView *playButtonImage;
@property (strong, nonatomic) IBOutlet UIButton *homeButton;
@property (strong, nonatomic) IBOutlet UIButton *settingsButton;
@property BOOL isShowingInterface;


@end

@implementation BookPageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self layoutPage];
    [self playAudio];
}

-(void)viewWillDisappear:(BOOL)animated{
    [self doVolumeFadeOut];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.isShowingInterface = NO;
    [self.playButton setHidden:YES];
    [_homeButton setHidden:YES];
    [_settingsButton setHidden:YES];
    [_playButton setAlpha:0.40];
    [_homeButton setAlpha:0.40];
    [_settingsButton setAlpha:0.40];
    [_playButton setOpaque:NO];
    self.bookPageView.text = [NSString stringWithContentsOfFile:self.myPage.textURL.path
                                                       encoding:NSUTF8StringEncoding
                                                          error:NULL];
    self.bookPageView.showText = [[NSUserDefaults standardUserDefaults] boolForKey:@"showText"];
    self.bookPageView.image = [[UIImage alloc] initWithContentsOfFile:self.myPage.imageURL.path];
    
}

- (IBAction)settingsButtonPress:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"iPhone" bundle:nil];
    UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"settingsViewController"];
    self.modalPresentationStyle = UIModalPresentationCurrentContext;
    self.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:vc animated:YES completion:Nil];
}

- (IBAction)homeButtonPress:(id)sender {
        [(BookViewController*)self.parentViewController dismissSelf];
}

- (IBAction)singleTapGesture:(id)sender {
    self.isShowingInterface = !self.isShowingInterface;
    [self layoutPage];
}



-(void)layoutPage {
    [self showInterface];
    self.bookPageView.showText = [[NSUserDefaults standardUserDefaults] boolForKey:@"showText"];
}

-(void)showInterface{
    if (self.isShowingInterface) {
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"playAudio"]) {
            [_playButton setHidden:NO];
        }
        else{
            [_playButton setHidden:YES];
        }
        [_homeButton setHidden:NO];
        [_settingsButton setHidden:NO];
        [_pageAudio stop];
        self.bookPageView.alpha = 0.5;
    } else {
        [_playButton setHidden:YES];
        [_homeButton setHidden:YES];
        [_settingsButton setHidden:YES];
        [self playAudio];
        self.bookPageView.alpha = 1;
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [self showInterface];
}

-(void)doVolumeFadeOut {
    
    if (self.pageAudio.volume > 0.1) {
        [self.pageAudio setVolume:(self.pageAudio.volume - 0.1)];
        [self performSelector:@selector(doVolumeFadeOut) withObject:self afterDelay:0.05];
    }
    
    else {
        [self.pageAudio stop];
        [self.pageAudio setVolume:1];
        [self.pageAudio setCurrentTime: 0];
    }
}

- (CGRect)contentSizeRectForTextView:(UITextView *)textView
{
    [textView.layoutManager ensureLayoutForTextContainer:textView.textContainer];
    CGRect textBounds = [textView.layoutManager usedRectForTextContainer:textView.textContainer];
    CGFloat width =  (CGFloat)ceil(textBounds.size.width + textView.textContainerInset.left + textView.textContainerInset.right);
    CGFloat height = (CGFloat)ceil(textBounds.size.height + textView.textContainerInset.top + textView.textContainerInset.bottom);
    return CGRectMake(0, 0, width, height);
}

@synthesize pageAudio = _pageAudio;

-(void)setPageAudio:(AVAudioPlayer *)pageAudio
{
    _pageAudio = pageAudio;
}

-(void)playAudio{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"playAudio"]) {
        [self.pageAudio play];
        [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    }
    else{
        [self.pageAudio stop];
        [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    }
}

-(AVAudioPlayer*) pageAudio
{
    //NSLog(@"returning audioplayer");
    if (!_pageAudio) {
        _pageAudio = [[AVAudioPlayer alloc] initWithContentsOfURL:self.myPage.audioURL error:nil];
        [_pageAudio setDelegate:self];
    }
    return _pageAudio;
}

@synthesize myPage = _myPage;

-(void) setPage:(Page *)page
{
    _myPage = page;
}

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    //When the sound finished playing just turn the page
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"autoPageTurning"]) {
        [(BookViewController*)self.parentViewController turnToPageAfterViewController:self];
    }
}

- (void) fadePlayer:(AVAudioPlayer*)player fromVolume:(float)startVolume
           toVolume:(float)endVolume overTime:(float)time {
    
    // Update the volume every 1/100 of a second
    float fadeSteps = time * 100.0;
    
    player.volume = startVolume;

    for (int step = 0; step < fadeSteps; step++) {
        double delayInSeconds = step * (time / fadeSteps);
        
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW,
                                                (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            float fraction = ((float)step / fadeSteps);
            
            player.volume = startVolume + (endVolume - startVolume)
            * fraction;
            
        });
    }
}

@end
