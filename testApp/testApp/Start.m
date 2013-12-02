//
//  Start.m
//  testApp
//
//  Created by Lucy Hutcheson on 12/2/13.
//  Copyright (c) 2013 Lucy Hutcheson. All rights reserved.
//

#import "Start.h"
#import "WoodChuckGame.h"

@implementation Start

// SETUP SCENE
+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	
	Start *layer = [Start node];
	
	[scene addChild: layer];
	
	return scene;
}

- (id) init
{
	if( (self=[super init])) {
        winSize = [CCDirector sharedDirector].winSize;
        CCSprite *background;
		
		if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ) {
			background = [CCSprite spriteWithFile:@"start.png"];
		}
		background.position = ccp(winSize.width/2, winSize.height/2);
		[self addChild: background];
        
        CCLabelTTF *label = [CCLabelTTF labelWithString:@"Click to Start" fontName:@"Helvetica" fontSize:60];
        label.color = ccc3(204,0,0);
        label.position = ccp(280, 240);
        [self addChild:label];
        
        [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self
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
