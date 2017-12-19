//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Dragota Mircea on 06/11/2017.
//  Copyright © 2017 Dragota Mircea. All rights reserved.
//

#import "CardMatchingGame.h"
#import "PlayingCard.h"
#import "ConverterToAttribute.h"
#import "SetCard.h"

@interface CardMatchingGame()
//using readwrite , because we want to redeclare a readonly
@property (nonatomic,readwrite) NSInteger score;
@property (nonatomic) BOOL gameMode2Cards;
@property (nonatomic,strong) NSMutableArray *otherCards;
@property (nonatomic,strong) ConverterToAttribute *converter;

@end

@implementation CardMatchingGame
NSString *status;

@synthesize cards = _cards;

- (void) setCards:(NSMutableArray *)cards {
    _cards = cards;
}


- (NSMutableArray *)cards {
    if(!_cards) {
        _cards = [[NSMutableArray alloc] init];
    }
    return _cards;
}

- (NSMutableAttributedString *)historyForNormalGame {
    if(!_historyForNormalGame) {
        _historyForNormalGame = [[NSMutableAttributedString alloc] init];
    }
    return _historyForNormalGame;
}

- (NSMutableAttributedString *)historyForSetGame {
    if(!_historyForSetGame) {
        _historyForSetGame = [[NSMutableAttributedString alloc] init];
    }
    return _historyForSetGame;
}

- (NSMutableArray *)otherCards {
    if(!_otherCards) {
        _otherCards = [[NSMutableArray alloc] init];
    }
    return _otherCards;
}

- (ConverterToAttribute *)converter {
    if(!_converter) {
        _converter = [[ConverterToAttribute alloc] init];
    }
    return _converter;
}

- (instancetype)initWhitCardCount:(NSUInteger)count usingDeck:(Deck *)deck withGameMode:(BOOL)gameMode{
    self = [super init];
    if(self) {
        self.gameMode2Cards = gameMode;
       // self.scoreInfo = @"You didn't choose anything.";
        self.scoreInfo = [[NSAttributedString alloc] initWithString:@"You didn't choose anything!" ];
        for (int i = 0;i < count; i++) {
            Card *card = [deck drawRandomCard];
            if(card){
                [self.cards addObject:card];
            }else{
                self = nil;
                break;
            }
        }
    }
    return self;
}

-(NSAttributedString *)scoreInfoAttrString:(NSArray *)cardsArray withPoints:(NSInteger)newPoint isMatch:(BOOL)match{
    ConverterToAttribute *converter = [[ConverterToAttribute alloc] init];
    NSMutableAttributedString *finalString = nil;
    if(match) {
        finalString = [[NSMutableAttributedString alloc] initWithString:@"You matched "];
    }else {
        finalString = [[NSMutableAttributedString alloc] initWithString:@"You mismatched "];
    }
    for(int i=0;i<[cardsArray count];i++) {
        [finalString appendAttributedString:[converter convert:[cardsArray objectAtIndex:i] withNewLine:NO]];
        [finalString appendAttributedString:[[NSAttributedString alloc] initWithString:@", "]];
    }
    NSString *point = [[NSString alloc] initWithFormat:@" for %ld points",(long)newPoint];
    NSAttributedString *points = [[NSAttributedString alloc] initWithString:point];
                                  [finalString appendAttributedString:points];
    return finalString;
}

-(NSString *)scoreInfoString:(NSArray *)cardsArray {
    int stats[3] = {-1, -1, -1};
    int sum = 0;
    NSString *stringInfo = @"";
    
    for(int i=0; i<[cardsArray count]-1;i++) {
        PlayingCard *firstCard = (PlayingCard *)cardsArray[i];
        for(int j=i+1;j<[cardsArray count];j++) {
          PlayingCard *secondCard = (PlayingCard *)cardsArray[j];
            if(firstCard.rank == secondCard.rank) {
                stats[i+j-1] = 4;
            }else if([firstCard.suit isEqualToString:secondCard.suit]){
                stats[i+j-1] = 1;
            }
        }
    }
    
    sum = stats[0] + stats[1] + stats[2];
    
    if(sum == -3) {
        return [NSString stringWithFormat:@"No match %d points",sum];
    }
    if(sum == 3) {
        return [NSString stringWithFormat:@"All match on suit %d points",sum];
    }
    if(sum == 12) {
        return [NSString stringWithFormat:@"All match on rank %d points",sum];
    }
    
    PlayingCard *card0 = (PlayingCard *)cardsArray[0];
    PlayingCard *card1 = (PlayingCard *)cardsArray[1];
    PlayingCard *card2 = (PlayingCard *)cardsArray[2];
    
    for(int i=0;i<3;i++) {
        if(stats[i]!= -1) {
            switch (i) {
                case 0:
                    stringInfo = [stringInfo stringByAppendingString: [NSString stringWithFormat:@"%@ and %@ matched for %d points! \n",card0.contents,card1.contents,stats[i]]];
                    break;
                case 1:
                    stringInfo = [stringInfo stringByAppendingString: [NSString stringWithFormat:@"%@ and %@ matched for %d points! \n",card0.contents,card2.contents,stats[i]]];
                    break;
                case 2:
                    stringInfo =[stringInfo stringByAppendingString: [NSString stringWithFormat:@"%@ and %@ matched for %d points! \n",card1.contents,card2.contents,stats[i]]];
                    break;
                default:
                    break;
            }
        }
    }

    return stringInfo;
}


-(Card *)cardAtIndex:(NSUInteger)index {
    return (index < [self.cards count]) ? self.cards[index] : nil;
}

#define MISMATCH_PENALTY 2
static const int  MATCH_BONUS = 4;
static const int  COST_TO_CHOOSE=1;
int cardCounter=0;

-(void)chooseCardAtIndex:(NSUInteger)index {
    Card *card = [self cardAtIndex:index];
    ConverterToAttribute *converter = [[ConverterToAttribute alloc] init];
    
    if (!card.isMatched) {
        
        //self.scoreInfo = [NSString stringWithFormat:@"You choose: %@",card.contents];
        if(!self.gameMode2Cards){
            NSMutableAttributedString *finalString = [[NSMutableAttributedString alloc] initWithString:@"You choose: "];
            [finalString appendAttributedString:[converter convert:card withNewLine:NO]];
            self.scoreInfo = finalString;
        }else {
            NSAttributedString *finalString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"You choose: %@",card.contents]];
             self.scoreInfo = finalString;
        }
        if (card.isChosen) {
            if(self.gameMode2Cards == true){
        //    self.scoreInfo = @"You didn't choose anything!";
            self.scoreInfo = [[NSAttributedString alloc] initWithString:@"You didn't choose anything!" ];
                
            }else {
         //      self.scoreInfo = @"You didn't choose 3 cards!";
               self.scoreInfo = [[NSAttributedString alloc] initWithString:@"You didn't choose 3 cards!" ];
            }
            card.chosen = NO;
            if([self.otherCards containsObject:card]) {
                [self.otherCards removeObject:card];
                cardCounter--;
            }
        }else{
            //match agianst another card
            for (Card *otherCard in self.cards) {
                if (otherCard.isChosen && !otherCard.isMatched) {
                    if (self.gameMode2Cards == true) {
                        self.otherCards = [[NSMutableArray alloc] init];
                        [self.otherCards addObject:otherCard];
                        int matchScore = [card match:self.otherCards];
                        if(matchScore) {
                            self.score += matchScore * MATCH_BONUS;
                          //  self.scoreInfo = [NSString stringWithFormat:@"%@ %@ matched for %d points!",card.contents,otherCard.contents,matchScore * MATCH_BONUS];
                            self.scoreInfo = [self scoreInfoAttrString:@[card,otherCard] withPoints:matchScore * MATCH_BONUS isMatch:true];
                            [self.historyForNormalGame appendAttributedString:self.scoreInfo];
                            [self.historyForNormalGame appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"]];
                            card.matched = YES;
                            otherCard.matched = YES;
                        } else {
                             self.score -= MISMATCH_PENALTY;
                           //  self.scoreInfo = [NSString stringWithFormat:@"%@ %@ dont't match! %d point penalty!",card.contents,otherCard.contents,-MISMATCH_PENALTY];
                            self.scoreInfo = [self scoreInfoAttrString:@[card,otherCard] withPoints:-MISMATCH_PENALTY isMatch:false];
                            [self.historyForNormalGame appendAttributedString:self.scoreInfo];
                            [self.historyForNormalGame appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"]];
                            otherCard.chosen = NO;
                        }
                        break;
                    } else {
                        if([self.otherCards count] == 2) {
                            self.otherCards = [[NSMutableArray alloc] init];
                        }
                        
                        if(![self.otherCards containsObject:otherCard]){
                            [self.otherCards addObject:otherCard];
                            cardCounter++;
                        }
                        if ([self.otherCards count] == 2) { // <- aici era cardCounterul vechi
                            int matchScore = [card match:self.otherCards];
                            cardCounter = 0;
                            
                            if(matchScore) {
                                self.score += matchScore * MATCH_BONUS;
                                
                                self.scoreInfo = [self scoreInfoAttrString:@[self.otherCards[0], self.otherCards[1], card] withPoints:matchScore * MATCH_BONUS isMatch:true];
                                [self.historyForSetGame appendAttributedString:self.scoreInfo];
                                [self.historyForSetGame appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"]];
                                
                                SetCard *card1 = self.otherCards[0];
                                SetCard *card2 = self.otherCards[1];
                                card1.matched = YES;
                                card2.matched = YES;
                                card.matched = YES;
                            }
                            else {
                                self.score -= MISMATCH_PENALTY;
                                self.scoreInfo = [self scoreInfoAttrString:@[self.otherCards[0], self.otherCards[1], card] withPoints:-MISMATCH_PENALTY isMatch:false];
                                [self.historyForSetGame appendAttributedString:self.scoreInfo];
                                [self.historyForSetGame appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"]];
                                
                                SetCard *card1 = self.otherCards[0];
                                SetCard *card2 = self.otherCards[1];
                                card1.chosen= NO;
                                card2.chosen = NO;
                            }
                           
                        }
                    }
                }
                
            }
            if(self.gameMode2Cards == true){
            self.score -= COST_TO_CHOOSE;
            }
                
            card.chosen = YES;
        }
    }

}

- (instancetype)init {
    return nil;
}

@end

