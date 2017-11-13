//
//  Card.m
//  Matchismo
//
//  Created by Dragota Mircea on 02/11/2017.
//  Copyright © 2017 Dragota Mircea. All rights reserved.
//

#import "Card.h"
@interface Card()
@end

@implementation Card
-(int)match:(NSArray *)otherCards {
    int score = 0;
    
    for(Card *card in otherCards) {
        if([card.contents isEqualToString:self.contents])
            score = 1;
    }
    
    return score;
}
@end
