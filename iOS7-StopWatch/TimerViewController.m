//
//  TimerViewController.m
//  iOS7 StopWatch
//
//  Created by John Setting on 9/11/14.
//  Copyright (c) 2014 John Setting. All rights reserved.
//

#import "TimerViewController.h"
#import "Timer.h"

@interface TimerViewController () <TimerDelegate, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic) Timer *stopWatchTimer;
@property (nonatomic) Timer *lapTimer;
@property (nonatomic) UIButton *stopWatchButton;
@property (nonatomic) UIButton *resetLapButton;
@property (nonatomic) UILabel *stopWatchLabel;
@property (nonatomic) UILabel *lapTimerLabel;
@property (nonatomic) UIView *buttonsView;
@property (nonatomic) UITableView *lapList;
@property (nonatomic) NSMutableArray *lapListArray;
@end

@implementation TimerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (!(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) return nil;
    [self setTitle:@"Stopwatch"];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.buttonsView];
    [self.view addSubview:self.stopWatchLabel];
    [self.view addSubview:self.lapTimerLabel];
    [self.view addSubview:self.lapList];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.stopWatchTimer = [[Timer alloc] initWithStopWatch:YES];
    [self.stopWatchTimer setDelegate:self];
    
    self.lapTimer = [[Timer alloc] initWithStopWatch:NO];
    [self.lapTimer setDelegate:self];
}


- (void)timerButtonPressed:(UIButton *)sender {
    
    if([self.stopWatchTimer isRunning] == false) {
        [self.stopWatchTimer startPauseTimer];
        [self.lapTimer startPauseTimer];
        [sender setTitle:@"Stop" forState:UIControlStateNormal];
        [sender setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [sender.layer setBorderColor:[[UIColor redColor] CGColor]];
        [self.resetLapButton setTitle:@"Lap" forState:UIControlStateNormal];
        return;
    }
    
    [self.stopWatchTimer startPauseTimer];
    [self.lapTimer startPauseTimer];
    [sender setTitle:@"Start" forState:UIControlStateNormal];
    [sender setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [sender.layer setBorderColor:[[UIColor greenColor] CGColor]];
    [self.resetLapButton setTitle:@"Reset" forState:UIControlStateNormal];
    return;
    
}

- (void)stopWatchTimerDidChange:(NSString *)timer
{
    [self.stopWatchLabel setText:timer];
}

- (void)lapTimerDidChange:(NSString *)timer
{
    [self.lapTimerLabel setText:timer];
}

- (void)resetLapButtonPressed:(UIButton *)button
{
    if ([[[button titleLabel] text] isEqualToString:@"Reset"]) {
        [self.stopWatchTimer resetTimer];
        [self.lapTimer resetTimer];
        [self.lapListArray removeAllObjects];
        [self.lapList reloadData];
        [self.stopWatchLabel setText:@"00:00.00"];
        [self.lapTimerLabel setText:@"00:00.00"];
        [button setTitle:@"Lap" forState:UIControlStateNormal];
        return;
    }
    
    if (![self.stopWatchTimer isRunning]) return;
    
    if ([[[button titleLabel] text] isEqualToString:@"Lap"]) {
        [self.lapListArray insertObject:[self.lapTimer timer] atIndex:0];
        [self.lapList reloadData];
        [self.lapTimer resetTimer];
        [self.lapTimerLabel setText:@"00:00.00"];
        return;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.lapListArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"id";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    [[cell textLabel] setText:[self.lapListArray objectAtIndex:indexPath.row]];
    return cell;
}

- (UILabel *)lapTimerLabel {
    if (!_lapTimerLabel) {
        _lapTimerLabel = [[UILabel alloc] initWithFrame:CGRectMake(230, 80, 70, 15)];
        [_lapTimerLabel setFont:[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:16.0f]];
        [_lapTimerLabel setTextColor:[UIColor darkGrayColor]];
        [_lapTimerLabel setText:@"00:00.00"];
        [_lapTimerLabel setTextAlignment:NSTextAlignmentCenter];
    }
    return _lapTimerLabel;
}

- (UILabel *)stopWatchLabel {
    if (!_stopWatchLabel) {
        _stopWatchLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 95, 300, 80)];
        [_stopWatchLabel setFont:[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:72.0f]];
        [_stopWatchLabel setText:@"00:00.00"];
        [_stopWatchLabel setTextAlignment:NSTextAlignmentCenter];
    }
    return _stopWatchLabel;
}

- (UIButton *)stopWatchButton {
    if (!_stopWatchButton) {
        _stopWatchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_stopWatchButton setFrame:CGRectMake(70, 20, 60, 60)];
        [_stopWatchButton.layer setCornerRadius:30.0f];
        [_stopWatchButton.layer setBorderWidth:1.0f];
        [_stopWatchButton setBackgroundColor:[UIColor whiteColor]];
        [[_stopWatchButton titleLabel] setFont:[UIFont fontWithName:@"Arial" size:14.0f]];
        [_stopWatchButton setTitle:@"Start" forState:UIControlStateNormal];
        [_stopWatchButton.layer setBorderColor:[[UIColor greenColor] CGColor]];
        [_stopWatchButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        [_stopWatchButton addTarget:self action:@selector(timerButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _stopWatchButton;
}

- (UIButton *)resetLapButton {
    if (!_resetLapButton) {
        _resetLapButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_resetLapButton setFrame:CGRectMake(190, 20, 60, 60)];
        [_resetLapButton.layer setCornerRadius:30.0f];
        [_resetLapButton.layer setBorderWidth:1.0f];
        [_resetLapButton setBackgroundColor:[UIColor whiteColor]];
        [[_resetLapButton titleLabel] setFont:[UIFont fontWithName:@"Arial" size:14.0f]];
        [_resetLapButton setTitle:@"Lap" forState:UIControlStateNormal];
        [[_resetLapButton titleLabel] setTextAlignment:NSTextAlignmentCenter];
        [_resetLapButton.layer setBorderColor:[[UIColor grayColor] CGColor]];
        [_resetLapButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_resetLapButton addTarget:self action:@selector(resetLapButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _resetLapButton;
}

- (UIView *)buttonsView
{
    if (!_buttonsView) {
        _buttonsView = [[UIView alloc] initWithFrame:CGRectMake(-1, 185, 322, 100)];
        [_buttonsView setBackgroundColor:[UIColor colorWithRed:(235.0/255.0) green:(235.0/255.0) blue:(235.0/255.0) alpha:.25]];
        [_buttonsView.layer setBorderColor:[[UIColor colorWithRed:(235.0/255.0) green:(235.0/255.0) blue:(235.0/255.0) alpha:.50] CGColor]];
        [_buttonsView.layer setBorderWidth:1.0f];
        [_buttonsView addSubview:self.stopWatchButton];
        [_buttonsView addSubview:self.resetLapButton];
    }
    
    return _buttonsView;
}


- (UITableView *)lapList {
    if (!_lapList) {
        _lapList = [[UITableView alloc] initWithFrame:CGRectMake(0, 285, self.view.frame.size.width, self.view.frame.size.height - 285) style:UITableViewStylePlain];
        [_lapList setBackgroundColor:[UIColor colorWithRed:(235.0/255.0) green:(235.0/255.0) blue:(235.0/255.0) alpha:.25]];
        [_lapList setDelegate:self];
        [_lapList setDataSource:self];
    }
    return _lapList;
}

- (NSMutableArray *)lapListArray
{
    if (!_lapListArray) {
        _lapListArray = [NSMutableArray array];
    }
    return _lapListArray;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 self.countDownText = 3;
 
 self.countDownLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 200, 30, 30)];
 [self.countDownLabel setText:[NSString stringWithFormat:@"%i", self.countDownText]];
 [self.view addSubview:self.countDownLabel];
 
 self.increment_decrement_controller = [[UISegmentedControl alloc] initWithItems:@[@"-", @"+"]];
 [self.increment_decrement_controller setFrame:CGRectMake(200, 200, 100, 30)];
 [self.increment_decrement_controller addTarget:self action:@selector(segmentedControlAction:) forControlEvents:UIControlEventValueChanged];
 [self.view addSubview:self.increment_decrement_controller];
 */

/*
 - (void)segmentedControlAction:(UISegmentedControl *)control
 {
 if(control.selectedSegmentIndex == 0) {
 
 if (self.countDownText == 1) {
 [control setSelectedSegmentIndex:UISegmentedControlNoSegment];
 return;
 }
 
 self.countDownText--;
 [self.countDownLabel setText:[NSString stringWithFormat:@"%i", self.countDownText]];
 [control setSelectedSegmentIndex:UISegmentedControlNoSegment];
 return;
 }
 
 if(control.selectedSegmentIndex == 1) {
 if (self.countDownText == 59) {
 [control setSelectedSegmentIndex:UISegmentedControlNoSegment];
 return;
 }
 
 self.countDownText++;
 [self.countDownLabel setText:[NSString stringWithFormat:@"%i", self.countDownText]];
 [control setSelectedSegmentIndex:UISegmentedControlNoSegment];
 return;
 }
 }
 */

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
