//
//  SetCardView.m
//  Matchismo
//
//  Created by Dragota Mircea on 04/12/2017.
//  Copyright © 2017 Dragota Mircea. All rights reserved.
//

#import "SetCardView.h"

@interface SetCardView()
@property (nonatomic) CGFloat faceCardScaleFactor;
@end

@implementation SetCardView

#pragma mark - Properties

#define DEFAULT_FACE_CARD_SCALE_FACTOR 0.90

@synthesize faceCardScaleFactor = _faceCardScaleFactor;

- (void) setColor:(NSString *)color {
    _color = color;
    [self setNeedsDisplay];
}

- (void) setWasAnimated:(BOOL)wasAnimated {
    _wasAnimated = wasAnimated;
}

- (void) setNumber:(int)number {
    _number = number;
    [self setNeedsDisplay];
}

- (void) setSymbol:(NSString *)symbol {
    _symbol = symbol;
    [self setNeedsDisplay];
}

- (void) setShading:(NSString *)shading {
    _shading = shading;
    [self setNeedsDisplay];
}

- (CGFloat)faceCardScaleFactor
{
    if (!_faceCardScaleFactor) _faceCardScaleFactor = DEFAULT_FACE_CARD_SCALE_FACTOR;
    return _faceCardScaleFactor;
}

- (void)setFaceCardScaleFactor:(CGFloat)faceCardScaleFactor
{
    _faceCardScaleFactor = faceCardScaleFactor;
    [self setNeedsDisplay];
}

-(void)setup {
    self.backgroundColor = nil;
    self.opaque = NO;
    self.contentMode = UIViewContentModeRedraw;
}

-(void)awakeFromNib {
    [super awakeFromNib];
    [self setup];
}



-(void)pinch:(UIPinchGestureRecognizer *)gesture {
    if ((gesture.state == UIGestureRecognizerStateChanged) ||
        (gesture.state == UIGestureRecognizerStateEnded)) {
        self.faceCardScaleFactor *= gesture.scale;
        gesture.scale = 1.0;
    }
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [self setup];
    return self;
}

#define CORNER_FONT_STANDARD_HEIGHT 180.0
#define CORNER_RADIUS 12.0

-(CGFloat)cornerScaleFactor {
    return self.bounds.size.height / CORNER_FONT_STANDARD_HEIGHT;
}
-(CGFloat)cornerRadius {
    return CORNER_RADIUS * [self cornerScaleFactor];
}

-(CGFloat)cornerOffset {
    return [self cornerRadius] / 3.0;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:[self cornerRadius]];
    
    [roundedRect addClip];
    
    [[UIColor whiteColor] setFill];
    [roundedRect fill];
    
    [[UIColor blackColor] setStroke];
    [roundedRect stroke];
    
    
    
    [self drawShape:self.number withShading:self.shading withColor:self.color draw:self.symbol];

}


- (void)drawDiamondAtPosition:(CGPoint)pos withColor:(UIColor *)color withShading:(NSString *) shading{
    UIBezierPath *diamondPath = [UIBezierPath bezierPath];
    diamondPath = [UIBezierPath bezierPath];
    [diamondPath moveToPoint:CGPointMake(pos.x - self.bounds.size.width/3, pos.y)];
    [diamondPath addLineToPoint:CGPointMake(pos.x, pos.y+self.bounds.size.height/10)];
    [diamondPath addLineToPoint:CGPointMake(pos.x+self.bounds.size.width/3,pos.y)];
    [diamondPath addLineToPoint:CGPointMake(pos.x,pos.y-self.bounds.size.height/10)];
    [diamondPath closePath];
    
    if([shading isEqualToString:@"open"]) {
        [color setStroke];
        [diamondPath stroke];
    }else if([shading isEqualToString:@"solid"]) {
        [color setFill];
        [diamondPath fill];
    }else if([shading isEqualToString:@"striped"]) {
        CGRect bounds = diamondPath.bounds;
        UIBezierPath *stripes = [UIBezierPath bezierPath];
        for ( int x = 0; x < bounds.size.width; x += 5 )
        {
            [stripes moveToPoint:CGPointMake( bounds.origin.x + x, bounds.origin.y )];
            [stripes addLineToPoint:CGPointMake( bounds.origin.x + x, bounds.origin.y + bounds.size.height )];
        }
        [stripes setLineWidth:2];
        [stripes closePath];
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        
       
        CGContextSaveGState(context);
        [diamondPath addClip];
        
        [color set];
        [stripes stroke];
        
        CGContextRestoreGState(context);
       
        [color set];
        [diamondPath stroke];
    }
}

- (void)drawOvalAtPosition:(CGPoint)pos withColor:(UIColor *)color withShading:(NSString *) shading{
    
    UIBezierPath *ovalPath = [UIBezierPath bezierPath];
    [ovalPath moveToPoint:CGPointMake(pos.x - 8 ,pos.y-self.bounds.size.height/10)];
    [ovalPath addQuadCurveToPoint:CGPointMake(pos.x - self.bounds.size.width/3, pos.y) controlPoint:CGPointMake(pos.x-20,pos.y-self.bounds.size.height/10) ];
    [ovalPath addQuadCurveToPoint:CGPointMake(pos.x - 8, pos.y+self.bounds.size.height/10) controlPoint:CGPointMake(pos.x-20, pos.y+self.bounds.size.height/10)];
    
     [ovalPath addLineToPoint:CGPointMake(pos.x + 8,pos.y+self.bounds.size.height/10)];
    
   
    [ovalPath addQuadCurveToPoint:CGPointMake(pos.x + self.bounds.size.width/3 , pos.y) controlPoint:CGPointMake(pos.x+20,pos.y+self.bounds.size.height/10)];
    [ovalPath addQuadCurveToPoint:CGPointMake(pos.x + 8, pos.y-self.bounds.size.height/10) controlPoint:CGPointMake(pos.x+20, pos.y-self.bounds.size.height/10)];
    [ovalPath addLineToPoint:CGPointMake(pos.x - 8,pos.y-self.bounds.size.height/10)];
    [ovalPath closePath];
    
    if([shading isEqualToString:@"open"]) {
        [color setStroke];
        [ovalPath stroke];
    }else if([shading isEqualToString:@"solid"]) {
        [color setFill];
        [ovalPath fill];
    }else if([shading isEqualToString:@"striped"]) {
        CGRect bounds = ovalPath.bounds;
        UIBezierPath *stripes = [UIBezierPath bezierPath];
        for ( int x = 0; x < bounds.size.width; x += 5 )
        {
            [stripes moveToPoint:CGPointMake( bounds.origin.x + x, bounds.origin.y )];
            [stripes addLineToPoint:CGPointMake( bounds.origin.x + x, bounds.origin.y + bounds.size.height )];
        }
        [stripes setLineWidth:2];
        [stripes closePath];
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        
        CGContextSaveGState(context);
        [ovalPath addClip];
        
        [color set];
        [stripes stroke];
        
        CGContextRestoreGState(context);
        
        [color set];
        [ovalPath stroke];
    }
}


- (void)drawSquiggleAtPosition:(CGPoint)pos withColor:(UIColor *)color withShading:(NSString *) shading{
    UIBezierPath *squigglePath = [UIBezierPath bezierPath];
    [squigglePath moveToPoint:CGPointMake(pos.x - self.bounds.size.width/3 - 5,pos.y)];
    
    [squigglePath addCurveToPoint:CGPointMake(pos.x + self.bounds.size.width/3 ,pos.y - self.bounds.size.height/10) controlPoint1:CGPointMake(pos.x-10,pos.y-self.bounds.size.height/4) controlPoint2:CGPointMake(pos.x+10,pos.y+self.bounds.size.height/10)];
    
    [squigglePath addQuadCurveToPoint:CGPointMake(pos.x + self.bounds.size.width/3 + 2 ,pos.y - self.bounds.size.height/10 + 15) controlPoint:CGPointMake(pos.x + self.bounds.size.width/4 + 12,pos.y - self.bounds.size.height/20 )];
    
   [squigglePath addCurveToPoint:CGPointMake(pos.x - self.bounds.size.width/3 + 10 ,pos.y + 5) controlPoint1:CGPointMake(pos.x+7,pos.y+self.bounds.size.height/5) controlPoint2:CGPointMake(pos.x,pos.y)];
    
    [squigglePath addQuadCurveToPoint:CGPointMake(pos.x - self.bounds.size.width/3 - 5 ,pos.y) controlPoint:CGPointMake(pos.x - self.bounds.size.width/3 -5  ,pos.y + self.bounds.size.height/10 + 5)];
    
    if([shading isEqualToString:@"open"]) {
        [color setStroke];
        [squigglePath stroke];
    }else if([shading isEqualToString:@"solid"]) {
        [color setFill];
        [squigglePath fill];
    }else if([shading isEqualToString:@"striped"]) {
        CGRect bounds = squigglePath.bounds;
        UIBezierPath *stripes = [UIBezierPath bezierPath];
        for ( int x = 0; x < bounds.size.width; x += 5 )
        {
            [stripes moveToPoint:CGPointMake( bounds.origin.x + x, bounds.origin.y )];
            [stripes addLineToPoint:CGPointMake( bounds.origin.x + x, bounds.origin.y + bounds.size.height )];
        }
        [stripes setLineWidth:2];
        [stripes closePath];
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        
        CGContextSaveGState(context);
        [squigglePath addClip];
        
        [color set];
        [stripes stroke];
        
        CGContextRestoreGState(context);
        
        [color set];
        [squigglePath stroke];
    }
}


- (void)drawShape:(NSInteger)number withShading:(NSString *)shading withColor:(NSString *)colorStr draw:(NSString *)drawing
{
    
    UIColor *color = nil;
    if([colorStr isEqualToString:@"red"]) {
        color = [UIColor redColor];
    } else if([colorStr isEqualToString:@"green"]) {
        color = [UIColor colorWithRed:((float) 0 / 255.0f)
                                green:((float) 137 / 255.0f)
                                 blue:((float) 0 / 255.0f)
                                alpha:1.0f];
        
    }else if([colorStr isEqualToString:@"purple"]) {
        color = [UIColor purpleColor];
    }
    
    CGFloat newHeight = self.bounds.size.height / number;
    CGFloat newWidth = self.bounds.size.width / 2;
    CGFloat firstSymbolCenterY = newHeight / 2;
    
    
    if([drawing isEqualToString:@"◼︎"]) {
        for(int i=0;i<number;i++) {
        [self drawDiamondAtPosition:CGPointMake(newWidth, firstSymbolCenterY + i * newHeight) withColor:color withShading:shading];
        }
    }else if ([drawing isEqualToString:@"●"]) {
        for(int i=0;i<number;i++) {
            [self drawOvalAtPosition:CGPointMake(newWidth, firstSymbolCenterY + i * newHeight) withColor:color withShading:shading];
        }
    }else if ([drawing isEqualToString:@"▲"]) {
        for(int i=0;i<number;i++) {
            [self drawSquiggleAtPosition:CGPointMake(newWidth, firstSymbolCenterY + i * newHeight) withColor:color withShading:shading];
        }
    }
    
    
}

-(void)disable {
    [self setAlpha:0.0];
}


- (void)pushContextAndRotateUpsideDown
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, self.bounds.size.width, self.bounds.size.height);
    CGContextRotateCTM(context, M_PI);
}

- (void)popContext
{
    CGContextRestoreGState(UIGraphicsGetCurrentContext());
}



@end
