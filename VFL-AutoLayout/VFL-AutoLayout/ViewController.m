//
//  ViewController.m
//  VFL-AutoLayout
//
//  Created by CaoMeng on 2017/3/20.
//  Copyright © 2017年 CM. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    /*
     
     1.NSLayoutConstraint API
     
     + (NSArray *)constraintsWithVisualFormat:(NSString *)format options:(NSLayoutFormatOptions)opts
     metrics:(NSDictionary *)metrics
     views:(NSDictionary *)views;
     参数介绍:
     
     format:此参数为你的vfl语句，比如:@"H:|-[button]-|"
     
     opts:枚举参数，默认写0，具体跟据你所实现的需求去选择你想要的枚举
     
     metrics:这里是一个字典，当在format中使用了动态数据比如上现这句:@"H:|-[button(==width)]-|",表示这个button的宽度为width,那么这个参数去哪里找呢？就是在这个字典里面找到key对就的值，如果没有找到这个值，app就会crash.
     
     views:顾名思义，这是传所有你在vfl中使用到的view，那在上面这句例子中的应该怎么传呢？结果是这样的：NSDictionaryOfVariableBindings(button).如果你使用到了多个view，就可以这样NSDictionaryOfVariableBindings(button,button1,button3...),这个名字也要跟参数format中的一一对应，缺一不可.注意这一点，否则会crash
     
     2.UIView API
     
     - (void)addConstraints:(NSArray *)constraints;
     在上面1中返回值类型是NSArray,而现在这个方法的参数也刚好是一个NSArray类型。那么直接把上一个方法的返回值当作这个方法的参数就可以了。如果你有多个VFL，你也可以利用可变数组( NSMutableArray)把这多个VFL返回的数据拼在一起，然后再调用addConstraints:方法。
     
     */
    
    // 1. 单控件的使用
    
    // 第一个aButton
    UIButton *aButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [aButton setTitle:@"点击一下" forState:UIControlStateNormal];
    aButton.backgroundColor = [UIColor blackColor];
    
    /*
      PS:值得注意的是,在用代码创建的UIView时，一定要加上下面这句代码，如果没有上面这一行，你的约束将不生效,控制台会输出一连串的错误.
      */
    aButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:aButton];
    
    // 添加横向水平约束.  @"H:|-[aButton]-|: 默认情况下表示leftAndRightOffSet = 20px
    // aButton leftOffSet = 10px  rightOffSet = 10px  width auto
    NSArray *contraints1 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[aButton]-10-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(aButton)];
    
    // 添加纵向垂直约束
    // aButton y = 100  h = 30
    NSArray *contraints2 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-100-[aButton(==30)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(aButton)];
    
    [self.view addConstraints:contraints1];
    [self.view addConstraints:contraints2];
    
    // 2. 多控件间关联使用
    
    // 第二个bButton
    UIButton *bButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [bButton setTitle:@"我是第二个bButton" forState:UIControlStateNormal];
    bButton.backgroundColor = [UIColor blueColor];
    bButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:bButton];
    
    // 添加水平约束
    NSArray *contraints3 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[bButton]-10-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(bButton)];
    [self.view addConstraints:contraints3];
    
    // 添加垂直约束. 默认情况下. 距离上一个控件的是8px.
    //NSArray *contraints4 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[aButton]-40-[bButton(==40)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(aButton,bButton)];
    //[self.view addConstraints:contraints4];
    
//    NSArray *contrainst5 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[aButton]-[bButton(==height)]" options:0 metrics:@{@"height":@30} views:NSDictionaryOfVariableBindings(aButton,bButton)];
//    
//    [self.view addConstraints:contrainst5];
    
    NSArray *contrainst6 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[bButton(aButton)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(aButton,bButton)];
    
    NSArray *contrainst7 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[aButton]-[bButton(aButton)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(aButton,bButton)];
    
    //通过@"H:|-[button1(button)]"，@"V:[button]-[button1(button)]"，这两句就可以轻松实现等宽等高了！
    [self.view addConstraints:contrainst6];
    [self.view addConstraints:contrainst7];
    
    // 格式字符串简介
    /**
     
     功能　　　　　　　　表达式
     
     水平方向  　　　　　　  H:  Horizontal
     
     垂直方向  　　　　　　  V:  Vertical
     
     Views　　　　　　　　 [view]
     
     SuperView　　　　　　|
     
     关系　　　　　　　　　>=,==,<=
     
     空间,间隙　　　　　　　-
     
     优先级　　　　　　　　@value
     
     */
    
    
    UIView *aView = [[UIView alloc]init];
    aView.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:aView];
    
    //没有这句的话，而又加了下面两句 addConstrainsts 则 aView 都不会显示在self.view上，即使上一句写了 addSubview。
    aView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-40-[aView(==50)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(aView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[bButton]-30-[aView(==50)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(aView,bButton)]];
    
    
    UIView *bView = [[UIView alloc]init];
    bView.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:bView];
    
    bView.translatesAutoresizingMaskIntoConstraints = NO;
    
    ///实现与aView等大小
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[aView]-50-[bView(aView)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(aView,bView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[bButton]-30-[bView(aView)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(bButton,bView,aView)]]; //注意后面字典中出现的views一定要与FLV里出现的一致，不能少,多了可以，如写上aButton也没关系。
    
    
    ///这样就可以根据（如果有一个装文字的label，算出其rect）大小设置view的大小了
    CGFloat fload = 100;
    NSDictionary *dic = @{@"width":@(fload),@"height":@50};
    
    UIView *cView = [[UIView alloc]init];
    cView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:cView];
    
    cView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[bView]-50-[cView(==width)]" options:0 metrics:dic views:NSDictionaryOfVariableBindings(bView,cView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[bButton]-30-[cView(==height)]" options:0 metrics:dic views:NSDictionaryOfVariableBindings(bButton,cView)]];
    
    
    
    ///根据文字大小来决定view的长度
    UILabel *label1 = [[UILabel alloc]init];
    label1.backgroundColor = [UIColor yellowColor];
    label1.text = @"abcdefghijklmnddsafksajfkjwiojfaj";
    label1.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:label1];
    
    ///计算文字长度
    float width = [label1 textRectForBounds:CGRectMake(0, 0, CGFLOAT_MAX, 30) limitedToNumberOfLines:1].size.width;
    NSDictionary *dic2 = @{@"width2":@(width)};
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-40-[label1(==width2)]" options:0 metrics:dic2 views:NSDictionaryOfVariableBindings(label1)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[cView]-50-[label1(==30)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(cView,label1)]];
    
    //另一种计算文字长度的方法
    //CGRect rect = [label.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, high) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:label.font.pointSize]} context:nil];
    //float width = rect.size.width;
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
