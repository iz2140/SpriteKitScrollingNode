//
//  JADMainScene.m
//  SpriteKitScrollingNode
//
//  Created by Jennifer Dobson on 7/25/14.
//  Copyright (c) 2014 Jennifer Dobson. All rights reserved.
//

#import "JADMainScene.h"
#import "JADSKScrollingNode.h"
#import "JADViewController.h"



@interface JADMainScene()

@property (nonatomic, strong) JADSKScrollingNode* scrollingNode;
//@property (nonatomic, strong) UITapGestureRecognizer* tapGestureRecognizer;
@end

@implementation JADMainScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        
        _scrollingNode = [[JADSKScrollingNode alloc] initWithSize:size];
        self.scrollingNode.position = CGPointMake(0, 0);
        
        NSLog(@"{%f, %f}", self.scrollingNode.size.width, self.scrollingNode.size.height);
        
        [self addChild:self.scrollingNode];
        
        SKLabelNode *topLabelNode = [[SKLabelNode alloc] init];
        topLabelNode.text= @"Top"; //iOS 8 specific
        
        
        SKLabelNode *bottomLabelNode = [[SKLabelNode alloc] init];
        bottomLabelNode.text = @"Bottom";
        bottomLabelNode.position = CGPointMake(50, 50);
        
        SKSpriteNode *node1 = [[SKSpriteNode alloc] initWithColor:[UIColor redColor] size:CGSizeMake(CGRectGetWidth(self.frame)*.8, CGRectGetHeight(self.frame)/2)];
        SKSpriteNode *node2 = [node1 copy];
        SKSpriteNode *node3 = [node1 copy];
        
        
        
        node1.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        node2.position = CGPointMake(node1.position.x, node1.position.y + CGRectGetWidth(node1.frame)/2);
        node3.position = CGPointMake(node1.position.x, node2.position.y + CGRectGetWidth(node1.frame)/2);
        
        topLabelNode.position = CGPointMake(CGRectGetWidth(topLabelNode.frame)/2 + 50, node3.position.y + CGRectGetHeight(node1.frame)/2);
        
        [_scrollingNode addChild:topLabelNode];
        [_scrollingNode addChild:bottomLabelNode];
        [_scrollingNode addChild:node1];
        [_scrollingNode addChild:node2];
        [_scrollingNode addChild:node3];
        
        NSLog(@"{%f, %f}", self.scrollingNode.size.width, self.scrollingNode.size.height);
        NSLog(@"{%f, %f}", [self.scrollingNode calculateAccumulatedFrame].size.width, [self.scrollingNode calculateAccumulatedFrame].size.height);
        
        
        
        SKLabelNode* otherSceneNode = [SKLabelNode node];
        otherSceneNode.text = @"Switch To Part Scrolling Scene";
        otherSceneNode.name = @"OtherSceneNode";
        otherSceneNode.position = (CGPoint){800,100};
        [self addChild:otherSceneNode];
        
    }
    return self;
}

-(void)didMoveToView:(SKView *)view
{
    
    [_scrollingNode enableScrollingOnView:view];
    [_scrollingNode scrollToTop];
    
}

-(void)willMoveFromView:(SKView *)view
{
    [_scrollingNode disableScrollingOnView:view];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *touchedNode = [self nodeAtPoint:location];
    NSString* nodeName = touchedNode.name;
    NSLog(@"{%f, %f}", location.x, location.y);
    if ([touchedNode isKindOfClass:[SKSpriteNode class]]) {
        SKAction *blueAction = [SKAction colorizeWithColor:[UIColor blueColor] colorBlendFactor:1 duration:.5];
        SKAction *redAction = [SKAction colorizeWithColor:[UIColor redColor] colorBlendFactor:1 duration:.5];
        [touchedNode runAction:[SKAction sequence:@[blueAction,redAction]]];
    }
    else if ([nodeName isEqualToString:@"OtherSceneNode"])
        [self.viewController presentPartScrollingScene];
        
}
@end
