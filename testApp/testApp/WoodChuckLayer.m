//
//  WoodChuckLayer.m
//  testApp
//
//  Created by Lucy Hutcheson on 12/1/13.
//  Copyright (c) 2013 Lucy Hutcheson. All rights reserved.
//

#import "WoodChuckLayer.h"

#import "AppDelegate.h"

@implementation WoodChuckLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	WoodChuckLayer *layer = [WoodChuckLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

- (id) init
{
	if( (self=[super init])) {
        CGSize winSize = [CCDirector sharedDirector].winSize;
        CCSprite *background;
		
		if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ) {
			background = [CCSprite spriteWithFile:@"bg.png"];
		}
		background.position = ccp(winSize.width/2, winSize.height/2);
        
		[self addChild: background];

        
        CCSprite *player = [CCSprite spriteWithFile:@"woodchuck.png"];
        player.position = ccp(player.contentSize.width/2, 90);
        [self addChild:player];
        

    }
    return self;
}

- (void) dealloc
{
	[super dealloc];
}

@end
