//
//  SetCard.m
//  Matchismo
//
//  Created by Dragota Mircea on 22/11/2017.
//  Copyright © 2017 Dragota Mircea. All rights reserved.
//

#import "SetCard.h"
#import "ConverterToAttribute.h"
@interface SetCard()

@end

@implementation SetCard

+(int) validNumber {
    return 3;
}

+(NSArray *) validSymbol {
    return @[@"●",@"▲",@"◼︎"];
}

+(NSArray *) validColor {
    return @[@"red",@"green",@"purple"];
}

+(NSArray *) validShadings {
    return @[@"solid",@"striped",@"open"];
}

- (void) setNumber:(int)number {
    if(number <= [SetCard validNumber]) {
        _number = number;
    }
}

- (void) setSymbol:(NSString *)symbol {
    if([[SetCard validSymbol] containsObject:symbol]) {
        _symbol = symbol;
    }
}

- (void) setShading:(NSString *)shading {
    if([[SetCard validShadings] containsObject:shading]) {
        _shading = shading;
    }
}

- (void) setColor:(NSString *)color {
    if ([[SetCard validColor] containsObject:color]) {
        _color = color;
    }
}

- (NSAttributedString *) contents {
   ConverterToAttribute *converter = [[ConverterToAttribute alloc] init];

    return [converter convert:self withNewLine:NO];
}

- (int) match:(NSArray *)otherCards {
    int score = 0;
    int sumN = 0;
    int sumS = 0;
    int sumShading = 0;
    int sumColor = 0;
    
    sumN += self.number ;
    sumS += [[SetCard validSymbol] indexOfObject:self.symbol] + 1;
    sumColor += [[SetCard validColor] indexOfObject:self.color] + 1;
    sumShading += [[SetCard validShadings] indexOfObject:self.shading] + 1;
    
    
    for(SetCard *currentCard in otherCards) {
        sumN += currentCard.number ;
        sumS += [[SetCard validSymbol] indexOfObject:currentCard.symbol] + 1;
        sumColor += [[SetCard validColor] indexOfObject:currentCard.color] + 1;
        sumShading += [[SetCard validShadings] indexOfObject:currentCard.shading] + 1;
        
    }
    
    if(sumN % 3 == 0 && sumS % 3 == 0 && sumShading % 3 == 0 && sumColor % 3 == 0) {
        score = 1;
    }
    
    return score;
}

@end
