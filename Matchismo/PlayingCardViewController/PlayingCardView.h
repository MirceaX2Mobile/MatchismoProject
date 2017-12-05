//
//  PlayingCardView.h
//  Matchismo
//
//  Created by Dragota Mircea on 04/12/2017.
//  Copyright © 2017 Dragota Mircea. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayingCardView : UIView

@property (nonatomic) NSUInteger rank;
@property (strong, nonatomic) NSString *suit;
@property (nonatomic) BOOL faceUp;
-(void)disable;
@end
