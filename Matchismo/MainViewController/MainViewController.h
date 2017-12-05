//
//  MainViewController.h
//  Matchismo
//
//  Created by Dragota Mircea on 01/11/2017.
//  Copyright © 2017 Dragota Mircea. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Deck.h"
#import "CardMatchingGame.h"
#import "PlayingCardView.h"
@interface MainViewController : UIViewController

//abstract must be implemented
- (Deck *)createDeck;
- (IBAction)touchCardButton:(UIView *)sender ;
- (UIImage *)backgroundImageForCard:(Card *)card;
- (BOOL) backgroundCardView:(Card *)card;
- (void) updateUI;
- (NSAttributedString *)titleForCard:(Card *)card;
- (BOOL) gameMode;
@property (strong,nonatomic) IBOutletCollection(UIView) NSArray *cardViews;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *scoreInfoLabel;
@property (nonatomic,strong) CardMatchingGame *game;
@property (nonatomic) NSInteger  cardIndex;
@end

