//
//  Deck.h
//  Matchismo
//
//  Created by Dragota Mircea on 02/11/2017.
//  Copyright © 2017 Dragota Mircea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface Deck : NSObject

-(void) addCard:(Card *)card atTop:(BOOL)atTop;
-(void) addCard:(Card *)card;
-(Card *) drawRandomCard;
@end
