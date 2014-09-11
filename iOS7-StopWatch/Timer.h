//
//  Timer.h
//  iOS7 StopWatch
//
//  Created by John Setting on 9/11/14.
//  Copyright (c) 2014 John Setting. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TimerDelegate <NSObject>
- (void)stopWatchTimerDidChange:(NSString *)timer;
- (void)lapTimerDidChange:(NSString *)timer;
@end

@interface Timer : NSObject
@property (nonatomic) id<TimerDelegate>delegate;
- (id) initWithStopWatch:(BOOL)stopWatch;
- (void)startPauseTimer;
- (int) timeElapsedInSeconds;
- (int) timeElapsedInMilliseconds;
- (int) timeElapsedInMinutes;
- (NSString *) timer;
- (void)resetTimer;
- (BOOL)isRunning;
- (BOOL)hasStarted;
@end
