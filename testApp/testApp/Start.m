//
//  Start.m
//  testApp
//
//  Created by Lucy Hutcheson on 12/2/13.
//  Copyright (c) 2013 Lucy Hutcheson. All rights reserved.
//

#import "Start.h"
#import "WoodChuckGame.h"
#import "Credits.h"
#import "Help.h"

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
        surface = [CCDirector sharedDirector].winSizeInPixels;
        CCSprite *background;
		
        // SETUP BACKGROUND
		if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone )
        {
            if (surface.width > 480)
            {
                background = [CCSprite spriteWithFile:@"start_hd.png"];
            }
            else
            {
                background = [CCSprite spriteWithFile:@"start.png"];
            }
		}
        else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            if (surface.width > 1024)
            {
                background = [CCSprite spriteWithFile:@"start_ipad_hd.png"];
            }
            else
            {
                background = [CCSprite spriteWithFile:@"start_ipad.png"];
            }
        }

		background.position = ccp(winSize.width/2.0f, winSize.height/2.0f);
		[self addChild: background];

        // SETUP MENUS WITH BLOCKS
        CCMenuItemImage *startMenu = [CCMenuItemImage itemWithNormalImage:@"menu_start.png"
                                                            selectedImage:nil
                                                                    block:^(id sender)  {
                                                                        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1 scene:[WoodChuckGame node]]];
                                                                    }
                                      ];
        startMenu.position = ccp(surface.width/4.0f, surface.height*0.40f);
        startMenu.tag = 0;

        CCMenuItemImage *helpMenu = [CCMenuItemImage itemWithNormalImage:@"menu_help.png"
                                                            selectedImage:nil
                                                                    block:^(id sender)  {
                                                                        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1 scene:[Help node]]];
                                                                    }
                                      ];
        helpMenu.position = ccp(surface.width/4.0f, surface.height*0.27f);
        helpMenu.tag = 1;

        CCMenuItemImage *creditMenu = [CCMenuItemImage itemWithNormalImage:@"menu_credits.png"
                                                           selectedImage:nil
                                                                   block:^(id sender)  {
                                                                       [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1 scene:[Credits node]]];
                                                                   }
                                     ];
        creditMenu.position = ccp(surface.width/4.0f, surface.height*0.15f);
        creditMenu.tag = 2;

        CCMenu *menuStart = [CCMenu menuWithItems:startMenu, helpMenu, creditMenu, nil];
        menuStart.position = CGPointZero;
        [self addChild:menuStart z:10];

        
        
    }
    return self;
}


- (void)menuButtonPressed:(CCMenuItem  *) menuItem
{
    switch ((long)menuItem.tag) {
        case 0:
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1 scene:[WoodChuckGame node]]];
            break;
        case 1:
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1 scene:[WoodChuckGame node]]];
            break;
        case 2:
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1 scene:[Credits node]]];
            break;
            
        default:
            break;
    }
}



@end
