//
//  ConverterToAttribute.h
//  Matchismo
//
//  Created by Dragota Mircea on 24/11/2017.
//  Copyright © 2017 Dragota Mircea. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "Card.h"

@interface ConverterToAttribute : NSObject
-(NSAttributedString *)convert:(Card *) thisCard withNewLine:(BOOL) yes;
@end
