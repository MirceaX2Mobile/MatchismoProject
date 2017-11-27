//
//  SetCard.h
//  Matchismo
//
//  Created by Dragota Mircea on 22/11/2017.
//  Copyright © 2017 Dragota Mircea. All rights reserved.
//


#import "Card.h"

@interface SetCard : Card

@property (nonatomic) int number;
@property (nonatomic,strong) NSString *symbol;
@property (nonatomic,strong) NSString *shading;
@property (nonatomic,strong) NSString *color;


+(int) validNumber;
+(NSArray *) validSymbol;
+(NSArray *) validColor;
+(NSArray *) validShadings;

@end
