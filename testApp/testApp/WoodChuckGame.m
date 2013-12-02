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
#import "Start.h"

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
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"hit.caf"];
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
        [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self
                                                         priority:0
                                                  swallowsTouches:YES];

    }
    return self;
}

// START WOODCHUCK WALKING
- (void)sendWoodChuck
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"running.caf"];
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
    
    // CHECK IF WOODCHUCK HAS MET UP WITH WOODPILE
    if (CGRectIntersectsRect(_playerRect, _woodRect))
    {
        [[SimpleAudioEngine sharedEngine] playEffect:@"crunch.caf"];
    }
    else
    {
        [[SimpleAudioEngine sharedEngine] playEffect:@"running.caf"];
    }
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
    
    // CHECK IF WOODCHUCK HAS MET UP WITH WOODPILE
    if (CGRectIntersectsRect(_playerRect, _woodRect))
    {
        CCLOG(@"Will transition to eating woodchuck animation later.");
    }
    
    // IF WOODCHUCK IS NOT OFFSCREEN AND TRACTOR INTERSECTS WITH WOODCHUCK,
    // PLAY GAME OVER SONG AND SHOW GAME OVER SCREEN
    if ((_player.position.x < winSize.width) && (CGRectIntersectsRect(_tractorRect, _playerRect)))
    {
        [[SimpleAudioEngine sharedEngine] playEffect:@"hit.caf"];
        [[SimpleAudioEngine sharedEngine] setEffectsVolume:0.2f];
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1 scene:[GameOver node] ]];
    }
    
    // IF WOODCHUCK IS SAFELY OFFSCREEN, TAKE US BACK TO START
    if (_player.position.x + 50 > winSize.width) {
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1 scene:[Start node] ]];
    }
    
}

- (void) dealloc
{
	[super dealloc];
}

@end
