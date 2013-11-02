//
//  MusicPlayer.m
//  MusicPlayPauseVolumeRate
//
//  Created by Marcelo Toledo on 10/25/13.
//  Copyright (c) 2013 Marcelo Mingatos de Toledo. All rights reserved.
//

#import "MyAvAudioPlayer.h"

@interface MyAvAudioPlayer()

@property(strong, nonatomic) NSString *fileName;

@property(nonatomic) CGFloat volumeDifferenceToMax;

@property(strong, nonatomic) AVAudioPlayer *music;

@end

@implementation MyAvAudioPlayer

- (id)initWithMP3FileName:(NSString *)mp3FileName
{
   // Initializes audio player and loads a mp3 file ready to play.
    self = [super init];
    
    if (self) {
        [self loadAudioFileByName:mp3FileName];
    }
    
    return self;
}

# pragma mark - Audio setup.

- (void)loadAudioFileByName:(NSString *)mp3FileName
{
    // Loads mp3 file and sets initial configuration.
    
    NSURL *musicPath = [[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] pathForResource:mp3FileName ofType:@"mp3"]];
    self.music = [[AVAudioPlayer alloc]initWithContentsOfURL:musicPath
                                                       error:NULL];
    self.fileName = [NSString stringWithString:mp3FileName];
    
    NSLog(@"Loaded %@.mp3", self.fileName);
    
    [self resetProperties];
    
    [self.music prepareToPlay];
}

- (void)resetProperties
{
    // (Re)sets properties to initial default values.
    self.music.volume = 1.0f;
    self.maxVolume = 1.0f;
    
    self.volumeDifferenceToMax = 0.0f;
    
    self.isPlaying = NO;
    self.wasPlaying = NO;

    self.music.numberOfLoops = -1;
    self.music.enableRate = YES;
}

- (void)setMaxVolume:(CGFloat)maxVolume
{
    //setter (limits maximum playback volume)
    [self limitMaxVolume:maxVolume];
}

- (void)limitMaxVolume:(CGFloat)volume
{
    // Limits maxVolume.
    CGFloat maxVolumeLimit = volume;
    
    if (volume > 1) {
        maxVolumeLimit = 1.0f;
    } else if (volume < 0) {
        maxVolumeLimit = 0.0f;
    }
    
    // Stores difference between full volume and
    self.volumeDifferenceToMax = 1.0 - maxVolumeLimit;
    
    NSLog(@"Limiting %@ audio maximum volume to %.2f", self.fileName,
          maxVolumeLimit);
    
    self.music.volume = maxVolumeLimit;
    
    _maxVolume = maxVolumeLimit;
    
}

# pragma  mark - Playback control.

- (void)togglePlayPause
{
    // Toggles audio play/pause.
    if (self.isPlaying) {
        [self pause];
    } else {
        [self play];
    }
}

- (void)play
{
    // Starts audio playback (if not already playing).
    if (!self.isPlaying) {
        NSLog(@"Play audio %@.", self.fileName);
        self.isPlaying = YES;
        [self.music play];
    }
}

- (void)pause
{
    // Pauses audio playback (if not already paused).
    if (self.isPlaying) {
        NSLog(@"Pause audio %@.", self.fileName);
        self.isPlaying = NO;
        [self.music pause];
    }
}


- (void)setVolumeToValue:(CGFloat)volumeValue;
{
    // Receives values from 1.0 to 0.0.
    // Limit at maxVolume and set new volume.
    
    CGFloat volumeToSet = volumeValue - self.volumeDifferenceToMax;
    
    if (volumeToSet < 0) {
        volumeToSet = 0.0f;
    }
    
    NSLog(@"Setting volume to %.2f.", volumeToSet);
    
    self.music.volume = volumeToSet;
}

- (void)setRateToValue:(CGFloat)rateValue
{
    // Rate varies between 50% and 200%.
    //float realRate = ;
    
    NSLog(@"Setting playback rate to %.2f.", rateValue);
    self.music.rate = rateValue;
}

@end
