//
//  KeySound.m
//  MechKeyboard
//
//  Created by Julius Cebreros on 7/4/15.
//  Copyright (c) 2015 Julius Cebreros. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AVFoundation/AVAudioPlayer.h"
#import "KeySound.h"

@interface KeySound()

@property int index;
@property NSMutableArray *buffers;

@end

@implementation KeySound
- (id)init:(NSString *)fileName{
    self.index = 0;
    self.buffers = [[NSMutableArray alloc] initWithCapacity:10];
    
    for(int i = 0; i < 10; i++){
        NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                             pathForResource:fileName
                                             ofType:@"mp3"]];
        AVAudioPlayer *audioPlayer = [[AVAudioPlayer alloc]
                                      initWithContentsOfURL:url
                                      error:nil];
        [self.buffers addObject:audioPlayer];
    }

    return self;
}

- (void)play:(float) volume{
    AVAudioPlayer *player = [self.buffers objectAtIndex:self.index];
    [player setVolume:volume];
    [player play];

    self.index++;
    self.index = self.index % 10;
}

@end