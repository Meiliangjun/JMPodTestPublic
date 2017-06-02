//
//  CJTextFieldView.m
//  Antenna
//
//  Created by HHLY on 16/6/13.
//  Copyright © 2016年 HHLY. All rights reserved.
//

#import "CJTextFieldView.h"

@interface CJTextFieldView ()<UITextFieldDelegate>

@property (strong, nonatomic) UITextField *textField;
@property (strong, nonatomic) UIView *lineView;
@property (strong, nonatomic) UIButton *showPwdBtn;
@property (strong, nonatomic) UIImageView *iconImageView;

@property (assign, nonatomic) CJTextFieldViewMode inputMode;

@end

@implementation CJTextFieldView

#pragma mark - Lazy
- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.textColor = [CJCommonColor colorHex333333];
        _textField.font = CJFont(15);
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.delegate = self;
    }
    return _textField;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [CJCommonColor colorHexC7c7c7];
    }
    return _lineView;
}

- (UIButton *)showPwdBtn {
    if (!_showPwdBtn) {
        _showPwdBtn = [[UIButton alloc] init];
        [_showPwdBtn setBackgroundImage:[UIImage imageNamed:@"不显示密码"] forState:UIControlStateNormal];
        [_showPwdBtn setBackgroundImage:[UIImage imageNamed:@"显示密码"] forState:UIControlStateSelected];
        [_showPwdBtn addTarget:self action:@selector(changeSecureTextEntry:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _showPwdBtn;
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"my_account_password_icon"]];
    }
    return _iconImageView;
}

#pragma mark - Property
- (void)setPlaceholder:(NSString *)placeholder {
    self.textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder attributes:@{NSFontAttributeName: CJFont(15), NSForegroundColorAttributeName: [CJCommonColor colorHex999999]}];
    _placeholder = placeholder;
}

- (void)setSecureTextEntry:(BOOL)secureTextEntry {
    _secureTextEntry = secureTextEntry;
    self.textField.secureTextEntry = secureTextEntry;
}

- (void)setText:(NSString *)text {
    self.textField.text = text;
    _text = text;
}

#pragma mark - Initialize
- (instancetype)initWithMode:(CJTextFieldViewMode)mode {
    self = [super init];
    if (self) {
        self.inputMode = mode;
        [self initializedSubViews];
        [self acceptNotification];
    }
    return self;
}

- (void)initializedSubViews {
    [self addSubview:self.textField];
    [self addSubview:self.lineView];
    if (self.inputMode == CJTextFieldViewModeFrontIcon) {
        [self addSubview:self.iconImageView];
    }
    else {
        [self addSubview:self.showPwdBtn];
    }
    
    CJWeakSelf;
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        if (self.inputMode == CJTextFieldViewModeFrontIcon) {
            make.centerY.equalTo(weakSelf);
            make.trailing.equalTo(weakSelf);
            make.leading.equalTo(weakSelf.iconImageView.mas_trailing).offset(12);
        }
        else {
            make.top.leading.equalTo(weakSelf).offset(8);
            make.trailing.equalTo(weakSelf.showPwdBtn.mas_leading).offset(44);
            make.bottom.equalTo(weakSelf.lineView.mas_top).offset(4);
        }
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.bottom.trailing.equalTo(weakSelf);
        make.height.with.mas_equalTo(@(.5));
    }];
    
    if (self.inputMode == CJTextFieldViewModeFrontIcon) {
        [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(weakSelf);
            make.size.mas_equalTo(@16);
            make.centerY.equalTo(weakSelf.textField);
        }];
    }
    else {
        [self.showPwdBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(weakSelf).offset(-4);
            make.size.mas_equalTo(CGSizeMake(40, 40));
            make.bottom.equalTo(weakSelf.lineView.mas_top).offset(4);
        }];
    }
}

- (void)setInputMode:(CJTextFieldViewMode)inputMode {
    _inputMode = inputMode;
    if (inputMode == CJTextFieldViewModeFrontIcon) {
        return;
    }
    self.showPwdBtn.alpha = !(inputMode == CJTextFieldViewModeDefault);
}

#pragma mark - Obverser
- (void)acceptNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChangeNotification:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)removeNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

#pragma mark - Actions
- (void)changeSecureTextEntry:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.textField.secureTextEntry = !sender.isSelected;
}

- (void)textFieldDidChangeNotification:(NSNotification *)notification {
//    CJLog(@"notification: %@", notification);
    if ([notification.object isEqual:self.textField]) {
//        CJLog(@"self.textField.text: %@", self.textField.text);
        [self willChangeValueForKey:@"text"];
        _text = self.textField.text;
        [self didChangeValueForKey:@"text"];
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (self.inputMode == CJTextFieldViewModePassword) {
        textField.secureTextEntry = YES;
    }
    self.lineView.backgroundColor = [CJCommonColor colorHex22aeff];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    self.lineView.backgroundColor = [CJCommonColor colorHexcccccc];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *resultText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (resultText.length > 40) {
        return NO;
    }
    return YES;
}

@end
