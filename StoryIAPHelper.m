//
//  storyIAPHelper.m
//  GullKistan
//
//  Created by AGUST RAFNSSON on 11/21/12.
//
//

#import "StoryIAPHelper.h"

@implementation StoryIAPHelper

+(StoryIAPHelper*)sharedInstance{
    static dispatch_once_t once;
    static StoryIAPHelper * sharedInstance;
    dispatch_once(&once, ^{
        NSSet * productIdentifiers = [NSSet setWithObjects:
                                      @"story1",
                                      @"story2",
                                      @"story3",
                                      @"story4",
                                      @"story5",
                                      @"story6",
                                      @"story7",
                                      @"story8",
                                      @"story9",
                                      @"story10",
                                      @"story11",
                                      @"story12",
                                      @"story13",
                                      @"story14",
                                      @"story15",
                                      @"story16",
                                      @"story17",
                                      @"story18",
                                      @"story19",
                                      @"story20",
                                      @"story21",
                                      @"story22",
                                      @"story23",
                                      @"story24",
                                      @"story25",
                                      @"story26",
                                      @"story27",
                                      @"story28",
                                      @"story29",
                                      @"story30",
                                      @"story31",
                                      @"story32",
                                      @"story33",
                                      @"story34",
                                      @"story35",
                                      @"story36",
                                      @"story37",
                                      @"story38",
                                      @"story39",
                                      @"story40",
                                      @"story41",
                                      @"story42",
                                      @"story43",
                                      @"story44",
                                      @"story45",
                                      @"story46",
                                      @"story47",
                                      @"story48",
                                      @"story49",
                                      @"story50",
                                      @"story51",
                                      @"story52",
                                      @"story53",
                                      @"story54",
                                      @"story55",
                                      @"story56",
                                      @"story57",
                                      @"story58",
                                      @"story59",
                                      @"story60",
                                      @"story61",
                                      @"story62",
                                      @"story63",
                                      @"story64",
                                      @"story65",
                                      @"story66",
                                      @"story67",
                                      @"story68",
                                      @"story69",
                                      @"story70",
                                      @"story71",
                                      @"story72",
                                      @"story73",
                                      @"story74",
                                      @"story75",
                                      @"story76",
                                      @"story77",
                                      @"story78",
                                      @"story79",
                                      nil];
        sharedInstance = [[self alloc] initWithProductIdentifiers:productIdentifiers];
    });
    return sharedInstance;
}
@end

