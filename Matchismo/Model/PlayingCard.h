//
//  PlayingCard.h
//  Matchismo
//
//  Created by Dragota Mircea on 02/11/2017.
//  Copyright © 2017 Dragota Mircea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface PlayingCard : Card
@property (strong,nonatomic) NSString *suit;
@property (nonatomic) NSUInteger rank;

+(NSArray *)validSuits;
+(NSUInteger)maxRank;
@end
