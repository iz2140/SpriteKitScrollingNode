//
//  JADVerticalMenuScene.m
//  SpriteKitScrollingNode
//
//  Created by Iris Zhang on 7/9/15.
//  Copyright (c) 2015 Jennifer Dobson. All rights reserved.
//

//  This scene is a responsive (multi-device) part-scrolling vertical menu


#import "JADVerticalMenuScene.h"
#import "JADSKScrollingNode.h"

@interface JADVerticalMenuScene()

@property (nonatomic, strong) JADSKScrollingNode* scrollingNode;
@property (nonatomic, strong) SKNode *canvas;
@property (nonatomic, strong) NSArray *menuItems; //of SKSpriteNodes
@property (nonatomic, strong) SKSpriteNode *rectNode;

@end

static const CGFloat kMenuItemPadding = 50;
static const CGFloat kScrollingWindowPadding = 80;

@implementation JADVerticalMenuScene

//designated initializer
-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        

        
        //this is setting up the scrolling node's "window" -- the rect is what the user can interact with
        //_rectNode = [SKSpriteNode spriteNodeWithColor:[SKColor grayColor] size:CGSizeMake(self.frame.size.width*.8, self.frame.size.height*.8)];
        self.rectNode.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        
        //the crop node has a mask and will not allow users to interact outside the scrolling node's window
        SKSpriteNode *maskNode = [self.rectNode copy];
        SKCropNode *cropNode = [SKCropNode node];
        cropNode.maskNode = maskNode;
        [cropNode addChild:self.rectNode];
        
        self.scrollingNode.position = self.rectNode.position;
        

        for (SKSpriteNode *menuItem in self.menuItems) {
            float index = [self.menuItems indexOfObject:menuItem];
            menuItem.position = CGPointMake(0, menuItem.size.height/2 + index*(kMenuItemPadding + menuItem.size.height));
            
            NSLog(@"Positioning menuItem at height: %f", menuItem.position.y);
            [self.scrollingNode addChild: menuItem];
        }
        
        //[self.scrollingNode addChild: self.canvas];
        [self.rectNode addChild: self.scrollingNode];
        [self addChild: cropNode];
        
    }
    return self;
}

-(SKNode *) canvas{
    if (!_canvas){
        _canvas = [SKNode node];
    }
    return _canvas;
}

-(SKSpriteNode *) rectNode{
    if (!_rectNode){
        _rectNode = [SKSpriteNode spriteNodeWithColor:[SKColor grayColor] size:CGSizeMake(self.frame.size.width*.8, self.frame.size.height*.8)];

    }
    return _rectNode;
}

-(JADSKScrollingNode *) scrollingNode {
    if (!_scrollingNode){
        //CGRect sizeTemplate = [self.canvas calculateAccumulatedFrame];
        JADSKScrollingNode *scrollingNode = [[JADSKScrollingNode alloc]initWithSize:CGSizeMake(self.frame.size.width * .8, self.frame.size.height*1.5)]; //scrolling node takes up 80% of the screen horizontally but is twice the height
        
        //NSLog(@"sizeTemplate h: %f", sizeTemplate.size.height);
        NSLog(@"scrollingTemplate h: %f", scrollingNode.size.height);
        _scrollingNode = scrollingNode;
    }
    return _scrollingNode;
}

-(NSArray *) menuItems{
    if (!_menuItems) {
       // NSArray *menuItems = [NSArray array];
        
        SKSpriteNode *menuItem1 = [SKSpriteNode spriteNodeWithColor:[SKColor blueColor] size:CGSizeMake(self.frame.size.width *0.6, self.frame.size.height *0.2)];
        
        SKSpriteNode *menuItem2 = [menuItem1 copy];
        SKSpriteNode *menuItem3 = [menuItem1 copy];
        SKSpriteNode *menuItem4 = [menuItem1 copy];
        SKSpriteNode *menuItem5 = [menuItem1 copy];
        
        //menuItem1.position = CGPointMake(0, menuItem1.size.height/2 + kMenuItemPadding);
        
        NSArray *menuItems = [NSArray arrayWithObjects: menuItem1, menuItem2, menuItem3, menuItem4, menuItem5, nil];
        
        _menuItems = menuItems;
    }
    return _menuItems;
}

//implement gesture recognizers
- (void)didMoveToView:(SKView *)view {
    _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [view addGestureRecognizer:_tapGestureRecognizer];
    
    [self.scrollingNode enableScrollingOnView:view];
    [self.scrollingNode scrollToTop];
}

//remove gesture recognizers
- ( void ) willMoveFromView: (SKView *) view {
    [view removeGestureRecognizer: self.tapGestureRecognizer];
    
    [self.scrollingNode disableScrollingOnView:view];
}


- (void)handleTap:(UITapGestureRecognizer *)recognizer {
}

@end
