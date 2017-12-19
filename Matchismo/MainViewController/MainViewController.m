//
//  MainViewController.m
//  Matchismo
//
//  Created by Dragota Mircea on 01/11/2017.
//  Copyright © 2017 Dragota Mircea. All rights reserved.
//

#import "MainViewController.h"
#import "Deck.h"
#import "PlayingCard.h"
#import "PlayingCardDeck.h"
#import "HistoryViewController.h"


@interface MainViewController ()
@property (strong,nonatomic) Deck *deck;



@end


@implementation MainViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    for (UIView *view in self.cardViews) {

        if([view isKindOfClass:PlayingCardView.class]) {
            [view addGestureRecognizer:[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeCard:)]];
        }
    }
}

-(NSInteger) startingNumberOfCards { //abstract
    return [self.cardViews count];
}

- (CardMatchingGame *)game {
    if(!_game) {
        _game = [[CardMatchingGame alloc] initWhitCardCount:[self startingNumberOfCards] usingDeck:[self createDeck] withGameMode:[self gameMode]];
    }
    
    return _game;
}

- (BOOL) gameMode {
    return true;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"History for normal game"]) {
        if([segue.destinationViewController isKindOfClass:[HistoryViewController class]]) {
            HistoryViewController *hvc = (HistoryViewController *) segue.destinationViewController;
            hvc.historyText = self.game.historyForNormalGame;
        }
    }else if([segue.identifier isEqualToString:@"History for set game"]){
        if([segue.destinationViewController isKindOfClass:[HistoryViewController class]]) {
            HistoryViewController *hvc = (HistoryViewController *) segue.destinationViewController;
            hvc.historyText = self.game.historyForSetGame;
        }
    }
}

- (Deck *)createDeck { //abstract
    return nil;
}

- (void) redealCards{
    CardMatchingGame *newGame = [[CardMatchingGame alloc] initWhitCardCount:[self startingNumberOfCards] usingDeck:[self createDeck] withGameMode:[self gameMode]];
    self.game = newGame;
    self.cardIndex = -1;
    [self updateUI];
    for(PlayingCardView *view in self.cardViews) {
        [view setAlpha:1];
        [view addGestureRecognizer:[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeCard:)]];
    }
    
}

- (IBAction)resetGame:(UIButton *)sender {
    [self redealCards];
}

- (IBAction)swipeCard:(UISwipeGestureRecognizer *)sender { //abstract

}

//
- (void) updateUI { //abstract
   
}

- (NSAttributedString *)titleForCard:(Card *)card {
    return card.isChosen ? [[NSAttributedString alloc] initWithString:card.contents ] : [[NSAttributedString alloc] initWithString:@""];
    
}


- (UIImage *)backgroundImageForCard:(Card *)card {
    return [UIImage imageNamed:card.isChosen ? @"cardfront" : @"cardback"];
}

- (BOOL) backgroundCardView:(Card *)card {
    return card.isChosen ? true:false;
}

@end


