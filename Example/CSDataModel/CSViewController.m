//
//  CSViewController.m
//  CSDataModel
//
//  Created by stqemail@163.com on 02/09/2018.
//  Copyright (c) 2018 stqemail@163.com. All rights reserved.
//

#import "CSViewController.h"
//#import "CSDataModel.h"
#import "Department.h"
#import "Employee.h"

@interface CSViewController ()
{
    NSArray *_dataArray;
}
@property (weak, nonatomic) IBOutlet UITextView *mainInfoTV;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation CSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _dataArray = [NSArray arrayWithObjects:self.department.subs,self.department.members,nil];
    self.mainInfoTV.text = self.department.desc;
    self.title = self.department.name;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
    
#pragma mark - Table view data source
    
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataArray.count;
}
    
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [(NSArray *)_dataArray[section] count];
}
    
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"segue" sender:_dataArray[indexPath.section][indexPath.row]];
}
    
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if(indexPath.section == 0){
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
        Department *deprtmt = _dataArray[indexPath.section][indexPath.row];
        cell.textLabel.text = deprtmt.name;
        cell.detailTextLabel.text = deprtmt.attri.address;
        
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell2" forIndexPath:indexPath];
        Employee *employee = _dataArray[indexPath.section][indexPath.row];
        cell.textLabel.text = employee.name;
        cell.detailTextLabel.text = [@"工号" stringByAppendingString: employee.jobNum];
    }
    return cell;
}

@end
