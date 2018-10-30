#
# Be sure to run `pod lib lint CSDataModel.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'CSDataModel'
  s.version          = '1.1.2'
  s.summary          = '一个简单的数据模型基类，方便将NSDictionary、NSArray等类型数据转为模型对象'

  s.description      = <<-DESC
                        # CSDataModel

                        一个简单的数据模型基类，方便将NSDictionary、NSArray等类型数据转为模型对象

                        ## 基本使用

                        例如一个JSON对象Department

                        {
                        "name": "DepartmentA",
                        "tel": "88888888",
                        "num": 1
                        }

                        该JSON String转化成NSDictionary： dict1

                        ### 模型：

                        @interface Department : CSBaseModel
                        @property (nonatomic , strong) NSString *name;
                        @property (nonatomic , strong) NSString *tel;
                        @property (nonatomic , strong) NSNumber *num;
                        @end

                        ### 转化时：

                        Department *deprtmt = [Department modelFromDict:dict1];

                        ## 嵌套使用

                        ### 模型
                        对于常见的情况：

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

                        该JSON String转化成NSDictionary： dict2

                        Department中含有成员Member

                        @interface Department : CSBaseModel
                        @property (nonatomic , strong) NSString *name;
                        @property (nonatomic , strong) NSArray<Member*> *members;
                        @end

                        @interface Member : CSBaseModel
                        @property (nonatomic , strong) NSString *name;
                        @property (nonatomic , strong) NSNumber *jobNum;
                        @end

                        Deparmtent实现文件中需要注册子模型的类

                        @implementation Department
                        -(instancetype)init{
                        self = [super init];
                        if (self) {
                        [self registerClass:[Member class]   forProperty:@"members"];
                        }
                        return self;
                        }
                        @end

                        ### 转化时：

                        Department *deprtmt = [Department modelFromDict:dict2];

                        转化成功后，可通过deprtmt.members访问member数组

                       DESC

  s.homepage         = 'https://github.com/csdq/CSDataModel'
  s.license          = { :type => 'GPL-3.0', :file => 'LICENSE' }
  s.author           = { 'Mr.s' => 'stqemail@163.com' }
  s.source           = { :git => 'https://github.com/csdq/CSDataModel.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'CSDataModel/Classes/**/*'
end
