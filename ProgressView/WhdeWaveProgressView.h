//
//  WhdeWaveProgressView.h
//  ProgressView
//
//  Created by Whde on 2018/6/26.
//  Copyright © 2018年 Whde. All rights reserved.
//

#import <UIKit/UIKit.h>
#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

@interface WhdeWaveProgressView : UIView
@property (nonatomic,assign)CGFloat progress;
@property (nonatomic,assign)CGFloat speed;
@property (nonatomic,assign)CGFloat waveHeight;
@property (nonatomic,strong)UILabel *progressLabel;
@property (nonatomic,strong)CAShapeLayer *waveLayer;
@end
