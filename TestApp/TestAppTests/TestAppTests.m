//
//  TestAppTests.m
//  TestAppTests
//
//  Created by stq on 2017/1/18.
//  Copyright © 2017年 CSDQ. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <CSDataModel/CSDataModel.h>

/**********/
@interface Attribute : CSBaseModel
@property (nonatomic , strong) NSString *tel;
@property (nonatomic , strong) NSString *address;
@end
@implementation Attribute

@end
/**********/
@interface Member : CSBaseModel
@property (nonatomic , strong) NSString *name;
@property (nonatomic , strong) Attribute *attr;
@end
@implementation Member
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self.subModelDict setObject:@"Attribute" forKey:@"attr"];
    }
    return self;
}

@end
/**********/
@interface Department : CSBaseModel
@property (nonatomic , strong) NSString *name;
@property (nonatomic , strong) NSNumber* number;
@property (nonatomic , strong) NSArray<Department*> *sub;
@property (nonatomic , strong) Attribute *attr;
@property (nonatomic , strong) NSArray<Member*> *members;
@end

@implementation Department
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self.subModelDict setObject:@"Department" forKey:@"sub"];
        [self.subModelDict setObject:@"Member" forKey:@"members"];
        [self.subModelDict setObject:@"Attribute" forKey:@"attr"];
    }
    return self;
}
@end

@interface TestAppTests : XCTestCase

@end

@implementation TestAppTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)testDataModelConvertion{
    NSDictionary *departmentInfo = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"example" withExtension:@"json"]] options:NSJSONReadingAllowFragments error:nil];
    NSLog(@"\ndepartmentInfo Dict:\n%@",departmentInfo);
    Department *department = [Department modelFromDict:departmentInfo];
    NSLog(@"\ndepartmentInfo Model:\n%@",department);
    NSLog(@"\nModel to Dict : \n%@",[department modelToDict]);
    
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
