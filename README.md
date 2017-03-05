# MVVMWithReactiveCocoa
iOS开发之ReactiveCocoa下的MVVM
最近工作比较忙，但还是出来更新博客了，今天给大家分享一些ReactiveCocoa以及MVVM的一些东西，干活还是比较足的。在之前发表过一篇博文，名字叫做[《iOS开发之浅谈MVVM的架构设计与团队协作》](http://www.cnblogs.com/ludashi/p/4211556.html)，大体上讲的就是使用Block回调的方式实现MVVM的。在写上篇文章时也知道有ReactiveCocoa这个函数响应式编程的框架，并且有许多人用它来更好的实现MVVM。所以在上篇博客发表后，有些同行给评论建议看一下ReactiveCocoa的东西，所以就系统的看了一下ReactiveCocoa的东西。不过有一点要说明的就是，不使用ReactiveCocoa是可以实现MVVM的，并非使用MVVM模式你就必须的使用ReactiveCocoa的东西，你可以使KVO,Block,Delegate,Notification等手段，而ReactiveCocoa更优雅的实现了这个过程。ReactiveCocoa就是一个响应式编程的框架，它会使MVVM每层之间交互起来更为方便，所以经常和MVVM联系在一起。

##一.函数响应式编程（Function Reactive Programming）

关于函数响应式编程的东西，我想引用国外这个ReactiveCocoa教学视频,视频链接[https://vimeo.com/65637501](https://vimeo.com/65637501)中的一张PPT来简单的说一下什么是函数响应式编程。那就直接上图，下图是上方视频链接的截图，很形象的解释了什么是函数响应式编程。简单的说下方c = a + b 定义好后，当a的值变化后，c的值就会自动变化。不过a的值变化时会产生一个信号，这个信号会通知c根据a变化的值来变化自己的值。b的值变化同样也影响c的值。下图很好的表达了这个思想。在此就不做赘述了。
![](http://images2015.cnblogs.com/blog/545446/201510/545446-20151029165449466-94607195.png)

##二. ReactiveCocoa简介

先简单的介绍一下什么是ReactiveCocoa框架，然后通过实例好好的去搞一搞这个框架，最后就是如何在项目中使用了。关于ReactiveCocoa的理解一些博客（见本篇博客中的链接分享）中把ReactiveCocoa比喻成管道，ReactiveCocoa中的Signal就是管道中的水流。使用ReactiveCocoa可以方便的在MVVM各层之间架起沟通的管道，便于每层之间的交互。现在在我们做的工程中已经在使用ReactiveCocoa框架了，用起来的感觉是非常爽的，好用！

可以说ReactiveCocoa中核心是信号量机制，Signal在ReactiveCocoa中发挥着强大的不可代替的作用，可谓是ReactiveCocoa的灵魂所。Signal是可以携带一些对象和参数的，你可以获取该对象并且可以对该信号量携带的值进行map, filter等常用操作，操作后的值会和该信号量进行绑定。先简单的这么一说，后边的部分回详细的介绍如何让信号量发挥强大的作用。

ReactiveCocoa中对Block的使用可谓是淋漓尽致，如果对Block使用不熟的朋友可以补一下Block的东西，然后在回头看一下ReactiveCocoa的东西。关于ReactiveCocoa更多的东西，请参考Github上的链接[https://github.com/ReactiveCocoa/ReactiveCocoa](https://github.com/ReactiveCocoa/ReactiveCocoa)。

##三. 在工程中引入ReactiveCocoa

####1.你可以使用Github上的加入方式如下所示，本人感觉比较麻烦，就没有使用，采用的第二种方法（CocoaPods）。
![](http://images2015.cnblogs.com/blog/545446/201510/545446-20151029173053075-602730902.png)

####2.上面的步骤难免有些麻烦，所以用CocoaPods更为便捷一些，Profile文件中的内容如下所示，我用的是2.5版本。3.0后就支持Swift了，设置完Profile文件后，pod install即可。
![](http://images2015.cnblogs.com/blog/545446/201510/545446-20151029173527310-1882275970.png)

你可以pod search ReactiveCocoa看一下版本，选择你需要的版本即可。
![](http://images2015.cnblogs.com/blog/545446/201510/545446-20151029174451482-429254438.png)

##四.使用ReactiveCocoa

下方会通过一些简单的实例来介绍一下信号量机制和一些常用的方法。

####1.引入相应的头文件

在工程中引入下方的头文件（建议在Pch文件中引入）就可以使用我们的ReactiveCocoa框架了
```Objective-C
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>
```
####2. Sequence和Map

Sequence:队列，是ReactiveCocoa中引入的一个类型，它类似于数组，我们可以暂且把Sequence看做绑定信号量的数组吧。在OC中的NSArray可以通过rac_sequence方法转换成ReactiveCocoa中的Sequence，然后就可以调用处理信号的一些方法了。

参考以下实例代码:

* (1)把NSArray通过rac_sequence方法生成RAC中的Sequence
* (2)获取该Sequence对象的信号量
* (3)调用Signal的Map方法，使每个元素的首字母大写
* (4)通过subscribNext方法对其进行遍历输出
```Objective-C
//uppercaseString use map
- (void)uppercaseString {
    
    RACSequence *sequence = [@[@"you", @"are", @"beautiful"] rac_sequence];

    RACSignal *signal =  sequence.signal;
    
    RACSignal *capitalizedSignal = [signal map:^id(NSString * value) {
                               return [value capitalizedString];
                            }];
    
    [signal subscribeNext:^(NSString * x) {
        NSLog(@"signal --- %@", x);
    }];
    
    [capitalizedSignal subscribeNext:^(NSString * x) {
        NSLog(@"capitalizedSignal --- %@", x);
    }];
}
```
下方截图是上个这个方法中的运行结果，从运行结果不难看出，通过Signal相应的方法处理完后，处理的结果会与新返回的信号量所绑定。原信号量中的值保持不变。每次信号量调用相应的方法处理完数据后，都会返回一个新的信号量，而这个信号量是独立于原信号量的。
![](http://images2015.cnblogs.com/blog/545446/201511/545446-20151103092831461-168348881.png)

由上面的介绍可知，上面方法中的一坨代码可以写成下方的一串。因为一个方法调用后会返回一个持有新结果的新的信号量，然后在这个信号量的基础上再次调用信号量其他的方法。Signal还有其他一些好用的方法，用法和map方法类似，在此就不一一赘述了，gitHub上有相应的实例文档。
```Objective-C
- (void)uppercaseString {

    [[[@[@"you", @"are", @"beautiful"] rac_sequence].signal
     map:^id(NSString * value) {
        return [value capitalizedString];
    }] subscribeNext:^(id x) {
        NSLog(@"capitalizedSignal --- %@", x);
    }];
}
```

####3.信号量开关(Switch)

上面把信号量比喻成水管，那么Switch就是水龙头呢。通过Switch我们可以控制那个信号量起作用，并且可以在信号量之间进行切换。也可以这么理解，把Switch看成另一段水管，Switch对接那个水管，就流那个水管的水，这样比喻应该更为贴切一些。下方是一个关于Switch的一个小实例。

* (1) 首先创建3个自定义信号量（3个水管），前两个水管是用来接通不同的水源的(google, baidu), 而最后一个信号量是用来对接不同水源水管的水管（signalOfSignal）。signalOfSignal接baidu水管上，他就流baidu水源的水，接google水管上就流google水源的水。
* (2) 把signalOfSignal信号量通过switchToLatest方法加工成开关信号量。
* (3) 紧接着是对通过开关数据进行处理。
* (4) 开关对接baidu信号量，然后baidu和google信号量同时往水管里灌入数据，那么起作用的是baidu信号量。
* (5) 开关对接google信号量，google和baidu信号量发送数据，则google信号量输出到signalOfSignal中

```Objective-C
//信号开关Switch
- (void)signalSwitch {
    //创建3个自定义信号
    RACSubject *google = [RACSubject subject];
    RACSubject *baidu = [RACSubject subject];
    RACSubject *signalOfSignal = [RACSubject subject];
    
    //获取开关信号
    RACSignal *switchSignal = [signalOfSignal switchToLatest];
    
    //对通过开关的信号量进行操作
    [[switchSignal  map:^id(NSString * value) {
        return [@"https//www." stringByAppendingFormat:@"%@", value];
    }] subscribeNext:^(NSString * x) {
        NSLog(@"%@", x);
    }];
    
    
    //通过开关打开baidu
    [signalOfSignal sendNext:baidu];
    [baidu sendNext:@"baidu.com"];
    [google sendNext:@"google.com"];
    
    //通过开关打开google
    [signalOfSignal sendNext:google];
    [baidu sendNext:@"baidu.com/"];
    [google sendNext:@"google.com/"];
}
```
上面代码输出结果如下：
![](http://images2015.cnblogs.com/blog/545446/201511/545446-20151103110252539-74996119.png)

4.信号量的合并

信号量的合并说白了就是把两个水管中的水合成一个水管中的水。但这个合并有个限制，当两个水管中都有水的时候才合并。如果一个水管中有水，另一个水管中没有水，那么有水的水管会等到无水的水管中来水了，在与这个水管中的水按规则进行合并。下面这个实例就是把两个信号量进行合并。

* (1) 首先创建两个自定义的信号量letters和numbers
* (2) 吧两个信号量通过combineLatest函数进行合并，combineLatest说明要合并信号量中最后发送的值
* (3) reduce块中是合并规则：把numbers中的值拼接到letters信号量中的值后边。
* (4) 经过上面的步骤就是创建所需的相关信号量，也就是相当于架好运输的管道。接着我们就可以通过sendNext方法来往信号量中发送值了，也就是往管道中进行灌水。
```Objective-C
//组合信号
- (void)combiningLatest{
    RACSubject *letters = [RACSubject subject];
    RACSubject *numbers = [RACSubject subject];
    
    [[RACSignal
     combineLatest:@[letters, numbers]
     reduce:^(NSString *letter, NSString *number){
         return [letter stringByAppendingString:number];
     }]
     subscribeNext:^(NSString * x) {
         NSLog(@"%@", x);
     }];
    
    //B1 C1 C2
    [letters sendNext:@"A"];
    [letters sendNext:@"B"];
    [numbers sendNext:@"1"];
    [letters sendNext:@"C"];
    [numbers sendNext:@"2"];
}
```
上面示例的运行输出结果如下：
![](http://images2015.cnblogs.com/blog/545446/201511/545446-20151105141027430-538709851.png)
下面是自己画的原理图，思路应该还算是清晰。
![](http://images2015.cnblogs.com/blog/545446/201511/545446-20151105142321024-1751623998.png)

####5.信号的合并（merge）

信号合并就理解起来就比较简单了，merge信号量规则比较简单，就是把多个信号量，放入数组中通过merge函数来合并数组中的所有信号量为一个。类比一下，合并后，无论哪个水管中有水都会在merge产生的水管中流出来的。下方是merge信号量的代码：

* (1) 创建三个自定义信号量, 用于merge
* (2) 合并上面创建的3个信号量
* (3) 往信号里灌入数据
```Objective-C
//合并信号
- (void)merge {
    RACSubject *letters = [RACSubject subject];
    RACSubject *numbers = [RACSubject subject];
    RACSubject *chinese = [RACSubject subject];
    
    [[RACSignal
     merge:@[letters, numbers, chinese]]
     subscribeNext:^(id x) {
        NSLog(@"merge:%@", x);
    }];
    
    [letters sendNext:@"AAA"];
    [numbers sendNext:@"666"];
    [chinese sendNext:@"你好！"];
}
```
上面代码运行结果如下：
![](http://images2015.cnblogs.com/blog/545446/201511/545446-20151105162601899-778954145.png)
上面示例的原理图如下：
![](http://images2015.cnblogs.com/blog/545446/201511/545446-20151105165000633-1417442850.png)


##五. 在MVVM中引入RactiveCocoa

学以致用，最后来个简单的实例，来感受一下如何在MVVM中使用RactiveCocoa。当然今天RAC的应用是非常简单的，但原理就是这样的。接下啦我们要使用RAC模拟一下登录功能，当然，网络请求也是模拟的，这不是重点。重点在于如何在MVVM各层之间使用RAC的信号量来更方便的在各个层之间进行响应式数据交互。下面这个实例的UI是非常简单的，并且实现起来也是灰常简单的，关键还是在于RAC的应用。

搭建Demo所需UI，用户界面非常简单，公有两个用户界面，一个是登录页面（两个输入框，一个登录按钮），一个是登录后跳转的页面（一个展示用户名和密码的Label）。下方是使用Storyboard实现的用户登录页面。实现完后，个两个页面各自关联一个ViewContorller类。
![](http://images2015.cnblogs.com/blog/545446/201511/545446-20151106130708821-2027001588.png)

下方是整个小Demo的工程目录，因为我们今天的重点是如何在MVVM中使用RAC, 所以重点在于RAC的应用，对于MVVM的分层就简化一些。下方有VC层，在VC层中有两个视图控制器，一个是登录使用的视图控制器（ViewContorller）另一个是登录成功后的视图控制器（LoginSuccessViewController）。而ViewModel中则是负责登录的ViewModel业务逻辑层，该层中负责数据验证，网络请求，数据存储等一些与UI无关的业务逻辑。
![](http://images2015.cnblogs.com/blog/545446/201511/545446-20151106130818492-1654876034.png)

 

因为ViewModel层是独立于UI层而存在的，所以可以在没有UI的情况下我们就可以去实现相应模块的ViewModel层。这正好减少了个个层次间的耦合性，同时也提高了可测试性，总体上改善了可维护性。好废话少说，接下来要实现登录的ViewModel层。

* (1) 登录ViewModel层对应的类的头文件中的内容如下所示（VCViewModel.h）, 其实下方一些常用的信号量可以抽象出来放到ViewModel的父类中，这为了简化Demo没有做父类的抽象。下方就是VCViewModel中interface定义的公有属性和公有方法（Public）。userName和password(NSString类型) 用来绑定用户输入的用户名和密码。下方三个自定义信号量successObject, failureObject, errorObject 用来发送网络请求的数据。successObject负责处理网络请求成功且符合正常业务逻辑的事件， failureObject负责网络请求成功不符合正常业务逻辑的处理，errorObject负责网络异常处理。
```Objective-C
//
//  VCViewModel.h
//  ReactiveCocoaDemo
//
//  Created by Mr.LuDashi on 15/10/19.
//  Copyright © 2015年 ZeluLi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VCViewModel : NSObject
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) RACSubject *successObject;
@property (nonatomic, strong) RACSubject *failureObject;
@property (nonatomic, strong) RACSubject *errorObject;

- (id) buttonIsValid;
- (void)login;
@end
```

上面可能说的有些抽象，结合项目中的实例来解释一下什么时候发送successObject信号量，如何发送failureObject信号量，何时使用errorObject信号量。

以某些理财App中购买理财产品的业务流程为例。在用户下单之前先去判断用户是否实名认证以及绑定银行卡，如果用户已经实名和绑定银行卡就走正常支付流程（用户就是想去下单购买），VM就往VC发送successObject信号，当前VC就会根据信号量的指示跳转到下单支付页面。  但是如果用户没有实名或者绑卡，那么VM就给VC发送failureObject信号，根据信号量中的参数来判断是走实名认证流程还是走绑定银行卡流程。 errorObject就比较简单了，网络异常，后台服务器抛出的异常等不需要iOS这边做业务逻辑处理的，就放在errorObject中负责错误信息的展示。

文字说完了，如果有些小伙伴还不太明白，那看下面这张原理图吧。把三种信号量我们可以类比成十字路口的红绿灯。successObject就是绿灯，可以走正常流程。failureObject是黄灯，先等一下，完成该做的就可以走绿灯了。而errorObject就是一红灯，报错异常，终止业务流程并提升错误信息。有图有真相，到这儿如果还不理解我就没招了。
![](http://images2015.cnblogs.com/blog/545446/201511/545446-20151106134217602-2124107075.png)
在Public方法中- (id) buttonIsValid; 负责返回登录按钮是否可用的信号量。- (void)login;发起网络请求，调用登录网络接口。

　　

* (2)代码的具体实现如下（VCViewModel.m中的代码），私有属性如下。userNameSignal用来存储用户名的信号量，passwordSignal是用来存储密码的信号量。reqestData则是用来存储返回数据的。
```Objective-C
@interface VCViewModel ()
@property (nonatomic, strong) RACSignal *userNameSignal;
@property (nonatomic, strong) RACSignal *passwordSignal;
@property (nonatomic, strong) NSArray *requestData;
@end
```

* (3)VCViewModel的初始化方法如下，负责初始化属性。
```Objective-C
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    _userNameSignal = RACObserve(self, userName);
    _passwordSignal = RACObserve(self, password);
    _successObject = [RACSubject subject];
    _failureObject = [RACSubject subject];
    _errorObject = [RACSubject subject];
}
```
* (4)发送登录按钮是否可用信号的方法如下，主要用到了信号量的合并。
```Objective-C
//合并两个输入框信号，并返回按钮bool类型的值
- (id) buttonIsValid {
    
    RACSignal *isValid = [RACSignal
                          combineLatest:@[_userNameSignal, _passwordSignal]
                          reduce:^id(NSString *userName, NSString *password){
                              return @(userName.length >= 3 && password.length >= 3);
                          }];
    
    return isValid;
}
```


* (5) 模拟网络请求的发送，并发出网络请求成功的信号，具体代码如下
```Objective-C
- (void)login{
    
    //网络请求进行登录
    _requestData = @[_userName, _password];
    
    //成功发送成功的信号
    [_successObject sendNext:_requestData];
    
    //业务逻辑失败和网络请求失败发送fail或者error信号并传参

}
```

## 六、测试
上面是VM的实现，如果要进行单元测试的话，就对相应的VM类进行初始化，调用相应的函数进行单元测试即可。接着就是看如何在相应的VC模块中使用VM。

#### 1 在VC中实例化相应的VM类，并绑定相应的参数和实现接收不同信号的方法，具体代码如下：
```Objective-C
//关联ViewModel
- (void)bindModel {
    _viewModel = [[VCViewModel alloc] init];
    
    
    RAC(self.viewModel, userName) = self.userNameTextField.rac_textSignal;
    RAC(self.viewModel, password) = self.passwordTextField.rac_textSignal;
    RAC(self.loginButton, enabled) = [_viewModel buttonIsValid];
    
    @weakify(self);
    
    //登录成功要处理的方法
    [self.viewModel.successObject subscribeNext:^(NSArray * x) {
        @strongify(self);
        LoginSuccessViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"LoginSuccessViewController"];
        vc.userName = x[0];
        vc.password = x[1];
        [self presentViewController:vc animated:YES completion:^{
            
        }];
    }];
    
    //fail
    [self.viewModel.failureObject subscribeNext:^(id x) {
        
    }];
    
    //error
    [self.viewModel.errorObject subscribeNext:^(id x) {
        
    }];

}
```


#### 2、点击登录按钮，调用VM中登录相应的网络请求方法即可
```Objective-C
- (void)onClick {
    //按钮点击事件
    [[self.loginButton rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         [_viewModel login];
     }];
}
```


到此为止，一个完整模拟登录模块的RAC下的MVVM就实现完毕。当然上面的Demo是非常简陋的，还有好多地方需要进化。不过麻雀虽小，道理你懂得。主要是通过上面的Demo来感受一下RAC中的信号量机制以及应用场景。

上面代码写完，我们就可以运行看一下运行效果了，下方是运行后的效果，
![](http://images2015.cnblogs.com/blog/545446/201511/545446-20151106141713821-1314494999.png)

#### ViewModel:

* Kicking off network or database requests

* Determining when information should be hidden or shown

* Date and number formatting

* Localization

 

#### ViewController：

* Layout

* Animations

* Device rotation 

* View and window transitions

* Presenting loaded UI


其他参考资料：

        [https://github.com/ReactiveCocoa/ReactiveViewModel](https://github.com/ReactiveCocoa/ReactiveViewModel)

        [http://www.teehanlax.com/blog/model-view-viewmodel-for-ios/](http://www.teehanlax.com/blog/model-view-viewmodel-for-ios/)

        [http://www.teehanlax.com/blog/getting-started-with-reactivecocoa/](http://www.teehanlax.com/blog/getting-started-with-reactivecocoa/)

        [http://nshipster.cn/reactivecocoa/](http://nshipster.cn/reactivecocoa/)

        [http://limboy.me/ios/2013/06/19/frp-reactivecocoa.html](http://limboy.me/ios/2013/06/19/frp-reactivecocoa.html)

        [https://vimeo.com/65637501](https://vimeo.com/65637501)

        [http://southpeak.github.io/blog/2014/08/08/mvvmzhi-nan-yi-:flickrsou-suo-shi-li/](http://southpeak.github.io/blog/2014/08/08/mvvmzhi-nan-yi-:flickrsou-suo-shi-li/)

        [http://southpeak.github.io/blog/2014/08/02/reactivecocoazhi-nan-%5B%3F%5D-:xin-hao/](http://southpeak.github.io/blog/2014/08/02/reactivecocoazhi-nan-%5B%3F%5D-:xin-hao/)

        [http://southpeak.github.io/blog/2014/08/02/reactivecocoazhi-nan-er-:twittersou-suo-shi-li/](http://southpeak.github.io/blog/2014/08/02/reactivecocoazhi-nan-er-:twittersou-suo-shi-li/)

