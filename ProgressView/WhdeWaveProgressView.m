//
//  WhdeWaveProgressView.m
//  ProgressView
//
//  Created by Whde on 2018/6/26.
//  Copyright © 2018年 Whde. All rights reserved.
//

#import "WhdeWaveProgressView.h"
#import <Masonry/Masonry.h>

@interface WhdeWaveProgressView ()
@property (nonatomic,assign)CGFloat yHeight;
@property (nonatomic,assign)CGFloat offset;
@property (nonatomic,strong)CADisplayLink * timer;
@property (nonatomic,strong)CAShapeLayer *labelColorLayer;
@property (nonatomic,strong)UILabel *progressLabelBg;
@property (nonatomic,strong)UILabel *msgLabelBg;
@property (nonatomic,strong)UILabel *msgLabel;
@property (nonatomic,strong)CAShapeLayer *msgLabelColorLayer;
@end

@implementation WhdeWaveProgressView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.bounds = CGRectMake(0, 0, MIN(frame.size.width, frame.size.height), MIN(frame.size.width, frame.size.height));
        self.waveHeight = 5.0;
        self.yHeight = self.bounds.size.height;
        self.speed=1.0;
        
        [self.layer addSublayer:self.waveLayer];
        CAGradientLayer *gLayer = [[CAGradientLayer alloc] init];
        [gLayer setColors:[NSArray arrayWithObjects:(id)RGBA(250, 217, 97, 1).CGColor,(id)RGBA(254, 87, 33, 1).CGColor, nil]];
        gLayer.startPoint = CGPointMake(0, 0);
        gLayer.endPoint = CGPointMake(0, 1);
        gLayer.frame = self.bounds;
        [gLayer setMask:_waveLayer];
        [self.layer addSublayer:gLayer];
        
        [self addSubview:self.progressLabelBg];
        [self addSubview:self.progressLabel];
        [self.layer addSublayer:self.labelColorLayer];
        self.labelColorLayer.mask = self.progressLabel.layer;
        
        [self addSubview:self.msgLabelBg];
        [self addSubview:self.msgLabel];
        [self.layer addSublayer:self.msgLabelColorLayer];
        self.msgLabelColorLayer.mask = self.msgLabel.layer;
    }
    return self;
}

-(void)setProgress:(CGFloat)progress {
    _progress = progress;
    self.labelColorLayer.fillColor = [UIColor colorWithWhite:progress*1.8 alpha:1].CGColor;
    self.msgLabelColorLayer.fillColor = self.labelColorLayer.fillColor;
    self.yHeight = self.bounds.size.height * (1 - progress);
    [self stopWave];
    [self wave];
}

- (void)wave {
    self.timer = [CADisplayLink displayLinkWithTarget:self selector:@selector(waveAnimation)];
    [self.timer addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}
- (void)stopWave {
    [self.timer invalidate];
    self.timer = nil;
}
- (void)waveAnimation {
    CGFloat waveHeight = self.waveHeight;
    if (self.progress == 0.0f || self.progress == 1.0f) {
        waveHeight = 0.f;
    }
    self.offset += self.speed;
    CGMutablePathRef pathRef = CGPathCreateMutable();
    CGFloat startOffY = waveHeight * sinf(self.offset * M_PI * 2 / self.bounds.size.width);
    CGFloat orignOffY = 0.0;
    CGPathMoveToPoint(pathRef, NULL, 0, startOffY);
    for (CGFloat i = 0.f; i <= self.bounds.size.width; i++) {
        orignOffY = waveHeight * sinf(2 * M_PI / self.bounds.size.width * i + self.offset * M_PI * 2 / self.bounds.size.width) + self.yHeight;
        CGPathAddLineToPoint(pathRef, NULL, i, orignOffY);
    }
    
    CGPathAddLineToPoint(pathRef, NULL, self.bounds.size.width, orignOffY);
    CGPathAddLineToPoint(pathRef, NULL, self.bounds.size.width, self.bounds.size.height);
    CGPathAddLineToPoint(pathRef, NULL, 0, self.bounds.size.height);
    CGPathAddLineToPoint(pathRef, NULL, 0, startOffY);
    CGPathCloseSubpath(pathRef);
    self.waveLayer.path = pathRef;
    self.labelColorLayer.path = pathRef;
    self.msgLabelColorLayer.path = pathRef;
    CGPathRelease(pathRef);
}

#pragma mark ----- INITUI ----
-(CAShapeLayer *)waveLayer{
    if (!_waveLayer) {
        _waveLayer = [CAShapeLayer layer];
        _waveLayer.frame = self.bounds;
    }
    return _waveLayer;
}

- (UILabel *)msgLabelBg {
    if (!_msgLabelBg) {
        _msgLabelBg = [[UILabel alloc] initWithFrame:CGRectMake(0, 23, 60, 20)];
        _msgLabelBg.center = CGPointMake(CGRectGetWidth(self.frame)/2, _msgLabelBg.center.y);
        _msgLabelBg.font = [UIFont fontWithName:@"HiraMaruProN" size:12];
        _msgLabelBg.textAlignment = NSTextAlignmentCenter;
        _msgLabelBg.text = @"已完成";
        _msgLabelBg.textColor = RGBA(254, 87, 33, 1);
        [self addSubview:_msgLabelBg];
    }
    return _msgLabel;
}
- (UILabel *)msgLabel {
    if (!_msgLabel) {
        _msgLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 23, 60, 20)];
        _msgLabel.center = CGPointMake(CGRectGetWidth(self.frame)/2, _msgLabel.center.y);
        _msgLabel.font = [UIFont fontWithName:@"HiraMaruProN" size:12];
        _msgLabel.textAlignment = NSTextAlignmentCenter;
        _msgLabel.text = @"已完成";
        _msgLabel.textColor = RGBA(254, 87, 33, 1);
        [self addSubview:_msgLabel];
        [_msgLabel addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];
    }
    return _msgLabel;
}

-(UILabel *)progressLabelBg {
    if (!_progressLabelBg) {
        _progressLabelBg=[[UILabel alloc] init];
        _progressLabelBg.frame=self.bounds;
        _progressLabelBg.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
        _progressLabelBg.font=[UIFont systemFontOfSize:20];
        _progressLabelBg.textColor=[UIColor colorWithWhite:0 alpha:1];
        _progressLabelBg.textAlignment=1;

    }
    return _progressLabelBg;
}
-(UILabel *)progressLabel {
    if (!_progressLabel) {
        _progressLabel=[[UILabel alloc] init];
        _progressLabel.text=@"0%";
        _progressLabel.frame=self.bounds;
        _progressLabel.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
        _progressLabel.font=[UIFont systemFontOfSize:20];
        _progressLabel.textColor=[UIColor colorWithWhite:0 alpha:1];
        _progressLabel.textAlignment=1;
        [_progressLabel addObserver:self forKeyPath:@"attributedText" options:NSKeyValueObservingOptionNew context:nil];
    }
    return _progressLabel;
}

-(CAShapeLayer *)labelColorLayer{
    if (!_labelColorLayer) {
        _labelColorLayer = [CAShapeLayer layer];
        _labelColorLayer.frame = self.bounds;
        _labelColorLayer.fillColor = RGBA(255, 255, 255, 0.7).CGColor;
    }
    return _labelColorLayer;
}
-(CAShapeLayer *)msgLabelColorLayer{
    if (!_msgLabelColorLayer) {
        _msgLabelColorLayer = [CAShapeLayer layer];
        _msgLabelColorLayer.frame = self.bounds;
        _msgLabelColorLayer.fillColor = RGBA(255, 255, 255, 0.7).CGColor;
    }
    return _msgLabelColorLayer;
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqual:@"text"]) {
        _msgLabelBg.text = _msgLabel.text;
    } else if ([keyPath isEqual:@"attributedText"]) {
        _progressLabelBg.attributedText = _progressLabel.attributedText;
    }
}

-(void)dealloc {
    [self.timer invalidate];
    [self.msgLabel removeObserver:self forKeyPath:@"text"];
    [self.progressLabel removeObserver:self forKeyPath:@"attributedText"];
    self.timer = nil;
    if (_waveLayer) {
        [_waveLayer removeFromSuperlayer];
        _waveLayer = nil;
    }
    if (_labelColorLayer) {
        [_labelColorLayer removeFromSuperlayer];
        _labelColorLayer = nil;
    }
    if (_msgLabelColorLayer) {
        [_msgLabelColorLayer removeFromSuperlayer];
        _msgLabelColorLayer = nil;
    }
}


@end
