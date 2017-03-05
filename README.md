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
```

```Objective-C
```
```Objective-C
```


##信号量合并
![](http://images2015.cnblogs.com/blog/545446/201511/545446-20151105142321024-1751623998.png)
![](http://images2015.cnblogs.com/blog/545446/201511/545446-20151105165000633-1417442850.png)
##工作原理图
![](http://images2015.cnblogs.com/blog/545446/201511/545446-20151106134217602-2124107075.png)
##运行结果
![](http://images2015.cnblogs.com/blog/545446/201511/545446-20151106141713821-1314494999.png)
