//
//  ConverterToAttribute.m
//  Matchismo
//
//  Created by Dragota Mircea on 24/11/2017.
//  Copyright © 2017 Dragota Mircea. All rights reserved.
//

#import "ConverterToAttribute.h"
#import "SetCard.h"
#import "PlayingCard.h"

@implementation ConverterToAttribute

-(NSAttributedString *)convert:(Card *) thisCard withNewLine:(BOOL) yes{
    NSString *contentsOfCard = [[NSString alloc]init];
    NSMutableAttributedString *content = nil;
    if([thisCard isKindOfClass:SetCard.class]){
        if(yes){
            for(int i=0;i<((SetCard*)thisCard).number;i++){
                contentsOfCard = [contentsOfCard stringByAppendingString:[((SetCard*)thisCard).symbol stringByAppendingString:@"\n"]];
            }
        }else {
            for(int i=0;i<((SetCard*)thisCard).number;i++){
                contentsOfCard = [contentsOfCard stringByAppendingString:((SetCard*)thisCard).symbol];
            }
        }
        
       content  = [[NSMutableAttributedString alloc] initWithString:contentsOfCard];
        SetCard *setCard = (SetCard *) thisCard;
        [content addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20.0] range:NSMakeRange(0,[content length])];
        
        UIColor *color = nil;
        if([setCard.color isEqualToString:@"red"]) {
            color = [UIColor redColor];
        } else if([setCard.color isEqualToString:@"green"]) {
            color = [UIColor colorWithRed:((float) 0 / 255.0f)
                                    green:((float) 137 / 255.0f)
                                     blue:((float) 0 / 255.0f)
                                    alpha:1.0f];
            
        }else if([setCard.color isEqualToString:@"purple"]) {
            color = [UIColor purpleColor];
        }
        
        if([setCard.shading isEqualToString:@"striped"]) {
            color = [color colorWithAlphaComponent:0.3];
        }else if ([setCard.shading isEqualToString:@"open"]) {
            [content addAttribute:NSStrokeWidthAttributeName value:@+3.0 range:NSMakeRange(0,[content length])];
        }
        
        [content addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0,[content length])];
        
    }else {
        contentsOfCard = [contentsOfCard stringByAppendingString:[[NSString alloc] initWithFormat:@"%lu %@",(unsigned long)((PlayingCard*)thisCard).rank,((PlayingCard*)thisCard).suit]];
        content  = [[NSMutableAttributedString alloc] initWithString:contentsOfCard];
    }
    
    
    
    return content;
}
@end
