//
//  PlayingCard.m
//  Matchismo
//
//  Created by Dragota Mircea on 02/11/2017.
//  Copyright © 2017 Dragota Mircea. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

- (int)match:(NSArray *)otherCards {
    int score = 0;
    if([otherCards count] == 1){
        PlayingCard *otherCard = [otherCards firstObject];
        if ([self.suit isEqualToString:otherCard.suit]) {
            score = 1;
        }else if (self.rank ==otherCard.rank){
            score = 4;
        }
    }else {
        
        for (int i=0;i<2;i++) {
            PlayingCard *otherCard = otherCards[i];
            if ([self.suit isEqualToString:otherCard.suit]) {
                score += 1;
            } else if (self.rank == otherCard.rank){
                score += 4;
            }
        }
        PlayingCard *card1 = otherCards[0];
        PlayingCard *card2 = otherCards[1];
        if ([card1.suit isEqualToString:card2.suit]) {
            score += 1;
        } else if (card1.rank == card2.rank){
            score += 1;
        }
    }
    
    return score;
}

- (NSString *)contents {
    NSArray *rankStrings = [PlayingCard rankStrings];
    
    return [rankStrings[self.rank] stringByAppendingString:self.suit];
}

@synthesize suit = _suit ;

+ (NSArray *)validSuits {
    return @[@"♥️",@"♦️",@"♠️",@"♣️"];
}

-(void)setSuit:(NSString *)suit {
    if([[PlayingCard validSuits] containsObject:suit]){
        _suit = suit;
    }
}

-(NSString *)suit {
    return _suit ? _suit : @"?";
}

+(NSArray *)rankStrings {
    return @[@"?",@"A",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"J",@"Q",@"K"];
}

+(NSUInteger)maxRank {
    return [[self rankStrings] count] - 1;
}

-(void)setRank:(NSUInteger)rank {
    if(rank <= [PlayingCard maxRank]) {
        _rank = rank;
    }
}

@end
