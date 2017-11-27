//
//  PlayingCardViewController.m
//  Matchismo
//
//  Created by Dragota Mircea on 13/11/2017.
//  Copyright © 2017 Dragota Mircea. All rights reserved.
//

#import "PlayingCardViewController.h"
#import "PlayingCardDeck.h"
@interface PlayingCardViewController ()

@end

@implementation PlayingCardViewController

-(Deck *)createDeck {
    return [[PlayingCardDeck alloc] init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}
@end
