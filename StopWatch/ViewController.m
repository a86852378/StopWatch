//
//  ViewController.m
//  StopWatch
//
//  Created by vison on 2017/5/3.
//  Copyright © 2017年 vison. All rights reserved.
//

#import "ViewController.h"

/* the width and height of the screen**/
#define ScreenWidth  [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height



@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>{
    
    NSInteger _mainTime;
    NSInteger _lapTime;
    NSTimer *_timer;
    UILabel *_lapTimeLabel;
    UILabel *_mainTimeLabel;
    UIView *_buttonView;
    UIButton *_startAndStopButton;
    UIButton *_lapButton;
    UIButton *_resetButton;
    UITableView *_lapTimeTableView;
    NSMutableArray *_lapArray;
    
    UILabel *_countLabel;
    UILabel *_onceLapTimeLabel;
}

@end

@implementation ViewController

#pragma mark - viewDidload
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"秒表";
    
    _lapArray = [NSMutableArray array];

    //remove the influence for layout of the navigationBar
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _lapTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth - 115,
        64, 100, 60)];
    _lapTimeLabel.font = [UIFont systemFontOfSize:20];
    _lapTimeLabel.textColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5
        alpha:1.00];
    _lapTimeLabel.text = @"00:00.00";
    [self.view addSubview:_lapTimeLabel];
    
    
    _mainTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 84,
        ScreenWidth -15, 140)];
    _mainTimeLabel.font = [UIFont systemFontOfSize:70];
    _mainTimeLabel.text = @"00:00.00";
    [self.view addSubview:_mainTimeLabel];
    
    
    
    _buttonView = [[UIView alloc] initWithFrame:CGRectMake(0, 204, ScreenWidth,
        110)];
    _buttonView.backgroundColor = [UIColor colorWithRed:0.95 green:0.95
        blue:0.95 alpha:1.00];
    [self.view addSubview:_buttonView];
    
    _startAndStopButton = [[UIButton alloc] initWithFrame:CGRectMake
        (((ScreenWidth / 5) *4) - 70, 20, 70, 70)];
    _startAndStopButton.backgroundColor = [UIColor whiteColor];
    _startAndStopButton.layer.cornerRadius = 35;
    [_startAndStopButton setTitle:@"启动" forState:UIControlStateNormal];
    [_startAndStopButton setTitle:@"停止" forState:UIControlStateSelected];
    [_startAndStopButton setTitleColor:[UIColor greenColor] forState:
        UIControlStateNormal];
    [_startAndStopButton setTitleColor:[UIColor redColor] forState:
        UIControlStateSelected];
    [_startAndStopButton addTarget:self action:@selector(changeColorWhenClick:)
        forControlEvents:UIControlEventTouchDown];
    [_startAndStopButton addTarget:self action:@selector(startAndStopAction)
        forControlEvents:UIControlEventTouchUpInside];
    [_buttonView addSubview:_startAndStopButton];
    
    _lapButton = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth / 5, 20,
        70, 70)];
    _lapButton.backgroundColor = [UIColor whiteColor];
    _lapButton.layer.cornerRadius = 35;
    [_lapButton setTitle:@"计次" forState:UIControlStateNormal];
    [_lapButton setTitleColor:[UIColor colorWithRed:0.8 green:0.8 blue:0.8
        alpha:1.00] forState:UIControlStateNormal];
    [_lapButton addTarget:self action:@selector(changeColorWhenClick:)
        forControlEvents:UIControlEventTouchDown];
    [_lapButton addTarget:self action:@selector(lapButtonAction)
        forControlEvents:UIControlEventTouchUpInside];
    _lapButton.userInteractionEnabled = NO;
    [_buttonView addSubview:_lapButton];
    
    
    _resetButton = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth / 5,
        20, 70, 70)];
    _resetButton.backgroundColor = [UIColor whiteColor];
    _resetButton.layer.cornerRadius = 35;
    [_resetButton setTitle:@"复位" forState:UIControlStateNormal];
    [_resetButton setTitleColor:[UIColor blackColor] forState:
        UIControlStateNormal];
    [_resetButton addTarget:self action:@selector(changeColorWhenClick:)
        forControlEvents:UIControlEventTouchDown];
    [_resetButton addTarget:self action:@selector(resetButtonAction)
        forControlEvents:UIControlEventTouchUpInside];
    
    
    _lapTimeTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 314,
        ScreenWidth, ScreenHeight - 314) style:UITableViewStylePlain];
    [_lapTimeTableView registerClass:[UITableViewCell class]
        forCellReuseIdentifier:@"tableViewCell"];
    _lapTimeTableView.backgroundColor = [UIColor colorWithRed:0.95 green:0.95
        blue:0.95 alpha:1.00];
    _lapTimeTableView.dataSource = self;
    _lapTimeTableView.delegate = self;
    [self.view addSubview:_lapTimeTableView];
    
}


#pragma mark - circulation event
- (void)addTime {
    _lapTime++;
    _mainTime++;
    NSString *startTime = [NSString stringWithFormat:@"%02ld:%02ld.%02ld",
        _lapTime / 100 / 60, _lapTime / 100 % 60, _lapTime % 100];
    _lapTimeLabel.text = [startTime copy];
    startTime=[NSString stringWithFormat:@"%02ld:%02ld.%02ld",
        _mainTime / 100 / 60, _mainTime / 100 % 60, _mainTime % 100];
    _mainTimeLabel.text = [startTime copy];
}

#pragma mark - button action
- (void)startAndStopAction {
    _startAndStopButton.backgroundColor = [UIColor whiteColor];
    _startAndStopButton.selected = !_startAndStopButton.selected;
    if(_startAndStopButton.selected == YES){
        [_resetButton removeFromSuperview];
        [_buttonView addSubview:_lapButton];
        _lapButton.userInteractionEnabled = YES;
        [_lapButton setTitleColor:[UIColor blackColor] forState:
            UIControlStateNormal];
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self
            selector:@selector(addTime) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:
             NSRunLoopCommonModes];
    }
    else {
        [_lapButton removeFromSuperview];
        [_buttonView addSubview:_resetButton];
        [_timer invalidate];
    }
}

- (void)lapButtonAction {
    _lapButton.backgroundColor = [UIColor whiteColor];
    [_lapArray addObject:_lapTimeLabel.text];
    _lapTime = 0;
    _lapTimeLabel.text = @"00:00.00";
    [_lapTimeTableView reloadData];
}
     
- (void)resetButtonAction {
    _resetButton.backgroundColor = [UIColor whiteColor];
    _mainTime = 0;
    _lapTimeLabel.text = @"00:00.00";
    _mainTimeLabel.text = @"00:00.00";
    [_resetButton removeFromSuperview];
    [_buttonView addSubview:_lapButton];
    _lapButton.userInteractionEnabled = NO;
    [_lapButton setTitleColor:[UIColor colorWithRed:0.8 green:0.8 blue:0.8
        alpha:1.00] forState:UIControlStateNormal];
    [_lapArray removeAllObjects];
    [_lapTimeTableView reloadData];
}

- (void)changeColorWhenClick:(id)sender {
    [sender setBackgroundColor:[UIColor grayColor]];
}

#pragma tableView delegate && dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:
    (NSInteger)section {
    
    return _lapArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:
    (NSIndexPath *)indexPath {
    
    //消除因cell重用而内容重叠的影响 方法一
//    NSString *cellIdentifier = @"tableViewCell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
//        cellIdentifier];
//    if(cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:
//            UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
//        
//        _countLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 12,
//            60, 20)];
//        _countLabel.font = [UIFont systemFontOfSize:15];
//        _countLabel.textColor = [UIColor colorWithRed:0.49 green:0.49 blue:0.49
//            alpha:1];
//        _countLabel.tag = 101;
//        [cell addSubview:_countLabel];
//        
//        _onceLapTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake
//            (ScreenWidth - 150, 10, 100, 20)];
//        _onceLapTimeLabel.font = [UIFont systemFontOfSize:20];
//        _onceLapTimeLabel.textColor = [UIColor colorWithRed:0.2 green:0.2
//            blue:0.2 alpha:1.00];
//        _onceLapTimeLabel.tag = 102;
//        [cell addSubview:_onceLapTimeLabel];
//    }
//    
//    _countLabel = [cell viewWithTag:101];
//    _countLabel.text = [[NSString stringWithFormat:@"计次 %ld",
//        _lapArray.count - indexPath.row] copy];
//    
//    _onceLapTimeLabel = [cell viewWithTag:102];
//    _onceLapTimeLabel.text = [[_lapArray objectAtIndex:
//        _lapArray.count - indexPath.row - 1] copy];
    
    //消除因cell重用而内容重叠的影响 方法二
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
        @"tableViewCell"];
    _countLabel = [cell viewWithTag:101];
    _onceLapTimeLabel = [cell viewWithTag:102];
    if(_countLabel == nil){
        _countLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 12, 60, 20)]
            ;
        _countLabel.font = [UIFont systemFontOfSize:15];
        _countLabel.textColor = [UIColor colorWithRed:0.49 green:0.49 blue:0.49
            alpha:1];
        _countLabel.tag = 101;
        [cell addSubview:_countLabel];
        _onceLapTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake
            (ScreenWidth - 150, 10, 100, 20)];
        _onceLapTimeLabel.font = [UIFont systemFontOfSize:20];
        _onceLapTimeLabel.textColor = [UIColor colorWithRed:0.2 green:0.2
            blue:0.2 alpha:1.00];
        _onceLapTimeLabel.tag = 102;
        [cell addSubview:_onceLapTimeLabel];
    }
    _countLabel.text = [[NSString stringWithFormat:@"计次 %ld",
        _lapArray.count - indexPath.row] copy];
    _onceLapTimeLabel.text = [[_lapArray objectAtIndex:
        _lapArray.count - indexPath.row - 1] copy];
    
    cell.backgroundColor =  [UIColor colorWithRed:0.95 green:0.95 blue:0.95
                                            alpha:1.00];
    return cell;
}




@end
