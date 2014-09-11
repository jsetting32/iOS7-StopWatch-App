//
//  Timer.m
//  iOS7 StopWatch
//
//  Created by John Setting on 9/11/14.
//  Copyright (c) 2014 John Setting. All rights reserved.
//

#import "Timer.h"

@interface Timer()
{
    int min;
    BOOL running;
    BOOL stopWatchChecker;
    NSDate * start;
    NSDate * end;
    NSTimeInterval time;
    NSTimeInterval timer;
    NSTimeInterval secondsAlreadyRun;
}

@end

@implementation Timer
- (id) initWithStopWatch:(BOOL)stopWatch {
    if (!(self = [super init])) return nil;
    stopWatchChecker = stopWatch;
    running = false;
    start = nil;
    end = nil;
    return self;
}

- (void) startPauseTimer {
    
    if (running == false) {
        running = true;
        start = [NSDate date];
        time = [NSDate timeIntervalSinceReferenceDate];
        [self updateTime];
        return;
    }
    
    secondsAlreadyRun += [[NSDate date] timeIntervalSinceDate:start];
    start = [NSDate date];
    running = false;
    return;
}

- (void)updateTime {
    if(running == false) return;
    NSTimeInterval currentTime = [NSDate timeIntervalSinceReferenceDate];
    timer = secondsAlreadyRun + currentTime - time;
    if (stopWatchChecker)
        [self.delegate stopWatchTimerDidChange:[self timer]];
    else
        [self.delegate lapTimerDidChange:[self timer]];
    [self performSelector:@selector(updateTime) withObject:self afterDelay:0.01];
}

- (int) timeElapsedInSeconds {
    NSTimeInterval elapsed = timer;
    int hours = (int)(min / 60.0);
    elapsed -= hours * 60;
    min = (int)(elapsed / 60.0);
    elapsed -= min * 60;
    return (int)(elapsed);
}

- (int) timeElapsedInMilliseconds {
    NSTimeInterval elapsed = timer;
    int hours = (int)(min / 60.0);
    elapsed -= hours * 60;
    min = (int)(elapsed / 60.0);
    elapsed -= min * 60;
    int secs = (int) (elapsed);
    elapsed -= secs;
    return (elapsed * 1000.0) / 10;
}

- (int) timeElapsedInMinutes {
    NSTimeInterval elapsed = timer;
    int hours = (int)(min / 60.0);
    elapsed -= hours * 60;
    return (int)(elapsed / 60.0);
}

- (void)resetTimer
{
    start = [NSDate date];
    time = [NSDate timeIntervalSinceReferenceDate];
    secondsAlreadyRun = 0.0;
}

- (NSString *) timer {
    return [NSString stringWithFormat:@"%02u:%02u.%02u", [self timeElapsedInMinutes], [self timeElapsedInSeconds], [self timeElapsedInMilliseconds]];
}

- (BOOL)isRunning {
    return running;
}

@end
