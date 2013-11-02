//
//  MusicPlayer.h
//  MusicPlayPauseVolumeRate
//
//  Created by Marcelo Toledo on 10/25/13.
//  Copyright (c) 2013 Marcelo Mingatos de Toledo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

@interface MyAvAudioPlayer : NSObject

@property(nonatomic) BOOL isPlaying;
@property(nonatomic) BOOL wasPlaying;
@property(nonatomic) CGFloat maxVolume;

- (id)initWithMP3FileName:(NSString *)mp3FileName;

- (void)play;
- (void)pause;
- (void)togglePlayPause;
- (void)setVolumeToValue:(CGFloat)volumeValue;
- (void)setRateToValue:(CGFloat)rateValue;

@end
