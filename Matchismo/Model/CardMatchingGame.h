//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Dragota Mircea on 06/11/2017.
//  Copyright © 2017 Dragota Mircea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"

@interface CardMatchingGame : NSObject

//designated  initiliazer
- (instancetype)initWhitCardCount:(NSUInteger)count usingDeck:(Deck *)deck withGameMode:(BOOL)gameMode;

@property (nonatomic,strong) NSMutableArray *cards; // of Card
@property (nonatomic,strong) NSAttributedString *scoreInfo;
@property (strong,nonatomic) NSMutableAttributedString *historyForNormalGame;
@property (strong,nonatomic) NSMutableAttributedString *historyForSetGame;
@property (nonatomic,readonly) NSInteger score;
-(void)chooseCardAtIndex:(NSUInteger)index;
-(Card *)cardAtIndex:(NSUInteger)index;
-(NSString *)scoreInfoString:(NSArray *)cardsArray;
-(NSAttributedString *)scoreInfoAttrString:(NSArray *)cardsArray withPoints:(NSInteger)newPoint isMatch:(BOOL)match;
@end
