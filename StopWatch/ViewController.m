//
//  ViewController.m
//  StopWatch
//
//  Created by vison on 2017/5/3.
//  Copyright © 2017年 vison. All rights reserved.
//

#import "ViewController.h"
#import "Masonry.h"

/* the width and height of the screen**/
#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height



@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (assign, nonatomic) NSInteger mainTime;
@property (assign, nonatomic) NSInteger lapTime;
@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) UILabel *lapTimeLabel;
@property (strong, nonatomic) UILabel *mainTimeLabel;
@property (strong, nonatomic) UIView *buttonView;
@property (strong, nonatomic) UIButton *startAndStopButton;
@property (strong, nonatomic) UIButton *lapButton;
@property (strong, nonatomic) UIButton *resetButton;
@property (strong, nonatomic) UITableView *lapTimeTableView;
@property (strong, nonatomic) NSMutableArray <NSString *>*lapArray;
@property (strong, nonatomic) UILabel *countLabel;
@property (strong, nonatomic) UILabel *onceLapTimeLabel;

@end


@implementation ViewController


#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"秒表";
    //remove the influence for layout of the navigationBar
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:self.lapTimeLabel];
    [self.view addSubview:self.mainTimeLabel];
    [self.view addSubview:self.buttonView];
    [_buttonView addSubview:self.startAndStopButton];
    [_buttonView addSubview:self.lapButton];
    [_buttonView addSubview:self.resetButton];
    [self.view addSubview:self.lapTimeTableView];
    
    [self p_initMasonry];

}

- (void)p_initMasonry {
    
    [_lapTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(64);
        make.right.equalTo(self.view).with.offset(-10);
        make.size.mas_equalTo(CGSizeMake(100, 60));
    }];
    
    [_mainTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(84);
        make.left.equalTo(self.view).with.offset(10);
        make.right.equalTo(self.view).with.offset(-10);
        make.height.equalTo(@140);
    }];
    
    [_buttonView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_mainTimeLabel.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@110);
    }];

    [_startAndStopButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_buttonView).with.offset(20);
        make.right.equalTo(self.view).with.offset(-(SCREEN_WIDTH / 5));
        make.size.mas_equalTo(CGSizeMake(70, 70));
    }];

    [_lapButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_startAndStopButton);
        make.left.equalTo(self.view).with.offset(SCREEN_WIDTH / 5);
        make.size.mas_equalTo(CGSizeMake(70, 70));
    }];

    [_resetButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(_lapButton);
        make.size.equalTo(_lapButton);
    }];

    [_lapTimeTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_buttonView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
}



#pragma mark - Private Methods
- (void)addTime {
    _lapTime++;
    _mainTime++;
    NSString *startTime = [NSString stringWithFormat:@"%02ld:%02ld.%02ld",
        _lapTime / 100 / 60, _lapTime / 100 % 60, _lapTime % 100];
    self.lapTimeLabel.text = [startTime copy];
    startTime=[NSString stringWithFormat:@"%02ld:%02ld.%02ld",
        _mainTime / 100 / 60, _mainTime / 100 % 60, _mainTime % 100];
    self.mainTimeLabel.text = [startTime copy];
}


#pragma mark - Event Response
- (void)startAndStopAction {
    self.startAndStopButton.backgroundColor = [UIColor whiteColor];
    self.startAndStopButton.selected = !self.startAndStopButton.selected;
    if(self.startAndStopButton.selected == YES){
        self.resetButton.hidden = YES;
        self.lapButton.hidden = NO;
        self.lapButton.userInteractionEnabled = YES;
        [self.lapButton setTitleColor:[UIColor blackColor] forState:
            UIControlStateNormal];
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self
            selector:@selector(addTime) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:
            NSRunLoopCommonModes];
    }
    else {
        self.resetButton.hidden = NO;
        self.lapButton.hidden = YES;
        [_timer invalidate];
    }
}

- (void)lapButtonAction {
    self.lapButton.backgroundColor = [UIColor whiteColor];
    [self.lapArray addObject:self.lapTimeLabel.text];
    _lapTime = 0;
    self.lapTimeLabel.text = @"00:00.00";
    [self.lapTimeTableView reloadData];
}
     
- (void)resetButtonAction {
    self.resetButton.backgroundColor = [UIColor whiteColor];
    _mainTime = 0;
    _lapTime = 0;
    self.lapTimeLabel.text = @"00:00.00";
    self.mainTimeLabel.text = @"00:00.00";
    self.resetButton.hidden = YES;
    self.lapButton.hidden = NO;
    self.lapButton.userInteractionEnabled = NO;
    [self.lapButton setTitleColor:[UIColor colorWithRed:0.8 green:0.8 blue:0.8
        alpha:1.00] forState:UIControlStateNormal];
    [self.lapArray removeAllObjects];
    [self.lapTimeTableView reloadData];
}

- (void)changeColorWhenClick:(id)sender {
    [sender setBackgroundColor:[UIColor grayColor]];
}


#pragma mark - UITableViewDataSource && UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:
    (NSInteger)section {
    
    return self.lapArray.count;
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
    self.countLabel = [cell viewWithTag:101];
    self.onceLapTimeLabel = [cell viewWithTag:102];
    if(self.countLabel == nil){
        self.countLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 12, 60, 20)];
        self.countLabel.font = [UIFont systemFontOfSize:15];
        self.countLabel.textColor = [UIColor colorWithRed:0.49 green:0.49 blue:0.49
            alpha:1];
        self.countLabel.tag = 101;
        [cell addSubview:self.countLabel];
        self.onceLapTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake
            (SCREEN_WIDTH - 150, 10, 100, 20)];
        self.onceLapTimeLabel.font = [UIFont systemFontOfSize:20];
        self.onceLapTimeLabel.textColor = [UIColor colorWithRed:0.2 green:0.2
            blue:0.2 alpha:1.00];
        self.onceLapTimeLabel.tag = 102;
        [cell addSubview:self.onceLapTimeLabel];
    }
    self.countLabel.text = [[NSString stringWithFormat:@"计次 %ld",
        self.lapArray.count - indexPath.row] copy];
    self.onceLapTimeLabel.text = [[self.lapArray objectAtIndex:
        self.lapArray.count - indexPath.row - 1] copy];
    
    cell.backgroundColor =  [UIColor colorWithRed:0.95 green:0.95 blue:0.95
        alpha:1.00];
    return cell;
}

#pragma mark - Getter And Setter
- (NSMutableArray *)lapArray {
    if(_lapArray == nil) {
        _lapArray = [NSMutableArray array];
    }
    return _lapArray;
}


- (UILabel *)lapTimeLabel {
    if(_lapTimeLabel == nil) {
        _lapTimeLabel = [[UILabel alloc] init];
        _lapTimeLabel.font = [UIFont systemFontOfSize:20];
        _lapTimeLabel.textColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5
            alpha:1.00];
        _lapTimeLabel.text = @"00:00.00";
    }
    return _lapTimeLabel;
}

- (UILabel *)mainTimeLabel {
    if(_mainTimeLabel == nil) {
        _mainTimeLabel = [[UILabel alloc] init];
        _mainTimeLabel.font = [UIFont systemFontOfSize:70];
        _mainTimeLabel.text = @"00:00.00";
    }
    return _mainTimeLabel;
}

- (UIView *)buttonView {
    if(_buttonView == nil) {
        _buttonView = [[UIView alloc] init];
        _buttonView.backgroundColor = [UIColor colorWithRed:0.95 green:0.95
            blue:0.95 alpha:1.00];
    }
    return _buttonView;
}

- (UIButton *)startAndStopButton {
    if(_startAndStopButton == nil) {
        _startAndStopButton = [[UIButton alloc] init];
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
    }
    return _startAndStopButton;
}

- (UIButton *)lapButton {
    if(_lapButton == nil) {
        _lapButton = [[UIButton alloc] init];
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
    }
    return _lapButton;
}

- (UIButton *)resetButton {
    if(_resetButton == nil) {
        _resetButton = [[UIButton alloc] init];
        _resetButton.backgroundColor = [UIColor whiteColor];
        _resetButton.layer.cornerRadius = 35;
        [_resetButton setTitle:@"复位" forState:UIControlStateNormal];
        [_resetButton setTitleColor:[UIColor blackColor] forState:
         UIControlStateNormal];
        [_resetButton addTarget:self action:@selector(changeColorWhenClick:)
            forControlEvents:UIControlEventTouchDown];
        [_resetButton addTarget:self action:@selector(resetButtonAction)
            forControlEvents:UIControlEventTouchUpInside];
        _resetButton.hidden = YES;
    }
    return _resetButton;
}

- (UITableView *)lapTimeTableView {
    if(_lapTimeTableView == nil) {
        _lapTimeTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0,
            0, 0) style:UITableViewStylePlain];
        [_lapTimeTableView registerClass:[UITableViewCell class]
            forCellReuseIdentifier:@"tableViewCell"];
        _lapTimeTableView.backgroundColor = [UIColor colorWithRed:0.95
            green:0.95 blue:0.95 alpha:1.00];
        _lapTimeTableView.dataSource = self;
        _lapTimeTableView.delegate = self;
    }
    return _lapTimeTableView;
}


#pragma mark - CustomDelegate






@end
