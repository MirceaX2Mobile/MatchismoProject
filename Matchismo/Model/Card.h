//
//  Card.h
//  Matchismo
//
//  Created by Dragota Mircea on 02/11/2017.
//  Copyright © 2017 Dragota Mircea. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Card : NSObject
@property (strong,nonatomic)NSString *contents;
@property (nonatomic,getter=isChosen) BOOL chosen;
@property (nonatomic,getter=isMatched) BOOL matched;
-(int)match:(NSArray *)otherCards;
@end
