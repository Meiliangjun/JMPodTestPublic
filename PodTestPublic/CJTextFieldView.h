//
//  CJTextFieldView.h
//  Antenna
//
//  Created by HHLY on 16/6/13.
//  Copyright © 2016年 HHLY. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, CJTextFieldViewMode) {
    CJTextFieldViewModePassword,
    CJTextFieldViewModeDefault,
    CJTextFieldViewModeFrontIcon, // 前面是图片
};

///自定义输入框(Only for input password or user name)
@interface CJTextFieldView : UIView

@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, assign) BOOL editing;//!< 是否正在编辑
@property (nonatomic, assign) BOOL secureTextEntry;//!< 是否是隐藏输入内容

- (instancetype)init __attribute__((unavailable("init not available, call initWithMode: instead")));
- (instancetype)initWithFrame:(CGRect)frame __attribute__((unavailable("initWithFrame: not available, call initWithMode: instead")));
- (instancetype)new __attribute__((unavailable("new not available, call initWithMode instead")));

- (instancetype)initWithMode:(CJTextFieldViewMode)mode;

@end
