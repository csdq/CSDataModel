# CSDataModel

一个简单的数据模型积累，方便将NSDictionary、NSArray类型数据转为模型对象

## 基本使用

例如一个JSON对象Department

<code>{  
 "name": "DepartmentA",    
 "tel": "88888888",  
 "num": 1  
}</code>

	该JSON String转化成NSDictionary： dict1

### 模型：

<code>@interface Department : CSBaseModel  
@property (nonatomic , strong) NSString *name;  
@property (nonatomic , strong) NSString *tel;  
@property (nonatomic , strong) NSNumber *num;  
@end
</code>
### 转化时：

<code>Department *deprtmt = [Department modelFromDict:dict1];</code>

## 嵌套使用

### 模型
对于常见的情况：

<code>{  
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
}</code>

    该JSON String转化成NSDictionary： dict2

Department中含有成员Member

<code>@interface Department : CSBaseModel  
@property (nonatomic , strong) NSString *name;  
@property (nonatomic , strong) NSArray<Member*> *members;  
@end  
@interface Member : CSBaseModel  
@property (nonatomic , strong) NSString *name;  
@property (nonatomic , strong) NSNumber *jobNum;  
@end</code>

    Deparmtent实现文件中需要注册子模型的类

<code>@implementation Department  
-(instancetype)init  
{  
   self = [super init];  
   if (self) {
      [self registerClass:[Member class]   forProperty:@"members"];  
   }  
   return self;  
}    
@end</code>

### 转化时：

`Department *deprtmt = [Department modelFromDict:dict2];
`

转化成功后，可通过deprtmt.members访问member数组
