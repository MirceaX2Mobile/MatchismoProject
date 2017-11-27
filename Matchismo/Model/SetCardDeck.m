//
//  SetCardDeck.m
//  Matchismo
//
//  Created by Dragota Mircea on 23/11/2017.
//  Copyright © 2017 Dragota Mircea. All rights reserved.
//

#import "SetCardDeck.h"
#import "SetCard.h"

@implementation SetCardDeck
-(instancetype)init {
    self = [super init];
    
    if(self){
        for(NSString *color in [SetCard validColor]) {
            for(NSString *shade in [SetCard validShadings]) {
                for(NSString *symbol in [SetCard validSymbol]) {
                    for(int number = 1; number <= [SetCard validNumber];number++) {
                        SetCard *card = [[SetCard alloc] init];
                        card.number = number;
                        card.shading = shade;
                        card.color = color;
                        card.symbol = symbol;
                        [self addCard:card];
                    }
                }
            }
        }
    }
    return self;
}
@end
