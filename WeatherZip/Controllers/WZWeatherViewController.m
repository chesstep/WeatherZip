//
//  WeatherViewController.m
//  WeatherZip
//
//  Created by Chesley Stephens on 1/30/17.
//  Copyright © 2017 Nibbis. All rights reserved.
//

#import "WZWeatherViewController.h"

#import "WZWeatherService.h"
#import "WZSummaryCell.h"

@interface WZWeatherViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *loadingView;

@property (nonatomic, strong) WZWeatherService *weatherService;
@property (nonatomic, strong) WZWeather *weather;

@property (nonatomic, strong) NSArray *rowMap;

@end

@implementation WZWeatherViewController

typedef NS_ENUM(NSInteger, RowMapItem){
    RowMapItemSummaryRow,
    RowMapItemPrecipRow,
    RowMapItemHumidityRow,
    RowMapItemWindSpeedRow
};

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Current Weather", @"");
    [self.view bringSubviewToFront:self.loadingView];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 88;
    
    self.weatherService = [[WZWeatherService alloc] init];
    [self fetchWeatherInformation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)fetchWeatherInformation {
    __weak WZWeatherViewController *weakSelf = self;
    [self.weatherService forcastForZipCode:self.zipCode completion:^(WZWeather *weather, NSError *error) {
        if (error == nil) {
            weakSelf.weather = weather;
            [weakSelf configureRowMap];
            [weakSelf.tableView reloadData];
            weakSelf.loadingView.hidden = YES;
        } else {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Error Processing Request", @"") message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }];
            
            [alertController addAction:okAction];
            [weakSelf presentViewController:alertController animated:YES completion:nil];
        }
    }];
}

- (void)configureRowMap {
    NSMutableArray *rowMapItems = [[NSMutableArray alloc] init];
    [rowMapItems addObject:[NSNumber numberWithInteger:RowMapItemSummaryRow]];
    
    if (self.weather.currently.precipType != nil) {
        [rowMapItems addObject:[NSNumber numberWithInteger:RowMapItemPrecipRow]];
    }
    
    [rowMapItems addObject:[NSNumber numberWithInteger:RowMapItemHumidityRow]];
    [rowMapItems addObject:[NSNumber numberWithInteger:RowMapItemWindSpeedRow]];
    
    self.rowMap = rowMapItems;
}

#pragma mark - UITableViewDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.rowMap.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    NSInteger rowItem = [[self.rowMap objectAtIndex:indexPath.row] integerValue];
    
    switch (rowItem) {
        case RowMapItemSummaryRow: {
            WZSummaryCell *summaryCell = [self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass([WZSummaryCell class])];
            summaryCell.zipCodeLabel.text = self.zipCode;
            summaryCell.tempLabel.text = self.weather.currently.temperatureString;
            summaryCell.summaryLabel.text = self.weather.currently.summary;
            
            cell = summaryCell;
        }
            break;
        case RowMapItemPrecipRow: {
            UITableViewCell *precipCell = [self.tableView dequeueReusableCellWithIdentifier:@"WZBasicCell"];
            precipCell.textLabel.text = [NSString stringWithFormat:@"%@ %@ %@", self.weather.currently.precipProbabilityString, NSLocalizedString(@"chance of", @""), self.weather.currently.precipType];
            cell = precipCell;
        }
            break;
        case RowMapItemHumidityRow: {
            UITableViewCell *humidityCell = [self.tableView dequeueReusableCellWithIdentifier:@"WZRightDetailCell"];
            humidityCell.textLabel.text = NSLocalizedString(@"Humidity", @"");
            humidityCell.detailTextLabel.text = self.weather.currently.humidityString;
            cell = humidityCell;
        }
            break;
        case RowMapItemWindSpeedRow: {
            UITableViewCell *windSpeedCell = [self.tableView dequeueReusableCellWithIdentifier:@"WZRightDetailCell"];
            windSpeedCell.textLabel.text = NSLocalizedString(@"Wind Speed", @"");
            windSpeedCell.detailTextLabel.text = self.weather.currently.windSpeedString;
            cell = windSpeedCell;
        }
            break;
        default:
            break;
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1f;
}

@end
