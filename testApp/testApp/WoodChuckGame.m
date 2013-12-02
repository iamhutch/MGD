//
//  WoodChuckLayer.m
//  testApp
//
//  Created by Lucy Hutcheson on 12/1/13.
//  Copyright (c) 2013 Lucy Hutcheson. All rights reserved.
//

#import "WoodChuckGame.h"
#import "GameOver.h"
#import "AppDelegate.h"

@implementation WoodChuckGame

// SETUP SCENE
+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	
	WoodChuckGame *layer = [WoodChuckGame node];
	
	[scene addChild: layer];
	
	return scene;
}

// INITIALIZE
- (id) init
{
	if( (self=[super init])) {
        
        // SETUP AUDIO, WINDOW SIZE, BACKGROUND
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"crunch.caf"];
        winSize = [CCDirector sharedDirector].winSize;
        CCSprite *background;
		
		if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ) {
			background = [CCSprite spriteWithFile:@"bg.png"];
		}
		background.position = ccp(winSize.width/2, winSize.height/2);
		[self addChild: background];

        // WOODCHUCK
        _player = [CCSprite spriteWithFile:@"woodchuck.png"];
        _player.position = ccp(_player.contentSize.width/2, 90);
        [self addChild:_player];

        // PILE OF WOOD
        _wood = [CCSprite spriteWithFile:@"wood.png"];
        _wood.position = ccp(400, 60);
        [self addChild:_wood];
        
        // FARMER AND TRACTOR
        _tractor = [CCSprite spriteWithFile:@"tractor.png"];
        _tractor.position = ccp(-(_tractor.contentSize.width), 140);
        [self addChild:_tractor];
        
        // START OUR WOODCHUCK WALKING AND TRACTOR ROLLING
        [self sendWoodChuck];
        [self sendTractor];
        
        // SETUP TICK
        [self schedule:@selector(tick:) interval:1.0f/60.0f];
        
        // ALLOW TOUCHES
        [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self
                                                         priority:0
                                                  swallowsTouches:YES];

    }
    return self;
}

// START WOODCHUCK WALKING
- (void)sendWoodChuck
{
    [_player runAction:[CCMoveTo actionWithDuration:3.0 position:ccp(_wood.position.x-50, 90)]];
}

// START TRACTOR ROLLING
- (void)sendTractor
{
    [_tractor runAction:[CCMoveTo actionWithDuration:20.0 position:ccp(winSize.width + _tractor.contentSize.width, 140)]];
}

// START TOUCH
- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
	return YES;
}

// ON TOUCH ENDED
- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
	//CGPoint location = [touch locationInView: [touch view]];
	//CGPoint convertedLocation = [[CCDirector sharedDirector] convertToGL:location];
    
	//[_player stopAllActions];
	//[_player runAction: [CCMoveTo actionWithDuration:1 position:convertedLocation]];
    
    [[SimpleAudioEngine sharedEngine] playEffect:@"crunch.caf"];
    [_player runAction: [CCMoveBy actionWithDuration:1 position:ccp(10,0)]];

}

// RETURN THE CGRECT OF OUR WOODCHUCK
-(CGRect)rectPlayer
{
    return  CGRectMake(_player.position.x - (_player.contentSize.width/2),
                       _player.position.y - (_player.contentSize.height/2),
                       _player.contentSize.width, _player.contentSize.height);
}

// RETURN THE CGRECT OF OUR WOOD PILE
-(CGRect)rectWood
{
    return CGRectMake(_wood.position.x - (_wood.contentSize.width/2),
                      _wood.position.y - (_wood.contentSize.height/2),
                      _wood.contentSize.width, _wood.contentSize.height);
}

// RETURN THE CGRECT OF THE FARMER'S TRACTOR
-(CGRect)rectTractor
{
    return CGRectMake(_tractor.position.x - (_tractor.contentSize.width/2),
                      _tractor.position.y - (_tractor.contentSize.height/2),
                      _tractor.contentSize.width, _tractor.contentSize.height);
}


// CHECK THE STATUS OF OUR SPRITES
-(void) tick:(ccTime) dt {
    _playerRect = [self rectPlayer];
    _woodRect = [self rectWood];
    _tractorRect = [self rectTractor];
    
    if (CGRectIntersectsRect(_playerRect, _woodRect))
    {
        CCLOG(@":(");
    }
    
    if (CGRectIntersectsRect(_tractorRect, _playerRect))
    {
        [[SimpleAudioEngine sharedEngine] playEffect:@"hit.caf"];
        [[SimpleAudioEngine sharedEngine] setEffectsVolume:0.2f];
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1 scene:[GameOver node] ]];
    }
    
    if (CG)
    
    
}

- (void) dealloc
{
	[super dealloc];
}

@end
