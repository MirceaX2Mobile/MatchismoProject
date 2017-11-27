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
@interface MainViewController : UIViewController

//abstract must be implemented
- (Deck *)createDeck;
- (IBAction)touchCardButton:(UIButton *)sender ;
- (UIImage *)backgroundImageForCard:(Card *)card;
- (void) updateUI;
- (NSAttributedString *)titleForCard:(Card *)card;
- (BOOL) gameMode;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *scoreInfoLabel;
@property (nonatomic,strong) CardMatchingGame *game;
@end
