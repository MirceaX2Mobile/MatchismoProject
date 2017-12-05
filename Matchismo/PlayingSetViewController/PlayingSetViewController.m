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
#import "SetCardView.h"

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
    for (UIView *view in self.cardViews) {
        if([view isKindOfClass:SetCardView.class]) {
            [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCard:)]];
        }
    }
    [self updateUI];
}

- (void) redealCards{
    CardMatchingGame *newGame = [[CardMatchingGame alloc] initWhitCardCount:[self.cardViews count] usingDeck:[self createDeck] withGameMode:[self gameMode]];
    self.game = newGame;
    self.cardIndex = -1;
    [self updateUI];
    for(SetCardView *view in self.cardViews) {
        [view setAlpha:1];
        [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCard:)]];
    }
    
}

- (IBAction)tapCard:(UITapGestureRecognizer *)sender {
    self.cardIndex = (NSInteger)[self.cardViews indexOfObject:sender.view];
    
    
    [self.game chooseCardAtIndex:self.cardIndex];
    [self updateUI];
}


- (void) updateUI {
    for(SetCardView *cardButton in self.cardViews) {
        NSInteger cardIndex1 = [self.cardViews indexOfObject:cardButton];
        
        Card *card = [self.game cardAtIndex:cardIndex1];
        
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
        
        
        SetCard *setCard = (SetCard *) card;
        cardButton.number = setCard.number;
        cardButton.symbol = setCard.symbol;
        cardButton.shading = setCard.shading;
        cardButton.color = setCard.color;
        
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %ld",(long)self.game.score];
    self.scoreInfoLabel.attributedText = self.game.scoreInfo;
}


- (UIImage *)backgroundImageForCard:(Card *)card {
    
    return [UIImage imageNamed:@"cardfront"];
}


- (NSAttributedString *)titleForCard:(Card *)card {
    ConverterToAttribute *converter = [[ConverterToAttribute alloc] init];
    
    return [converter convert:card withNewLine:YES];
}


@end
