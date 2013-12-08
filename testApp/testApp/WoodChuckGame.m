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
@synthesize _woodchuckWalk, _woodchuckHit, collisionAction, walkAction, walkingAnimation, collisionAnimation;

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
        
        // BACKGROUND
        CCSprite *background;
		if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ) {
			background = [CCSprite spriteWithFile:@"bg.png"];
		}
		background.position = ccp(winSize.width/2, winSize.height/2);
		[self addChild: background];

        // PROGRESS BAR AT THE TOP AS AN EVENT
        _bar = [CCSprite spriteWithFile:@"bar.png"];
        _bar.position = ccp(0.0, 300);
        _bar.anchorPoint = ccp(0.0,0.5);
        [self addChild:_bar z:5];
        
                
        // WOODCHUCKS
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"woodchuck-anim-ipadhd.plist"];
        
        // WOODCHUCK ANIMATIONS ================================
        NSMutableArray *walkingFrames = [NSMutableArray array];
        NSMutableArray *collisionFrames = [NSMutableArray array];
        for (int i=0; i<=1; i++)
        {
            [walkingFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"woodchuck-walking0%d.png", i]]];
            [collisionFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"woodchuck-hit0%d.png", i]]];
        }
        
        _woodchuckWalk = [CCSprite spriteWithSpriteFrameName:@"woodchuck-walking00.png"];
        _woodchuckWalk.position = ccp(_woodchuckWalk.contentSize.width/2, 90);
        [_woodchuckWalk setVisible:YES];
        [self addChild:_woodchuckWalk];
        
        _woodchuckHit = [CCSprite spriteWithSpriteFrameName:@"woodchuck-hit00.png"];
        _woodchuckHit.position = ccp(_woodchuckWalk.position.x, 90);
        [_woodchuckHit setVisible:NO];
        [self addChild:_woodchuckHit];
        
        walkingAnimation = [CCAnimation animationWithSpriteFrames:walkingFrames delay:0.25f];
        walkAction = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:walkingAnimation]];
        [_woodchuckWalk runAction:walkAction];
        
        collisionAnimation = [CCAnimation animationWithSpriteFrames:collisionFrames delay:0.5f];
        collisionAction = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:collisionAnimation]];
        [_woodchuckHit runAction:collisionAction];

        
        
        // PILE OF WOOD
        _wood = [CCSprite spriteWithFile:@"wood.png"];
        _wood.position = ccp(400, 60);
        [self addChild:_wood];
        
        
        // FARMER TRACTOR ANIMATION
        NSMutableArray *tractorFrames = [NSMutableArray array];
        for (int i=0; i<=3; i++)
        {
            [tractorFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"tractor-%d.png", i]]];
        }
        
        _tractor = [CCSprite spriteWithSpriteFrameName:@"tractor-0.png"];
        _tractor.position = ccp(-(_tractor.contentSize.width), 140);
        [self addChild:_tractor];
        
        tractorAnimation = [CCAnimation animationWithSpriteFrames:tractorFrames delay:0.25f];
        tractorAction = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:tractorAnimation]];
        [_tractor runAction:tractorAction];

        
        
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

// START WOODCHUCK WALKING WITH LINEAR INTERPOLATION
- (void)sendWoodChuck
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"running.caf"];
    [_woodchuckWalk runAction:[CCMoveTo actionWithDuration:4.0 position:ccp(ccpLerp(_woodchuckWalk.position, _wood.position, 1).x-50, 90)]];
    [_woodchuckWalk setVisible:YES];
    [_woodchuckHit runAction:[CCMoveTo actionWithDuration:4.0 position:ccp(ccpLerp(_woodchuckWalk.position, _wood.position, 1).x-50, 90)]];
    [_woodchuckHit setVisible:NO];
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
    
    // CHECK IF WOODCHUCK HAS MET UP WITH WOODPILE
    if (CGRectIntersectsRect(_playerRect, _woodRect))
    {
        [[SimpleAudioEngine sharedEngine] playEffect:@"crunch.caf"];
    }
    else
    {
        [[SimpleAudioEngine sharedEngine] playEffect:@"running.caf"];
    }
    [_woodchuckWalk runAction: [CCMoveBy actionWithDuration:1 position:ccp(10,0)]];
    [_woodchuckHit runAction: [CCMoveBy actionWithDuration:1 position:ccp(10,0)]];
   
}

// RETURN THE CGRECT OF OUR WOODCHUCK
-(CGRect)rectPlayer
{
    return  CGRectMake(_woodchuckWalk.position.x - (_woodchuckWalk.contentSize.width/2),
                       _woodchuckWalk.position.y - (_woodchuckWalk.contentSize.height/2),
                       _woodchuckWalk.contentSize.width, _woodchuckWalk.contentSize.height);
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
                      _tractor.contentSize.width-20, _tractor.contentSize.height);
}


// CHECK THE STATUS OF OUR SPRITES
-(void) tick:(ccTime) dt {
    
    _bar.scaleX = (float) _woodchuckWalk.position.x;

    _playerRect = [self rectPlayer];
    _woodRect = [self rectWood];
    _tractorRect = [self rectTractor];
    
    // CHECK IF WOODCHUCK HAS MET UP WITH WOODPILE
    if (CGRectIntersectsRect(_playerRect, _woodRect))
    {
        [_woodchuckWalk setVisible:NO];
        [_woodchuckHit setVisible:YES];
    }
    else
    {
        [_woodchuckHit setVisible:NO];
        [_woodchuckWalk setVisible:YES];
    }
    
    // IF WOODCHUCK IS NOT OFFSCREEN AND TRACTOR INTERSECTS WITH WOODCHUCK,
    // PLAY GAME OVER SONG AND SHOW GAME OVER SCREEN
    if ((_woodchuckWalk.position.x < winSize.width) && (CGRectIntersectsRect(_tractorRect, _playerRect)))
    {
        [[SimpleAudioEngine sharedEngine] playEffect:@"hit.caf"];
        [[SimpleAudioEngine sharedEngine] setEffectsVolume:0.2f];
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1 scene:[GameOver node] ]];
    }
    
    // IF WOODCHUCK IS SAFELY OFFSCREEN, TAKE US BACK TO START
    if (_woodchuckWalk.position.x-50 > winSize.width) {
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1 scene:[Start node] ]];
    }
    
}

- (void) dealloc
{
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeUnusedSpriteFrames];

	[super dealloc];
}

@end
