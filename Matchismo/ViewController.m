//
//  ViewController.m
//  Matchismo
//
//  Created by Dragota Mircea on 01/11/2017.
//  Copyright © 2017 Dragota Mircea. All rights reserved.
//

#import "ViewController.h"
#import "Deck.h"
#import "PlayingCard.h"
#import "PlayingCardDeck.h"
#import "CardMatchingGame.h"

@interface ViewController ()
@property (strong,nonatomic) Deck *deck;
@property (nonatomic,strong) CardMatchingGame *game;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *gameModeSwitcher;
@property (weak, nonatomic) IBOutlet UILabel *scoreInfoLabel;


@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@end


@implementation ViewController
int cardIndex = -1;

- (CardMatchingGame *)game {
    if(!_game) {
        _game = [[CardMatchingGame alloc] initWhitCardCount:[self.cardButtons count] usingDeck:[self createDeck] withGameMode:true];
    }
    return _game;
}

- (Deck *)createDeck {
    return [[PlayingCardDeck alloc] init];
}

- (void) redealCards:(BOOL) gameMode {
    CardMatchingGame *newGame = [[CardMatchingGame alloc] initWhitCardCount:[self.cardButtons count] usingDeck:[self createDeck] withGameMode:gameMode];
    self.game = newGame;
    cardIndex = -1;
    [self updateUI];
}

- (IBAction)resetGame:(UIButton *)sender {
    self.gameModeSwitcher.enabled = true;
    if(self.gameModeSwitcher.selectedSegmentIndex == 0){
        [self redealCards:true];
    }else {
        [self redealCards:false];
    }
}

- (IBAction)gameModeChange:(UISegmentedControl *)sender {
    if(sender.selectedSegmentIndex == 0){
        [self redealCards:true];
    }else {
        [self redealCards:false];
    }
}

- (IBAction)touchCardButton:(UIButton *)sender {
    self.gameModeSwitcher.enabled = false;
    cardIndex = [self.cardButtons indexOfObject:sender];
    [self.game chooseCardAtIndex:cardIndex];
    [self updateUI];
}

- (void) updateUI {
    for(UIButton *cardButton in self.cardButtons) {
        int cardIndex = [self.cardButtons indexOfObject:cardButton];
        
        Card *card = [self.game cardAtIndex:cardIndex];
        
        [cardButton setTitle:[self titleForCard:card] forState:UIControlStateNormal];
        [cardButton setBackgroundImage:[self backgroundImageForCard:card] forState:UIControlStateNormal];
        cardButton.enabled = !card.isMatched;
        
        
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d",self.game.score];
    self.scoreInfoLabel.text = self.game.scoreInfo;
}

//- (void)updateStatus{
//    Card *card = [self.game cardAtIndex:cardIndex];
//
//   
//    if(!card) {
//        self.statusLabel.text = @"You didn't choose anything.";
//    }if(card.isChosen && !card.isMatched) {
//        self.statusLabel.text = [self textForStatus:card];
//    }else {
//        self.statusLabel.text = [self.game statusForSelectedCard:card];
//        
//    }
//    
//}

- (NSString *)titleForCard:(Card *)card {
    return card.isChosen ? card.contents : @"";
}

- (NSString *)textForStatus:(Card *)card {
    return [NSString stringWithFormat:@"You choose: %@", card.contents];
    
}

- (UIImage *)backgroundImageForCard:(Card *)card {
    
    return [UIImage imageNamed:card.isChosen ? @"cardfront" : @"cardback"];
}

@end


