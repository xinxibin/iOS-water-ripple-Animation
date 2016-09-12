//
//  ViewController.m
//  ios 中波纹动画
//
//  Created by Xinxibin on 16/7/19.
//  Copyright © 2016年 GloryMan. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic,strong)UIView *testView;
@property (nonatomic,strong)UIBezierPath *path;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setup];
    self.view.multipleTouchEnabled = TRUE;
}

//波纹，咻一咻，雷达效果
- (void)setup
{
    _testView=[[UIView alloc] initWithFrame:CGRectMake(30, 300, 100, 100)];
    _testView.center = self.view.center;
    [self.view addSubview:_testView];
    _testView.layer.backgroundColor = [UIColor clearColor].CGColor;
    
    CAShapeLayer *pulseLayer = [CAShapeLayer layer];
    pulseLayer.frame = _testView.layer.bounds;
    pulseLayer.path = [UIBezierPath bezierPathWithOvalInRect:pulseLayer.bounds].CGPath;
    pulseLayer.fillColor = [UIColor blueColor].CGColor;//填充色
    pulseLayer.opacity = 0; // 层的透明度
    
    // 图层复制类
    CAReplicatorLayer *replicatorLayer = [CAReplicatorLayer layer];
    replicatorLayer.frame = _testView.bounds;
    replicatorLayer.instanceCount = 8;//创建副本的数量,包括源对象。
    replicatorLayer.instanceDelay = 0.5;//复制副本之间的延迟
    [replicatorLayer addSublayer:pulseLayer];
    [_testView.layer addSublayer:replicatorLayer];
    
    CABasicAnimation *opacityAnima = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnima.fromValue = @(0.5);
    opacityAnima.toValue = @(0.0);
    
    CABasicAnimation *scaleAnima = [CABasicAnimation animationWithKeyPath:@"transform"];
    scaleAnima.fromValue = [NSValue valueWithCATransform3D:CATransform3DScale(CATransform3DIdentity, 0.0, 0.0, 0.0)];
    scaleAnima.toValue = [NSValue valueWithCATransform3D:CATransform3DScale(CATransform3DIdentity, 2, 2, 0.0)];
    
    CAAnimationGroup *groupAnima = [CAAnimationGroup animation];
    groupAnima.animations = @[opacityAnima, scaleAnima];
    groupAnima.duration = 4.0;
    groupAnima.autoreverses = NO;
    groupAnima.repeatCount = HUGE;
    [pulseLayer addAnimation:groupAnima forKey:@"groupAnimation"];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    CGPoint point = [[touches anyObject] locationInView:self.view];
    
    CGFloat width  = 0;
    if (point.x > point.y) {
        width = point.x;
    } else {
        width = point.y;
    }
    
    if (width <= [UIScreen mainScreen].bounds.size.width - point.x) {
        width = [UIScreen mainScreen].bounds.size.width - point.x;
    }
    
    if (width <= [UIScreen mainScreen].bounds.size.height - point.y) {
        width = [UIScreen mainScreen].bounds.size.height - point.y;
    }
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.frame = CGRectMake(0, 0, width * 2, width * 2);
    shapeLayer.position = point;
    shapeLayer.path = [UIBezierPath bezierPathWithOvalInRect:shapeLayer.bounds].CGPath;
    shapeLayer.fillColor = [UIColor blackColor].CGColor;//填充色
//    shapeLayer.strokeColor = [UIColor redColor].CGColor;
    shapeLayer.opacity = 0.0; // 层的透明度
    
    // 如果不设置下面的两句 就会有另外一种效果哦 可以下看看哦
//    shapeLayer.strokeColor = [UIColor blackColor].CGColor; // 在设置线宽的情况下有效
//    shapeLayer.lineWidth = 4;
    
    CAReplicatorLayer *replicatorLayer = [CAReplicatorLayer layer];
    replicatorLayer.frame = shapeLayer.bounds;
    replicatorLayer.instanceCount = 1;//创建副本的数量,包括源对象。
    replicatorLayer.instanceDelay = 3;//复制副本之间的延迟
    [replicatorLayer addSublayer:shapeLayer];
    [self.view.layer addSublayer:replicatorLayer];
    
    CABasicAnimation *opacityAnima = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnima.fromValue = @(0.5);
    opacityAnima.toValue = @(0.0);
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    // 修改这两个值来达到 扩散 还是 回收 记得修改 透明度（ opacityAnima ） 要不会 一闪一闪
    scaleAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DScale(CATransform3DIdentity, 0.0, 0.0, 0.0)];
    scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DScale(CATransform3DIdentity, 2, 2, 0.0)];
    
    CAAnimationGroup *groupAnima = [CAAnimationGroup animation];
    groupAnima.animations = @[opacityAnima, scaleAnimation];
    groupAnima.duration = 2.0;
    groupAnima.autoreverses = NO;
    groupAnima.repeatCount = 1;
    [shapeLayer addAnimation:groupAnima forKey:@"groupAnimation"];

}

@end
