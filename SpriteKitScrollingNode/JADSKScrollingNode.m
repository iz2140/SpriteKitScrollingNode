//
//  JADSKScrollingNode.m
//  FirstLetters
//
//  Created by Jennifer Dobson on 7/25/14.
//  Copyright (c) 2014 Jennifer Dobson. All rights reserved.
//

#import "JADSKScrollingNode.h"

@interface JADSKScrollingNode()

@property (nonatomic) CGFloat minYPosition;
@property (nonatomic) CGFloat maxYPosition;
@property (nonatomic, strong) UIPanGestureRecognizer *gestureRecognizer;
@property (nonatomic) CGFloat yOffset;

@end


static const CGFloat kScrollDuration = .3;

@implementation JADSKScrollingNode

-(id)initWithSize:(CGSize)size
{
    self = [super init];
    
    if (self)
    {
        _size = size;
        
        //makes a clear node the inititial size of the "whole" size of the scrolling node... this node will take up the space for the size of the "scrolling" node
        SKSpriteNode *canvasNode = [SKSpriteNode spriteNodeWithColor:[UIColor clearColor] size:size];
        canvasNode.anchorPoint = CGPointMake(0, 0);
        canvasNode.position = CGPointMake( 0,0);
        [self addChild:canvasNode];
         
        _yOffset = [self calculateAccumulatedFrame].origin.y; //calculates size of the scrollingNode and sets its yOffset to 0
       
    }
    return self;
    
}

//overrides addChild
//yOffset may change after adding a child node to the scrollingNode
-(void)addChild:(SKNode *)node
{
    [super addChild:node];
    _yOffset = [self calculateAccumulatedFrame].origin.y;
    NSLog(@"adding child: %@", node.name);
    NSLog(@"New yOffset: %f", self.yOffset);
    
}


-(CGFloat) minYPosition
{
    CGSize parentSize = self.parent.frame.size;
    
    NSLog(@"accumulatedFrame h: %f, actualSize h: %f, frame h: %f", self.calculateAccumulatedFrame.size.height, self.size.height, self.frame.size.height);
  
    CGFloat minPosition =(parentSize.height - self.calculateAccumulatedFrame.size.height - _yOffset); //changed from accumulated frame to actual size
    
    return minPosition;
    
    
}

-(CGFloat) maxYPosition
{
    return 0;
}

-(void)scrollToBottom
{
    self.position = CGPointMake(0, self.maxYPosition);
    
}

-(void)scrollToTop
{
    self.position = CGPointMake(0, self.minYPosition);
    
}

-(void)enableScrollingOnView:(UIView*)view
{
    if (!_gestureRecognizer) {
        _gestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanFrom:)];
        _gestureRecognizer.delegate = self;
        [view addGestureRecognizer:self.gestureRecognizer];
        }
}

-(void)disableScrollingOnView:(UIView*)view
{
    if (_gestureRecognizer) {
        [view removeGestureRecognizer:_gestureRecognizer];
        _gestureRecognizer = nil;
    }
}

-(void)handlePanFrom:(UIPanGestureRecognizer*)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        
        
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
        
        CGPoint translation = [recognizer translationInView:recognizer.view];
        translation = CGPointMake(translation.x, -translation.y);
        [self panForTranslation:translation];
        [recognizer setTranslation:CGPointZero inView:recognizer.view];
        
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
        
        CGPoint velocity = [recognizer velocityInView:recognizer.view];
        CGPoint pos = self.position;
        CGPoint p = mult(velocity, kScrollDuration);
        
        CGPoint newPos = CGPointMake(pos.x, pos.y - p.y);
        newPos = [self constrainStencilNodesContainerPosition:newPos];
        
        SKAction *moveTo = [SKAction moveTo:newPos duration:kScrollDuration];
        //SKAction *moveMask = [SKAction moveTo:[self maskPositionForNodePosition:newPos] duration:kScrollDuration];
        [moveTo setTimingMode:SKActionTimingEaseOut];
        //[moveMask setTimingMode:SKActionTimingEaseOut];
        [self runAction:moveTo];
        //[self.maskNode runAction:moveMask];
        
    }
    
}



-(void)panForTranslation:(CGPoint)translation
{
    self.position = CGPointMake(self.position.x, self.position.y+translation.y);
}

- (CGPoint)constrainStencilNodesContainerPosition:(CGPoint)position {
    
    CGPoint retval = position;
    
    retval.x = self.position.x;
    
    retval.y = MAX(retval.y, self.minYPosition);
    retval.y = MIN(retval.y, self.maxYPosition);
    
    
    return retval;
}


CGPoint mult(const CGPoint v, const CGFloat s) {
	return CGPointMake(v.x*s, v.y*s);
}


-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    SKNode* grandParent = self.parent.parent;
    
    if (!grandParent) {
        grandParent = self.parent;
    }
    CGPoint touchLocation = [touch locationInNode:grandParent];
    
    if (!CGRectContainsPoint(self.parent.frame,touchLocation)){
        return NO;
    }
    
    return YES;
}

@end
