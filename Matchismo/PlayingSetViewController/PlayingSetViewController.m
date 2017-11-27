//
//  PlayingSetViewController.m
//  Matchismo
//
//  Created by Dragota Mircea on 22/11/2017.
//  Copyright © 2017 Dragota Mircea. All rights reserved.
//

#import "PlayingSetViewController.h"
#import "SetCardDeck.h"
#import "SetCard.h"
#import "CardMatchingGame.h"
#import "ConverterToAttribute.h"

@interface PlayingSetViewController ()
@end

@implementation PlayingSetViewController


-(BOOL) gameMode {
    return false;
}

-(Deck *)createDeck {
    return [[SetCardDeck alloc] init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateUI];
}

- (UIImage *)backgroundImageForCard:(Card *)card {
    
    return [UIImage imageNamed:@"cardfront"];
}


- (NSAttributedString *)titleForCard:(Card *)card {
    ConverterToAttribute *converter = [[ConverterToAttribute alloc] init];
    
    return [converter convert:card withNewLine:YES];
}


@end
