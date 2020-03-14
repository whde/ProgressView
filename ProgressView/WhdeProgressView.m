//
//  WhdeProgressView.m
//  ProgressView
//
//  Created by Whde on 2018/6/26.
//  Copyright © 2018年 Whde. All rights reserved.
//

#import "WhdeProgressView.h"
#import <Masonry/Masonry.h>
#import "WhdeWaveProgressView.h"
@interface WhdeProgressView () {
    UIFont *_progressFont;
}
@property (strong, nonatomic) WhdeWaveProgressView *waveProgressView;
@property (strong, nonatomic) UIBezierPath *bezierPath;
@property (nonatomic, strong) CAShapeLayer *progressBgLayer;
@property (nonatomic, strong) CAShapeLayer *progressLayer;
@property (nonatomic, strong) CAShapeLayer *arcLayer;
@property (nonatomic, assign) NSInteger progress;
@end

@implementation WhdeProgressView

- (UIFont *)progressFont {
    if (!_progressFont) {
        _progressFont = [UIFont fontWithName:@"ArialRoundedMTBold" size:60];
    }
    return _progressFont;
}

- (void)setProgress:(NSInteger)progress {
    _progress = progress;
    [self layoutSubviews];
}


- (WhdeWaveProgressView *)waveProgressView {
    if (!_waveProgressView) {
        _waveProgressView = [[WhdeWaveProgressView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width-25, self.frame.size.width-25)];
        _waveProgressView.layer.masksToBounds = YES;
        _waveProgressView.backgroundColor = RGBA(254, 87, 33, 0.06);
        _waveProgressView.layer.cornerRadius =(self.frame.size.width-25)/2;
        _waveProgressView.waveHeight = 10;
        _waveProgressView.speed = 1.0;
        _waveProgressView.progressLabel.hidden = NO;
        _waveProgressView.progressLabel.font = [UIFont systemFontOfSize:12];
        _waveProgressView.progressLabel.textAlignment = NSTextAlignmentCenter;
        _waveProgressView.progressLabel.textColor = RGBA(254, 87, 33, 1);
        [self addSubview:_waveProgressView];
        [_waveProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(12.5);
            make.left.equalTo(self).offset(12.5);
            make.right.equalTo(self).offset(-12.5);
            make.bottom.equalTo(self).offset(-12.5);
        }];    }
    return _waveProgressView;
}

- (UIBezierPath *)bezierPath {
    if (!_bezierPath) {
        _bezierPath = [UIBezierPath bezierPath];
        CGFloat radius = (self.frame.size.width-11)/2;
        [_bezierPath moveToPoint:CGPointMake(radius+5.5, 5.5)];
        CGFloat startAngle = -M_PI_2;
        CGFloat endAngle = startAngle+M_PI*2;
        [_bezierPath addArcWithCenter:CGPointMake(radius+5.5, radius+5.5) radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
    }
    return _bezierPath;
}

- (UIBezierPath *)arcBezierPath:(CGFloat)progress {
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    CGFloat radius = (self.frame.size.width-11)/2;
    [bezierPath moveToPoint:CGPointMake(radius+5.5, 5.5)];
    CGFloat startAngle = -M_PI_2;
    CGFloat endAngle = startAngle+M_PI*2*progress;
    [bezierPath addArcWithCenter:CGPointMake(radius+5.5, radius+5.5) radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
    return bezierPath;
}


- (CAShapeLayer *)progressBgLayer {
    if (!_progressBgLayer) {
        _progressBgLayer = [[CAShapeLayer alloc] init];
        _progressBgLayer.fillColor = [UIColor clearColor].CGColor;
        _progressBgLayer.lineWidth = 1;
        _progressBgLayer.strokeColor = RGBA(194, 194, 194, 1).CGColor;
        _progressBgLayer.strokeStart = 0;
        _progressBgLayer.strokeEnd = 1;
        _progressBgLayer.frame = self.bounds;
        _progressBgLayer.path = self.bezierPath.CGPath;
        _progressBgLayer.lineCap = @"round";
    }
    return _progressBgLayer;
}
- (CAShapeLayer *)progressLayer {
    if (!_progressLayer) {
        _progressLayer = [[CAShapeLayer alloc] init];
        _progressLayer.fillColor = [UIColor clearColor].CGColor;
        _progressLayer.lineWidth = 3.0;
        _progressLayer.strokeColor = RGBA(254, 87, 33, 1).CGColor;
        _progressLayer.strokeStart = 0;
        _progressLayer.strokeEnd = 0;
        _progressLayer.frame = self.bounds;
        _progressLayer.path = self.bezierPath.CGPath;
        _progressLayer.lineCap = @"round";
        _progressLayer.shadowColor = RGBA(254, 87, 33, 1).CGColor;
        _progressLayer.shadowOpacity = 0.4;
        _progressLayer.shadowRadius = 4;
        _progressLayer.shadowOffset = CGSizeMake(0, 1);
    }
    return _progressLayer;
}

- (CAShapeLayer *)arcLayer {
    if (!_arcLayer) {
        UIBezierPath *path = [UIBezierPath bezierPath];
        CGRect rect = CGRectMake(0, 0, 11, 11);
        [path addArcWithCenter:CGPointMake(rect.size.width/2,rect.size.height/2) radius:5.5 startAngle:0 endAngle:2*M_PI clockwise:NO];
        _arcLayer = [CAShapeLayer layer];
        _arcLayer.path = path.CGPath;
        _arcLayer.fillColor = RGBA(254, 87, 33, 1).CGColor;
        _arcLayer.frame = rect;
        _arcLayer.shadowColor = RGBA(254, 87, 33, 1).CGColor;
        _arcLayer.shadowOpacity = 0.4;
        _arcLayer.shadowRadius = 4;
        _arcLayer.shadowOffset = CGSizeMake(0, 1);
    }
    return _arcLayer;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _bezierPath = nil;
    if (_progressLayer.superlayer) {
        [_progressLayer removeFromSuperlayer];
        _progressLayer = nil;
    }
    if (_progressBgLayer.superlayer) {
        [_progressBgLayer removeFromSuperlayer];
        _progressBgLayer = nil;
    }
    self.waveProgressView.progress = self.progress/100.0;
    NSString *progress = [NSString stringWithFormat:@" %ld%%", (long)_progress];
    if (_progress==100) {
        _progressFont = [UIFont fontWithName:@"ArialRoundedMTBold" size:50];
    }
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:progress attributes:@{NSFontAttributeName:self.progressFont, NSForegroundColorAttributeName:RGBA(254, 87, 33, 1)}];
    NSRange range = [progress rangeOfString:@"%"];
    if (range.location != NSNotFound) {
        [attri addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PingFangSC-Regular" size:24] range:range];
    }
    self.waveProgressView.progressLabel.attributedText = attri;
    
    self.layer.backgroundColor = [UIColor clearColor].CGColor;
    self.layer.masksToBounds = NO;
    [self.layer addSublayer:self.progressBgLayer];
    [self.layer addSublayer:self.progressLayer];
    [self.layer addSublayer:self.arcLayer];
    
    CABasicAnimation *progressLayerAnimation = [[CABasicAnimation alloc] init];
    progressLayerAnimation.keyPath = @"strokeEnd";
    progressLayerAnimation.duration = 3;
    progressLayerAnimation.fromValue = @(0);
    progressLayerAnimation.toValue = @(_progress/100.0);
    progressLayerAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    progressLayerAnimation.removedOnCompletion = NO;
    progressLayerAnimation.fillMode = kCAFillModeForwards;
    [self.progressLayer addAnimation:progressLayerAnimation forKey:@"progressLayerAnimation"];
    
    CAKeyframeAnimation *arcLayerAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    arcLayerAnimation.path = [self arcBezierPath:_progress/100.0].CGPath;
    arcLayerAnimation.duration = 3;
    arcLayerAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    arcLayerAnimation.beginTime = CACurrentMediaTime();
    arcLayerAnimation.removedOnCompletion = NO;
    arcLayerAnimation.fillMode = kCAFillModeForwards;
    arcLayerAnimation.calculationMode = kCAAnimationCubicPaced;
    
    [self.arcLayer addAnimation:arcLayerAnimation forKey:@"arcLayerAnimation"];
}
@end
