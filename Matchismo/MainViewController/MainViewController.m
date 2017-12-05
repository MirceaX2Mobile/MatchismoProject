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

- (CardMatchingGame *)game {
    if(!_game) {
        _game = [[CardMatchingGame alloc] initWhitCardCount:[self.cardViews count] usingDeck:[self createDeck] withGameMode:[self gameMode]];
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
    CardMatchingGame *newGame = [[CardMatchingGame alloc] initWhitCardCount:[self.cardViews count] usingDeck:[self createDeck] withGameMode:[self gameMode]];
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

//
- (IBAction)touchCardButton:(UIButton *)sender {
    self.cardIndex = (NSInteger)[self.cardButtons indexOfObject:sender];
    
    [self.game chooseCardAtIndex:self.cardIndex];
    [self updateUI];
}

- (IBAction)swipeCard:(UISwipeGestureRecognizer *)sender {
    self.cardIndex = (NSInteger)[self.cardViews indexOfObject:sender.view];
    
    
    [self.game chooseCardAtIndex:self.cardIndex];
    [self updateUI];
}

//
- (void) updateUI {
    for(UIButton *cardButton in self.cardButtons) {
        NSInteger cardIndex = [self.cardButtons indexOfObject:cardButton];
        
        Card *card = [self.game cardAtIndex:cardIndex];
        
        if(card.isChosen){
            UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:cardButton.bounds];
           cardButton.layer.masksToBounds = NO;
           cardButton.layer.shadowColor = [UIColor blackColor].CGColor;
            cardButton.layer.shadowOffset = CGSizeMake(10.0f, 5.0f);  /*Change value of X n Y as per your need of shadow to appear to like right bottom or left bottom or so on*/
            cardButton.layer.shadowOpacity = 0.5f;
            cardButton.layer.shadowPath = shadowPath.CGPath;
        }else {
            cardButton.layer.masksToBounds = NO;
            cardButton.layer.shadowOffset = CGSizeMake(-10.0f, -5.0f);  /*Change value of X n Y as per your need of shadow to appear to like right bottom or left bottom or so on*/
            cardButton.layer.shadowOpacity = -0.5f;
        }
        
        [cardButton setAttributedTitle:[self titleForCard:card] forState:UIControlStateNormal];
        [cardButton setBackgroundImage:[self backgroundImageForCard:card] forState:UIControlStateNormal];
        cardButton.enabled = !card.isMatched;

    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %ld",(long)self.game.score];
    self.scoreInfoLabel.attributedText = self.game.scoreInfo;
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


