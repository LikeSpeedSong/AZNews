//
//  ViewController.m
//  AddChildVC
//
//  Created by A_zhi on 2017/8/28.
//  Copyright © 2017年 Azhi. All rights reserved.
//

#import "ViewController.h"
#import "PageVC.h"
#define kScreenW  [UIScreen mainScreen].bounds.size.width
#define kScreenH  [UIScreen mainScreen].bounds.size.height
@interface ViewController ()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *smallScrollView;

@property (weak, nonatomic) IBOutlet UIScrollView *bigScrollView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addChildVCs];
    [self addHeaderView];
  
    _bigScrollView.pagingEnabled = YES;
    _smallScrollView.contentSize = CGSizeMake(self.childViewControllers.count * 70, 0);
    _bigScrollView.contentSize = CGSizeMake(self.childViewControllers.count*kScreenW, 0);
    _bigScrollView.delegate = self;
    
    UIViewController * firstVC = self.childViewControllers.firstObject;
    [_bigScrollView addSubview:firstVC.view];
}

- (void)addHeaderView{
    for (int i = 0; i<8; i++) {
       NSString * name = [NSString stringWithFormat:@"页面%d",i];
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(70*i, 5, 70, 40);
        [button addTarget:self action:@selector(sectionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:name forState:UIControlStateNormal];
        button.tag = i;
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        if(i == 0)
             [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_smallScrollView addSubview:button];
    }
}


- (void)addChildVCs {
    for (int i = 0; i<8; i++) {
        PageVC * pageVC = [[PageVC alloc]init];
        pageVC.name = [NSString stringWithFormat:@"页面%d",i];
        [self addChildViewController:pageVC];
    }
}


- (void)sectionButtonClick:(UIButton*)button{
    NSInteger index = button.tag;
    [_bigScrollView setContentOffset:CGPointMake(index*kScreenW, 0) animated:YES];
}



- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    // 获得索引
    NSUInteger index = scrollView.contentOffset.x / self.bigScrollView.frame.size.width;
    
    PageVC * currentVC = self.childViewControllers[index];
    // 不要忘记 设置 frame
    currentVC.view.frame = scrollView.bounds;
    [self.bigScrollView addSubview:currentVC.view];
    
    [self.smallScrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
    }];
    CGFloat offSet = (index+1)*70 - kScreenW;
    // 设置 smallScrollView 选中状态可见
    [_smallScrollView setContentOffset:CGPointMake(offSet > 0?offSet:0, 0) animated:YES];
    
    
    [self.smallScrollView.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [self setSelectedBtnIndex:idx withColor:idx!=index?[UIColor blackColor]:[UIColor redColor]];
    }];
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:scrollView];
}

// 设置 选中 样式
- (void)setSelectedBtnIndex:(NSUInteger)idx withColor:(UIColor*)color{
    if ([self.smallScrollView.subviews[idx] isKindOfClass:[UIButton class]]) {
        UIButton * btn = self.smallScrollView.subviews[idx];
        [btn setTitleColor:color forState:UIControlStateNormal];
        
    }
}

@end
