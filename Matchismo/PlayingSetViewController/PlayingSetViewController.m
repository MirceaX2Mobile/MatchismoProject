//
//  PlayingSetViewController.m
//  Matchismo
//
//  Created by Dragota Mircea on 22/11/2017.
//  Copyright © 2017 Dragota Mircea. All rights reserved.
//

#import "PlayingSetViewController.h"
#import "SetCardDeck.h"
#import "SetCard.h"
#import "CardMatchingGame.h"
#import "ConverterToAttribute.h"
#import "SetCardView.h"
#import "Grid.h"

@interface PlayingSetViewController () <UIDynamicAnimatorDelegate>
@property (weak, nonatomic) IBOutlet UIView *boardGameView;
@property (strong,nonatomic) Grid *grid;
@property (nonatomic) CGSize maxCardSize;
@property (nonatomic) NSUInteger numberViews;
@property (strong,nonatomic) NSMutableArray *cellCenters; //of CGPoints
@property (strong,nonatomic) NSMutableArray *indexCardsForCardsView; //of NSUIntegers
@property (strong,nonatomic) NSMutableArray *cardsViewDraw; //of UIViews
@property (strong,nonatomic) NSMutableArray *remainingCards; // of UIViews
@property (strong,nonatomic) SetCardDeck *deck;
@property (nonatomic) BOOL wasPinched;
@property (strong,nonatomic) UIDynamicAnimator *animator;
@property (strong,nonatomic) NSMutableArray *attachementsForCards;
@end

@implementation PlayingSetViewController

NSInteger cardcounter;

-(BOOL) gameMode {
    return false;
}



-(Deck *)createDeck {
    _deck = [[SetCardDeck alloc] init];
    return _deck;
}

-(NSInteger) startingNumberOfCards {
    cardcounter = 12;
    return 12;
}

- (NSUInteger)numberViews
{
    if (_numberViews == 0 || !self.game.cards) {
        _numberViews = [self startingNumberOfCards];
    } else {
        _numberViews =[self.game.cards count];
    }
    return _numberViews;
}

@synthesize remainingCards = _remainingCards;

- (NSMutableArray *)remainingCards {
    if(!_remainingCards) {
    _remainingCards = [[NSMutableArray alloc] init];
        
    }
    return _remainingCards;
}

- (void) setRemainingCards:(NSMutableArray *)remainingCards {
    _remainingCards = remainingCards;
}

- (void)addCardViewsToTheBoard:(UIView*)view
{

    CGPoint point = CGPointMake(self.view.bounds.size.width / 2.0f,
                                -self.view.bounds.size.height);
    int i=0;
    // Adding the setCardsView to the superview with animation
    
    for (UIView *cardView in self.cardsViewDraw) {
        if(!((SetCardView *)cardView).wasAnimated) {
        cardView.center = point;
        [view addSubview:cardView];
        [UIView animateWithDuration:0.65f
                              delay:0.5f+(i*0.1f)
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^
         {
             NSUInteger index = [self.cardsViewDraw indexOfObject:cardView];
             CGPoint center = [self.cellCenters[index] CGPointValue];
            cardView.center = center;
             ((SetCardView *)cardView).wasAnimated = true;
         }
                         completion:nil];
        i++;
        }else {
            [view addSubview:cardView];
        }
    }
    
    
}

- (Grid *)grid
{
    if (!_grid)
    {
        CGSize maxCardSize1 = CGSizeMake(220.0, 300.0);
        _grid =[[Grid alloc] init];
        _grid.size = self.boardGameView.bounds.size;
        _grid.cellAspectRatio =  maxCardSize1.width/maxCardSize1.height;
        _grid.minimumNumberOfCells = self.startingNumberOfCards;
        _grid.maxCellWidth = maxCardSize1.width;
        _grid.maxCellHeight = maxCardSize1.height;
    }
    return _grid;
}

- (NSMutableArray *)cellCenters
{
    if (!_cellCenters) _cellCenters = [[NSMutableArray alloc] init];
    return _cellCenters;
}

- (IBAction)addThreeCards:(id)sender {
    
    if(cardcounter != 81) {
        for(UIView *cards in self.cardsViewDraw) {
            [cards removeFromSuperview];
        }
        
        for(int i=0;i<3;i++) {
           Card *card = [self.deck drawRandomCard];
            [self.game.cards addObject:card];
        }
        cardcounter +=3;

        [self resetCardsViewDraw];
        
            //setting the wasAnimated Bool to true to animate only then new cards
            for(int i=0;i<[self.cardsViewDraw count] - 3;i++) {
                ((SetCardView *)[self.cardsViewDraw objectAtIndex:i]).wasAnimated = true;
            }
        
        for(SetCardView *view in self.cardsViewDraw) {
            if([view isKindOfClass:SetCardView.class]) {
                [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCard:)]];
            }
        }
        
        [self addCardViewsToTheBoard:self.boardGameView];
        [self updateUI];
    }
}

- (NSMutableArray *)indexCardsForCardsView
{
    if (!_indexCardsForCardsView) _indexCardsForCardsView = [[NSMutableArray alloc] init];
    return _indexCardsForCardsView;
}

- (UIView *)cellViewForCard:(Card *)card inRect:(CGRect)rect
{
    if ([card isKindOfClass:[SetCard class]]) {
        SetCard *setCard =(SetCard *)card;
        SetCardView *newSetCardView = [[SetCardView alloc]  initWithFrame:rect];
        newSetCardView.opaque = NO;
        
        newSetCardView.number = setCard.number;
        newSetCardView.symbol = setCard.symbol;
        newSetCardView.color = setCard.color;
        newSetCardView.shading = setCard.shading;
        
        return newSetCardView;
    }
    return nil;
}

- (void)updateCell:(UIView *)cell usingCard:(Card *)card animate:(BOOL)animate
{
    SetCardView *setCardView = (SetCardView *)cell;
    if ([card isKindOfClass:[SetCard class]]) {
        SetCard *setCard = (SetCard *)card;
        setCardView.number = setCard.number;
        setCardView.symbol = setCard.symbol;
        setCardView.color = setCard.color;
        setCardView.shading = setCard.shading;
    }
}

#define SCALE_FACTOR 0.95

- (void) resetCardsViewDraw {
    _cardsViewDraw = [[NSMutableArray alloc] init];
    self.cellCenters =nil;
    self.indexCardsForCardsView =nil;
    NSUInteger numberCardsInPlay = [self numberViews] - 1;
   self.grid.minimumNumberOfCells = [self numberViews];
    NSUInteger columnCount =self.grid.columnCount;
    NSUInteger j =0;
    for (NSUInteger i=0; i<= numberCardsInPlay; i++) {
        Card *card = [self.game cardAtIndex:i];
        if (!card.isMatched) {
            NSUInteger row = (j+0.5)/columnCount;
            NSUInteger column =j%columnCount;

            CGPoint center = [self.grid centerOfCellAtRow:row inColumn:column];
            CGRect frame = [self.grid frameOfCellAtRow:row inColumn:column];

            CGRect frameForCard = CGRectInset(frame,
                                        frame.size.width * (1.0 - SCALE_FACTOR),
                                        frame.size.height * (1.0 - SCALE_FACTOR));
            UIView *cardView = [self cellViewForCard:card inRect:frameForCard];
            [_cardsViewDraw addObject:cardView];
            self.cellCenters[j]= [NSValue valueWithCGPoint:center];
            self.indexCardsForCardsView[j]= [NSNumber numberWithInteger: i];
            j++;
        }
    
    }
    
}

- (NSMutableArray *)cardsViewDraw
{
    if (!_cardsViewDraw)
    {
        _cardsViewDraw = [[NSMutableArray alloc] init];
        self.cellCenters =nil;
        self.indexCardsForCardsView =nil;
        NSUInteger numberCardsInPlay = [self numberViews] - 1;
        NSUInteger columnCount =self.grid.columnCount;
        NSUInteger j =0;
        for (NSUInteger i=0; i<= numberCardsInPlay; i++) {
            Card *card = [self.game cardAtIndex:i];
            if (!card.isMatched) {
                NSUInteger row = (j+0.5)/columnCount;
                NSUInteger column =j%columnCount;
                
                CGPoint center = [self.grid centerOfCellAtRow:row inColumn:column];
                CGRect frame = [self.grid frameOfCellAtRow:row inColumn:column];
                
                CGRect frameForCard = CGRectInset(frame,
                                            frame.size.width * (1.0 - SCALE_FACTOR),
                                            frame.size.height * (1.0 - SCALE_FACTOR));
                UIView *cardView = [self cellViewForCard:card inRect:frameForCard];
                [_cardsViewDraw addObject:cardView];
                self.cellCenters[j]= [NSValue valueWithCGPoint:center];
                self.indexCardsForCardsView[j]= [NSNumber numberWithInteger: i];
                j++;
            }
        }
    }
    return _cardsViewDraw;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(orientationChanged:)
     name:UIDeviceOrientationDidChangeNotification
     object:[UIDevice currentDevice]];
    
    self.maxCardSize = CGSizeMake(120.0, 120.0);
    
    for (UIView *view in self.cardsViewDraw) {
        if([view isKindOfClass:SetCardView.class]) {
            [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCard:)]];
        }
        
    }
    [self.boardGameView addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(animateCards)]];
    [self.boardGameView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)]];
        
        [self addCardViewsToTheBoard:self.boardGameView];
    
    [self updateUI];
}

- (void) redealCards{
    CardMatchingGame *newGame = [[CardMatchingGame alloc] initWhitCardCount:[self startingNumberOfCards] usingDeck:[self createDeck] withGameMode:[self gameMode]];
    self.game = newGame;
    self.cardIndex = -1;
    
    for(UIView *cards in self.cardsViewDraw) {
        [cards removeFromSuperview];
    }
    
    [self resetCardsViewDraw];

    for(SetCardView *view in self.cardsViewDraw) {
        if([view isKindOfClass:SetCardView.class]) {
            [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCard:)]];
        }
    }
    
    [self addCardViewsToTheBoard:self.boardGameView];
    [self updateUI];
}

- (IBAction)tapCard:(UITapGestureRecognizer *)sender {
    if(self.wasPinched == false) {
    self.cardIndex = (NSInteger)[self.cardsViewDraw indexOfObject:sender.view];
    
    
    [self.game chooseCardAtIndex:self.cardIndex];
    [self updateUI];
    }else {
        [self tapReposition];
        self.wasPinched = false;
    }
}




- (void) updateUI {
    BOOL cardsMatched = false;
    NSMutableArray *cardsToAnimate = [[NSMutableArray alloc] init];
    
    for(SetCardView *cardButton in self.cardsViewDraw) {
        NSInteger cardIndex1 = [self.cardsViewDraw indexOfObject:cardButton];

        Card *card = [self.game cardAtIndex:cardIndex1];

        if(card.isChosen){
            UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:cardButton.bounds];
            cardButton.layer.masksToBounds = NO;
            cardButton.layer.shadowColor = [UIColor blackColor].CGColor;
            cardButton.layer.shadowOffset = CGSizeMake(10.0f, 5.0f);  /*Change value of X n Y as per your need of shadow to appear to like right bottom or left bottom or so on*/
            cardButton.layer.shadowOpacity = 0.5f;
            cardButton.layer.shadowPath = shadowPath.CGPath;
        }else {
            cardButton.layer.masksToBounds = NO;
            cardButton.layer.shadowOffset = CGSizeMake(-10.0f, -5.0f);  /*Change value of X n Y as per your need of shadow to appear to like right bottom or left bottom or so on*/
            cardButton.layer.shadowOpacity = -0.5f;
        }


        if(card.isMatched) {
            cardsMatched = true;
             [cardsToAnimate addObject:cardButton];
        }


        SetCard *setCard = (SetCard *) card;
        cardButton.number = setCard.number;
        cardButton.symbol = setCard.symbol;
        cardButton.shading = setCard.shading;
        cardButton.color = setCard.color;

    }
    
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %ld",(long)self.game.score];
    self.scoreInfoLabel.attributedText = self.game.scoreInfo;
    NSMutableArray *remains;
    
    /* if there was a match
        we use the remains array to have all the unmatched cards
     */
    if(cardsMatched) {
        remains = [[NSMutableArray alloc] init];
        for(Card *card in self.game.cards) {
            if(!card.isMatched) {
                [remains addObject:card];
            }
        }

        CGPoint point = CGPointMake(self.view.bounds.size.width / 2.0f,
                                    -self.view.bounds.size.height);
        
        //animation for removing the matched cards
        for(UIView *buttonToAnimate in cardsToAnimate) {
            [self.cardsViewDraw removeObject:buttonToAnimate];

            [UIView animateWithDuration:0.3
                                  delay:0.0
                                options:UIViewAnimationOptionCurveEaseIn
                             animations:^
             {
                 buttonToAnimate.center = point;
             }
                             completion:^(BOOL finished){ [buttonToAnimate removeFromSuperview];
                                 for (UIGestureRecognizer *recognizer in buttonToAnimate.gestureRecognizers) {
                                     [buttonToAnimate removeGestureRecognizer:recognizer];
                                 }
                                 for (UIGestureRecognizer *recognizer in buttonToAnimate.gestureRecognizers) {
                                     [buttonToAnimate removeGestureRecognizer:recognizer];
                                 }
                                 [buttonToAnimate removeFromSuperview];
                                 self.remainingCards = remains;
                                 
                                 for(SetCardView *cardButton in self.cardsViewDraw) {
                                     
                                     
                                     [cardButton removeFromSuperview];
                                 }
                                 
                                 self.game.cards = self.remainingCards;
                                 
                                 [self resetCardsViewDraw];
                                 
                                 for(int i=0;i<[self.cardsViewDraw count];i++) {
                                     ((SetCardView *)[self.cardsViewDraw objectAtIndex:i]).wasAnimated = true;
                                 }
                                 
                                 for (UIView *view in self.cardsViewDraw) {
                                     if([view isKindOfClass:SetCardView.class]) {
                                         [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCard:)]];
                                     }
                                 }
                                 
                                 [self addCardViewsToTheBoard:self.boardGameView];
                                 [self updateUI];
                             }];
        }
        
       
   }
}

- (void) orientationChanged:(NSNotification *)note {
    for(SetCardView *card in self.cardsViewDraw) {
        [card removeFromSuperview];
    }
    self.grid.size = self.boardGameView.bounds.size;
    [self resetCardsViewDraw];
    
    for(int i=0;i<[self.cardsViewDraw count];i++) {
        ((SetCardView *)[self.cardsViewDraw objectAtIndex:i]).wasAnimated = true;
    }
    
    for (UIView *view in self.cardsViewDraw) {
        if([view isKindOfClass:SetCardView.class]) {
            [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCard:)]];
        }
    }
    
    [self addCardViewsToTheBoard:self.boardGameView];
    [self updateUI];
}

/* selector for the pinchGesture
   We are moving the cards to in a stack to a CGPoint, being the center of the first card
*/

- (void)animateCards {
    self.wasPinched = true;
    for(UIView *buttonToAnimate in self.cardsViewDraw) {
       
        [UIView animateWithDuration:0.65
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^
         {
             CGPoint point = [self.cellCenters[0] CGPointValue];
             buttonToAnimate.center = point;
         }
                         completion:NULL];
 
    }
}

/*
  Having the BOOL property wasPinched, if it was true, the tapCard method will call this one to reposition the cards in their cells.
 */

- (void)tapReposition {
    for(UIView *buttonToAnimate in self.cardsViewDraw) {
        [UIView animateWithDuration:0.65
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^
         {
             CGPoint point = [self.cellCenters[[self.cardsViewDraw indexOfObject:buttonToAnimate]] CGPointValue];
             buttonToAnimate.center = point;
         }
                         completion:NULL];
    }
}

- (UIDynamicAnimator *)animator
{
    if (!_animator) {
        _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.boardGameView];
        _animator.delegate = self;
    }
    return _animator;
}

// array with UIAttachmentBehavior of every cardView to update them at every State that was changed.
-(NSMutableArray *)attachementsForCards
{
    if (!_attachementsForCards) _attachementsForCards = [[NSMutableArray alloc] init];
    return _attachementsForCards;
}

// this method will add UIAttachmentBehavior to every cardView and then add the behavior to the animator.
- (void)attachCardsViewToPoint:(CGPoint)anchorPoint
{
    for (UIView *cardView in self.cardsViewDraw) {
        UIAttachmentBehavior *attachment = [[UIAttachmentBehavior alloc]
                                            initWithItem:cardView attachedToAnchor:anchorPoint];
        [self.attachementsForCards addObject:attachment];
        [self.animator addBehavior:attachment];
    }
}

// selector for the pan gesture, working only if a pinched was done.
- (void)pan:(UIPanGestureRecognizer *)gesture
{
    CGPoint gesturePoint =[gesture locationInView:self.boardGameView];
    
    if (self.wasPinched) {
        if (gesture.state == UIGestureRecognizerStateBegan) {
            [self attachCardsViewToPoint:gesturePoint];
        } else if (gesture.state == UIGestureRecognizerStateChanged) {
            for (UIAttachmentBehavior *attachment in self.attachementsForCards) {
                attachment.anchorPoint = gesturePoint;
            }
        } else if (gesture.state == UIGestureRecognizerStateEnded) {
            for (UIAttachmentBehavior *attachment in self.attachementsForCards) {
                [self.animator removeBehavior:attachment];
            }
        }
    }
}


- (UIImage *)backgroundImageForCard:(Card *)card {
    
    return [UIImage imageNamed:@"cardfront"];
}


- (NSAttributedString *)titleForCard:(Card *)card {
    ConverterToAttribute *converter = [[ConverterToAttribute alloc] init];
    
    return [converter convert:card withNewLine:YES];
}


@end
