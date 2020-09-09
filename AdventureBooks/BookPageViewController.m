//
//  PageViewController.m
//  AdventureBooks
//
//  Created by Agust Rafnsson on 05/09/14.
//  Copyright (c) 2014 Agust Rafnsson. All rights reserved.
//

#import "BookPageViewController.h"
#import "BookViewController.h"


@interface BookPageViewController ()
//@property (strong, nonatomic) IBOutlet UILabel *pageLabel;
@property (strong, nonatomic) IBOutlet UIImageView *pageImageView;
@property (strong, nonatomic) AVAudioPlayer *pageAudio;
@property (strong, nonatomic) IBOutlet UITextView *pageTextView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *pageTextVieHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *pageTextViewDistanceFromBottom;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *pageImageViewDistanceFromBottom;
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
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.view layoutSubviews];
    [self layoutPage];
    
    [self performSelector:@selector(delayedAppear) withObject:nil afterDelay:0.0f];
    
}

-(void)delayedAppear{
    [self playAudio];
   // [self fadePlayer:self.pageAudio fromVolume:1 toVolume:0 overTime:10];
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

-(void)viewDidLayoutSubviews{
    //[self layoutPage];
    [self.view layoutSubviews];
}

-(void)viewWillDisappear:(BOOL)animated{
    [self doVolumeFadeOut];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _isShowingInterface = NO;
    [_playButton setHidden:YES];
    [_homeButton setHidden:YES];
    [_settingsButton setHidden:YES];
    [_playButton setAlpha:0.40];
    [_homeButton setAlpha:0.40];
    [_settingsButton setAlpha:0.40];
    [_playButton setOpaque:NO];
    [self getPageText];
}
- (IBAction)settingsButtonPress:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"iPhone" bundle:nil];
    UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"settingsViewController"];
    //vc.view.backgroundColor = [UIColor clearColor];
    self.modalPresentationStyle = UIModalPresentationCurrentContext;
    self.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:vc animated:YES completion:Nil];    
}
- (IBAction)homeButtonPress:(id)sender {
        [(BookViewController*)self.parentViewController dismissSelf];
}

-(void)getPageText{
    self.pageTextView.text = [NSString stringWithContentsOfFile:self.myPage.textURL.path
                                                       encoding:NSUTF8StringEncoding
                                                          error:NULL];
    if (self.pageTextView.text.length==0) {
        [self.pageTextView setHidden:YES];
        [self.pageTextView setUserInteractionEnabled:NO];
    }
}
- (IBAction)singleTapGesture:(id)sender {
    
    if (_isShowingInterface) {
        //Hide the interface
        _isShowingInterface = NO;
    }
    else{
        //set the interface to showing
        _isShowingInterface = YES;
    }
    [self layoutPage];
}


-(void)layoutPage {
    
    [self showInterface];
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"showText"]||!self.myPage.textURL) {
        //we should not show the text
        [_pageTextView setHidden:YES];
        _pageTextView.text = nil;
        _pageImageViewDistanceFromBottom.constant = 0;
        return;
    }
    else{
        //get the text to be shown
        [_pageTextView setHidden:NO];
        [self getPageText];
    }
    //first make both the bottom layout constraints 0.

    _pageTextViewDistanceFromBottom.constant = 0;
    _pageImageViewDistanceFromBottom.constant = 0;
    [self.view layoutSubviews];
    
    //make the textview height constraint as small as possible.
    NSLog(@"self.pageTextVieHeight.constant: %f",self.pageTextVieHeight.constant);
    self.pageTextVieHeight.constant = [self contentSizeRectForTextView:self.pageTextView].size.height;
    NSLog(@"self.pageTextVieHeight.constant: %f",self.pageTextVieHeight.constant);

    //find uiimage bottom line
    CGFloat imageDistanceFromBottom = [self imageDistanceFromBottom];
    //find uitextview top line
    CGFloat textViewDistanceFromBottom = self.pageTextVieHeight.constant;
    
    //if uiimage bottom line < uitextview top line -> make uiimageview bottom layout constraint = uitextview height
    if (imageDistanceFromBottom<textViewDistanceFromBottom) {
        NSLog(@"should move text up");
        [UIView animateWithDuration:0.3
                         animations:^{
                            self.pageImageViewDistanceFromBottom.constant = textViewDistanceFromBottom;
                         }
                         completion:^(BOOL finished) {
                         }];
        _pageImageViewDistanceFromBottom.constant = textViewDistanceFromBottom;
        return;
    }
    
    //otherwise move the text view up to the images bottom line. uitextview bottom layout contstraint = uiimagebottomline - uiimageview height
    else{
        NSLog(@"the text shoudl be moved up");
        CGFloat moveTextBy = imageDistanceFromBottom-textViewDistanceFromBottom;
        _pageTextViewDistanceFromBottom.constant=moveTextBy;
        return;
    }
}

-(void)showInterface{
    
    if (!_isShowingInterface) {
        //Hide the interface
        NSLog(@"NOT isShowingInterface");
        [self.view sendSubviewToBack:_playButtonImage];
        [_playButton setHidden:YES];
        [_homeButton setHidden:YES];
        [_settingsButton setHidden:YES];
        //[_pageAudio play];
        if (self.isViewLoaded && self.view.window){
            // viewController is visible
            [self playAudio];
        }

        self.pageImageView.alpha = 1;

        //set the interface to not showing
        //_isShowingInterface = NO;
    }
    
    else{
        //Show the interface
        [self.view bringSubviewToFront:_playButtonImage];
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"playAudio"]) {
            [_playButton setHidden:NO];
        }
        else{
            [_playButton setHidden:YES];
        }
        [_homeButton setHidden:NO];
        [_settingsButton setHidden:NO];
        [_pageAudio stop];
        self.pageImageView.alpha = 0.5;
        
        
        //set the interface to showing
        //_isShowingInterface = YES;
    }
}
-(CGFloat)imageDistanceFromBottom{
    //Returns the distance of 'the-bottom-of-the-uiimage' from 'the-bottom-of-the-uiimageview'
    //This is so that we may be able to see if 'the-bottom-of-the-uiimage' overlaps with 'the-top-of-the-uitextview'
    
    CGSize imageSize = self.pageImageView.image.size;
    CGFloat imageScale = fminf(CGRectGetWidth(self.pageImageView.bounds)/imageSize.width, CGRectGetHeight(self.pageImageView.bounds)/imageSize.height);
    
    CGSize scaledImageSize = CGSizeMake(imageSize.width*imageScale, imageSize.height*imageScale);

    CGFloat distanceFromBottom = (_pageImageView.frame.size.height - scaledImageSize.height)/2;
    return distanceFromBottom;
}

-(void)viewWillAppear:(BOOL)animated{
    //self.pageLabel.text = self.myPage.imageURL.lastPathComponent;
    self.pageImageView.image = [[UIImage alloc] initWithContentsOfFile:self.myPage.imageURL.path];

    [self layoutTextView];
    
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

-(void)layoutTextView{
    self.pageTextVieHeight.constant = [self contentSizeRectForTextView:self.pageTextView].size.height;
}

- (CGRect)contentSizeRectForTextView:(UITextView *)textView
{
    [textView.layoutManager ensureLayoutForTextContainer:textView.textContainer];
    CGRect textBounds = [textView.layoutManager usedRectForTextContainer:textView.textContainer];
    CGFloat width =  (CGFloat)ceil(textBounds.size.width + textView.textContainerInset.left + textView.textContainerInset.right);
    CGFloat height = (CGFloat)ceil(textBounds.size.height + textView.textContainerInset.top + textView.textContainerInset.bottom);
    return CGRectMake(0, 0, width, height);
}

-(void)viewDidDisappear:(BOOL)animated
{

    //[self doVolumeFadeOut];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@synthesize pageAudio = _pageAudio;

-(void)setPageAudio:(AVAudioPlayer *)pageAudio
{
    _pageAudio = pageAudio;
}

-(void)playAudio{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"playAudio"]) {
        NSLog(@"sending play");
        [self.pageAudio play];
    }
    else{
        [self.pageAudio stop];
    }
}

-(AVAudioPlayer*) pageAudio
{
    //NSLog(@"returning audioplayer");
    if (!_pageAudio) {
        NSLog(@"creating audioplayer");
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
    //When the sound finished playing just turn the page
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"autoPageTurning"]) {
        [(BookViewController*)self.parentViewController turnToPageAfterViewController:self];
    }
}

@end
