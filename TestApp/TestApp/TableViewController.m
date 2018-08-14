//
//  TableViewController.m
//  TestApp
//
//  Created by shitingquan on 2017/4/18.
//  Copyright © 2017年 CSDQ. All rights reserved.
//

#import "TableViewController.h"
#import "ViewController.h"
#import "Department.h"

@interface ResponseObj : CSBaseModel
@property (nonatomic , strong) NSString *code;
@property (nonatomic , strong) Department *department;
@end

@implementation ResponseObj
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self registerClass:[Department class] forProperty:@"department"];
    }
    return self;
}
@end


@interface TableViewController ()
{
    NSArray *_dataArray;
}
@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSDictionary *response = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfURL:[mainBundle URLForResource:@"example" withExtension:@"json"]] options:NSJSONReadingAllowFragments error:nil];
    ResponseObj *obj = [ResponseObj modelFromDict:response];
    _dataArray = obj.department.subs;
    self.title = obj.department.name;
    self.tableView.tableFooterView = [UIView new];
    
    //Add Array to JSON
    NSLog(@"%@ %@",[_dataArray cs_JSON],[obj JSONString]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"segue" sender:_dataArray[indexPath.row]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    Department *deprtmt = _dataArray[indexPath.row];
    cell.textLabel.text = deprtmt.name;
    cell.detailTextLabel.text = deprtmt.attri.address;

    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    ((ViewController *)segue.destinationViewController).department = sender;
}


@end
