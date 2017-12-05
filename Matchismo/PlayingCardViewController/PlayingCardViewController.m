//
//  PlayingCardViewController.m
//  Matchismo
//
//  Created by Dragota Mircea on 13/11/2017.
//  Copyright © 2017 Dragota Mircea. All rights reserved.
//

#import "PlayingCardViewController.h"
#import "PlayingCardDeck.h"
#import "PlayingCard.h"
@interface PlayingCardViewController ()

@end

@implementation PlayingCardViewController

-(Deck *)createDeck {
    return [[PlayingCardDeck alloc] init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void) updateUI {
    for(PlayingCardView *cardButton in self.cardViews) {
        NSInteger cardIndex = [self.cardViews indexOfObject:cardButton];
        
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
        
  
        if(card.isMatched) {
            [cardButton disable];
                for (UIGestureRecognizer *recognizer in cardButton.gestureRecognizers) {
                    [cardButton removeGestureRecognizer:recognizer];
                }
            }
        
            cardButton.faceUp = [self backgroundCardView:card];
        
            PlayingCard *playingCard = (PlayingCard *) card;
            cardButton.rank = playingCard.rank;
            cardButton.suit = playingCard.suit;
        
       
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %ld",(long)self.game.score];
    self.scoreInfoLabel.attributedText = self.game.scoreInfo;
}


@end
