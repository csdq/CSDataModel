# CSDataModel 

NSDictionary、NSArray类型数据转为模型类数据

## 基本使用

例如一个JSON对象Department
``
{
 "name": "DepartmentA",
 "tel": "88888888",
 "num": 1
}

``
   
    该JSON String转化成NSDictionary： dict1

### 模型：

``
interface Department : CSBaseModel
@property (nonatomic , strong) NSString *name;
@property (nonatomic , strong) NSString *tel;
@property (nonatomic , strong) NSNumber *num;
@end

``
### 转化时：

``

Department *deprtmt = [Department modelFromDict:dict1];

``

## 嵌套使用

对于常见的情况：

``
{
 "name": "departmentA",
 "number": 3,
 "members": [{
   "name": "王五",
   "jobNum": "0023"
	},
	{
   "name": "陈六",
   "jobNum": "0028"
   }]
}

``

    该JSON String转化成NSDictionary： dict2

Department中含有成员Member
``
@interface Department : CSBaseModel
@property (nonatomic , strong) NSString *name;
@property (nonatomic , strong) NSArray<Member*> *members;
@end

@interface Member : CSBaseModel
@property (nonatomic , strong) NSString *name;
@property (nonatomic , strong) Attribute *attr;
@end

``

    Deparmtent实现文件中需要注册子模型的类

``
@implementation Department
-(instancetype)init
{
   self = [super init];
   if (self) {
      [self registerClass:[Member class] forProperty:@"members"];
   }
   return self;
}
@end
``

### 转化时：

``

Department *deprtmt = [Department modelFromDict:dict2];

``
转化成功后，可通过deprtmt.members访问member数组
