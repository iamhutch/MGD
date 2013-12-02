//
//  WoodChuckLayer.h
//  testApp
//
//  Created by Lucy Hutcheson on 12/1/13.
//  Copyright (c) 2013 Lucy Hutcheson. All rights reserved.
//

#import "CCLayer.h"
#import "cocos2d.h"
#import "SimpleAudioEngine.h"


@interface WoodChuckGame : CCLayer
{
    CGSize winSize;
    CCSprite *_player;
    CCSprite *_wood;
    CCSprite *_tractor;
    CGRect _playerRect;
    CGRect _woodRect;
    CGRect _tractorRect;
}

+(CCScene *) scene;

@end
