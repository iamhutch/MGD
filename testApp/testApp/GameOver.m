//
//  GameOver.m
//  testApp
//
//  Created by Lucy Hutcheson on 12/1/13.
//  Copyright (c) 2013 Lucy Hutcheson. All rights reserved.
//

#import "GameOver.h"
#import "WoodChuckGame.h"

@implementation GameOver

// SETUP SCENE
+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	
	GameOver *layer = [GameOver node];
	
	[scene addChild: layer];
	
	return scene;
}

- (id) init
{
	if( (self=[super init])) {
        winSize = [CCDirector sharedDirector].winSize;
        CCSprite *background;
		
		if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ) {
			background = [CCSprite spriteWithFile:@"bg.png"];
		}
		background.position = ccp(winSize.width/2, winSize.height/2);
		[self addChild: background];
        
        CCLabelTTF *label = [CCLabelTTF labelWithString:@"GAME OVER" fontName:@"Helvetica" fontSize:60];
        label.position = ccp(280, 260);
        label.color = ccc3(0,0,0);
        [self addChild:label];
        
        [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self
                                                         priority:0
                                                  swallowsTouches:YES];

        
    }
    return self;
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
	return YES;
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1 scene:[WoodChuckGame node]]];
}


@end
