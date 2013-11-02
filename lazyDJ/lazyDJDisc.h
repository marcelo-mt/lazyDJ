//
//  lazyDJDisc.h
//  lazyDJ
//
//  Created by Marcelo Toledo on 11/1/13.
//  Copyright (c) 2013 Marcelo Mingatos de Toledo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OneFingerRotationGestureRecognizer.h"
#import "MyAvAudioPlayer.h"

#define SPIN_ANIMATION_CPS 60
#define SPIN_ANIMATION_DEFAULT_SPEED 180

@interface lazyDJDisc : NSObject

@property (weak, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UITapGestureRecognizer *doubleTapGestureRecognizer;
@property (strong, nonatomic) OneFingerRotationGestureRecognizer *rotationGestureRecognizer;
@property (strong, nonatomic) MyAvAudioPlayer *audio;
@property (strong, nonatomic) NSTimer *spinTimer;
@property (nonatomic) CGFloat currentAngle;
@property (nonatomic) CGFloat spinningSpeed;

- (id)initWithMP3FileName:(NSString *)mp3FileName;

//- (void)setupGestureRecognizersWithTarget:(id)target action:(id)action;
//- (void)removeGestureRecognizers;

- (void)rotateDiscByAngle:(CGFloat)angleToRotate;
- (void)addToCurrentAngle:(CGFloat)angleToAdd;

- (void)startSpinning;
- (void)stopSpinning;

@end
