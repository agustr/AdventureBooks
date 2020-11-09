//
//  BookSettingsViewController.m
//  AdventureBooks
//
//  Created by Agust Rafnsson on 10/09/14.
//  Copyright (c) 2014 Agust Rafnsson. All rights reserved.
//

#import "BookSettingsViewController.h"

@interface BookSettingsViewController ()
@property (strong, nonatomic) IBOutlet UISwitch *showTextSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *autoPageTurningSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *playAudioSwitch;

@end

@implementation BookSettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)finishedButtonPress:(id)sender {
    [self dismissViewControllerAnimated:YES completion:Nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    // Set the switches to the settings in the settings file.
    [self loadSettings];
    
}
-(void)loadSettings{
    [_showTextSwitch setOn:[[NSUserDefaults standardUserDefaults] boolForKey:@"showText"] animated:YES] ;
    [_autoPageTurningSwitch setOn:[[NSUserDefaults standardUserDefaults] boolForKey:@"autoPageTurning"] animated:YES];
    [_playAudioSwitch setOn:[[NSUserDefaults standardUserDefaults] boolForKey:@"playAudio"] animated:YES];
}
- (IBAction)settingsChangeAction:(id)sender {
    UISwitch* actionSwitch = (UISwitch*)sender;
    
    [[NSUserDefaults standardUserDefaults] setBool:_showTextSwitch.on forKey:@"showText"];
    
    if (!_playAudioSwitch.on) {
        //if you are not playing the audio then you have to turn the pages yourself
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"playAudio"];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"autoPageTurning"];
    }
    else{
        [[NSUserDefaults standardUserDefaults] setBool:_autoPageTurningSwitch.on forKey:@"autoPageTurning"];
        [[NSUserDefaults standardUserDefaults] setBool:_playAudioSwitch.on forKey:@"playAudio"];
    }
    
    if (sender==_autoPageTurningSwitch) {
        
        if (_autoPageTurningSwitch.on) {
            //if the user turns auto page turning on then turn the audio on
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"playAudio"];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"autoPageTurning"];
        }
        else{
            //otherwise just turn the pageturning off
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"autoPageTurning"];
        }
    }
    
    [self loadSettings];
}


-(void)viewDidAppear:(BOOL)animated{

    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
