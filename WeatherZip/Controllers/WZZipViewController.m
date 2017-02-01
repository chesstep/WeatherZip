//
//  ViewController.m
//  WeatherZip
//
//  Created by Chesley Stephens on 1/30/17.
//  Copyright © 2017 Nibbis. All rights reserved.
//

#import "WZZipViewController.h"

#import "WZZipCodeCell.h"
#import "WZWeatherViewController.h"

@interface WZZipViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addButton;

@property (nonatomic, strong) NSMutableArray *zipCodes;
@property (nonatomic, strong) NSString *selectedZipCode;

@end

@implementation WZZipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"WeatherZip", @"");
    self.addButton.target = self;
    self.addButton.action = @selector(addButtonPressed:);
    
    self.zipCodes = [[NSMutableArray alloc] initWithObjects:@"78731", @"94107", @"10118", nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Add Button Methods

- (void)addButtonPressed:(id)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Zip Code Entry", @"") message:NSLocalizedString(@"Please enter a zip code", @"") preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = NSLocalizedString(@"Zip code", @"");
        textField.keyboardType = UIKeyboardTypeNumberPad;
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", @"") style:UIAlertActionStyleCancel handler:nil];

    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UITextField *zipCodeField = alertController.textFields.firstObject;
        if (zipCodeField.text == nil || zipCodeField.text.length == 0) {
            return;
        }
        
        self.selectedZipCode = zipCodeField.text;
        [self performSegueWithIdentifier:NSStringFromClass([WZWeatherViewController class]) sender:self];
        
        [self.tableView beginUpdates];
        [self.zipCodes addObject:zipCodeField.text];
        NSIndexPath *insertIndex = [NSIndexPath indexPathForRow:self.zipCodes.count - 1 inSection:0];
        [self.tableView insertRowsAtIndexPaths:@[insertIndex] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - UITableViewDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.zipCodes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WZZipCodeCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([WZZipCodeCell class])];
    cell.zipCodeLabel.text = self.zipCodes[indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    self.selectedZipCode = self.zipCodes[indexPath.row];
    [self performSegueWithIdentifier:NSStringFromClass([WZWeatherViewController class]) sender:self];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.tableView beginUpdates];
        [self.zipCodes removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1f;
}

#pragma mark - PrepareForSegue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:NSStringFromClass([WZWeatherViewController class])]) {
        WZWeatherViewController *weatherVC = [segue destinationViewController];
        weatherVC.zipCode = self.selectedZipCode;
    }
}

@end
