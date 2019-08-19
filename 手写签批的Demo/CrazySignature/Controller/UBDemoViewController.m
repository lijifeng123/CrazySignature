/**
 hehe
 */

#import "UBDemoViewController.h"
#import "UBSignatureDrawingViewController.h"
#import "Masonry.h"
#import "TopMoveImageView.h"
#import "CrazyImageView.h"
#import "SignatureSelectListController.h"

#define SCREENWITH [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height

@interface UBDemoViewController () <UBSignatureDrawingViewControllerDelegate,SelectDelegate>

@property (nonatomic) UBSignatureDrawingViewController *signatureViewController;
@property (nonatomic) UIButton *resetButton;
@property (nonatomic, strong) UITextView *contentTextView;
@property (nonatomic, strong) UIImageView *bigImv;

@property (nonatomic, strong) NSMutableAttributedString *mAtts;
@property (nonatomic, strong) CrazyImageView *bgImageView;
@property (nonatomic, strong) TopMoveImageView *topView; //章

@property (nonatomic, strong) UIView *accessView;//键盘上的view


@end

@implementation UBDemoViewController

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self baseConfig];
    [self configKeyboard];
    [self configTop];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.contentTextView becomeFirstResponder];
}

- (NSMutableAttributedString *)mAtts{
    if (!_mAtts) {
        _mAtts = [[NSMutableAttributedString alloc] init];
    }
    return _mAtts;
}

- (CrazyImageView *)bgImageView{
    if (!_bgImageView) {
        _bgImageView = [[CrazyImageView alloc] init];
        _bgImageView.userInteractionEnabled = YES;
        _bgImageView.backgroundColor = [UIColor redColor];
    }
    return _bgImageView;
}

- (UIImageView *)bigImv{
    if (!_bigImv) {
        _bigImv = [[UIImageView alloc] init];
        _bigImv.userInteractionEnabled = YES;
        _bigImv.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _bigImv;
}

- (TopMoveImageView *)topView{
    if (!_topView) {
        _topView = [[TopMoveImageView alloc] init];
        _topView.userInteractionEnabled = YES;
        _topView.contentMode = UIViewContentModeScaleAspectFit;
        _topView.tag = 10010;
    }
    return _topView;
}

- (UITextView *)contentTextView{
    if (!_contentTextView) {
        _contentTextView = [[UITextView alloc] init];
        _contentTextView.font = [UIFont systemFontOfSize:25];
        _contentTextView.backgroundColor = [UIColor clearColor];
        _contentTextView.tag = 10086;
    }
    return _contentTextView;
}


- (void)baseConfig{
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.bgImageView];
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(200);
        make.centerX.mas_equalTo(self.view);
        if (@available(iOS 11, *)) {
            make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(50);
        } else {
            make.top.mas_equalTo(self.view).offset(50);
        }
        make.height.mas_equalTo(300);
    }];
    
    self.signatureViewController = [[UBSignatureDrawingViewController alloc] initWithImage:nil];
    self.signatureViewController.delegate = self;
    [self.bgImageView addSubview:self.signatureViewController.view];
    [self.signatureViewController didMoveToParentViewController:self];
    self.signatureViewController.view.backgroundColor = [UIColor orangeColor];
    self.signatureViewController.view.frame = CGRectMake(50, 20, SCREENWITH - 100, 300 - 40);
    
    UIView *keyboardView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWITH, 300)];
    keyboardView.backgroundColor = [UIColor purpleColor];
    [keyboardView addSubview:self.signatureViewController.view];

    self.contentTextView.inputView = keyboardView;
    [self.bgImageView addSubview:self.contentTextView];
    
    [self.contentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.bgImageView);
    }];

    self.bigImv.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:self.bigImv];
    [self.bigImv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentTextView.mas_bottom).offset(10);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(self.view).offset(-20);
        make.height.mas_equalTo(150);
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(btAttachAction) name:@"WRITEOVER" object:nil];
}

- (void)configKeyboard{
    
    UIView *accView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWITH, 30)];
    accView.backgroundColor = [UIColor lightGrayColor];
    self.contentTextView.inputAccessoryView = accView;
    
    NSMutableArray *btnArray = [NSMutableArray array];
    NSArray *titleArr = @[@"颜色",@"撤回",@"全部删除",@"电子签章"];
    if (self.topView.image != nil) {
        titleArr = @[@"颜色",@"撤回",@"全部删除",@"删除签章",@"电子签章"];
    }
    for (int i = 0; i < titleArr.count; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btnArray addObject:btn];
        [accView addSubview:btn];
        [self addtargetToBtn:btn tag:i];
    }
    [btnArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:70 leadSpacing:20 tailSpacing:20];
    [btnArray mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(accView);
    }];
    
    //需要刷新 不然accessView更新不过来
    [self.contentTextView reloadInputViews];
}

- (void)addtargetToBtn:(UIButton *)bt tag:(int)tag{
    if (tag == 0) {
        bt.tag = 1000;
        [bt setTitleColor:self.signatureViewController.signatureColor forState:UIControlStateNormal];
        [bt addTarget:self action:@selector(changeColor) forControlEvents:UIControlEventTouchUpInside];
    }else if (tag == 1){
        [bt addTarget:self action:@selector(withdrawAction) forControlEvents:UIControlEventTouchUpInside];
    }else if (tag == 2){
        [bt addTarget:self action:@selector(deleateAll) forControlEvents:UIControlEventTouchUpInside];
    }
    
    if (self.topView.image) {
        if (tag == 3){
            [bt addTarget:self action:@selector(deleteElectronicSignature) forControlEvents:UIControlEventTouchUpInside];
        }else if (tag == 4){
            [bt addTarget:self action:@selector(electronicSignature) forControlEvents:UIControlEventTouchUpInside];
        }
    }else{
        if (tag == 3){
            [bt addTarget:self action:@selector(electronicSignature) forControlEvents:UIControlEventTouchUpInside];
        }
    }
}

- (void)configTop{
    
    UIButton *generatePicBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [generatePicBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [generatePicBtn setTitle:@"完成" forState:UIControlStateNormal];
    [generatePicBtn addTarget:self action:@selector(getImv) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:generatePicBtn];
    [generatePicBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.mas_right).offset(-20);
        make.height.mas_equalTo(40);
        if (@available(iOS 11, *)) {
            make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop);
        } else {
            make.top.mas_equalTo(self.view);
        }
    }];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(20);
        make.height.mas_equalTo(40);
        if (@available(iOS 11, *)) {
            make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop);
        } else {
            make.top.mas_equalTo(self.view);
        }
    }];
}

- (void)changeColor{
    
    __weak typeof(self) weakSelf = self;
    UIButton *btn = [self.contentTextView.inputAccessoryView viewWithTag:1000];
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"颜色" message:@"请选择笔迹颜色" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"黑色" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        weakSelf.signatureViewController.signatureColor = [UIColor blackColor];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"红色" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        weakSelf.signatureViewController.signatureColor = [UIColor redColor];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alertVc addAction:action1];
    [alertVc addAction:action2];
    [alertVc addAction:cancelAction];
    [self presentViewController:alertVc animated:YES completion:nil];
}

- (void)withdrawAction{
    
    if (self.mAtts.length == 0) {
        return;
    }
    NSAttributedString *att = [self.mAtts attributedSubstringFromRange:NSMakeRange(0, self.mAtts.length - 1)];
    self.mAtts = [[NSMutableAttributedString alloc] initWithAttributedString:att];
    self.contentTextView.attributedText = self.mAtts;
}

- (void)deleateAll{
    
    self.mAtts = [NSMutableAttributedString new];
    self.contentTextView.attributedText = self.mAtts;
}

- (void)cancelAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)deleteElectronicSignature{
    
    self.topView.image = nil;
    [self configKeyboard];
}

- (void)electronicSignature{
    
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"请输入密码" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertVc addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入签章密码";
        textField.secureTextEntry = YES;
    }];
    [alertVc addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [alertVc addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        SignatureSelectListController *singatureVC = [[SignatureSelectListController alloc] init];
        singatureVC.delegate = self;
        [self presentViewController:singatureVC animated:YES completion:nil];
        
    }]];
    [self presentViewController:alertVc animated:YES completion:nil];
}

- (void)getSignaturePic:(UIImage *)img{
    
    UIImage *image = [UIImage imageNamed:@"1.jpeg"];
    NSAssert(image, @"大胸弟，图片不能为空");
    self.topView.image = image;
    self.topView.frame = CGRectMake(0, 10, 100, 100);
    [self.bgImageView addSubview:self.topView];
    [self.bgImageView insertSubview:self.topView belowSubview:self.contentTextView];
    [self configKeyboard];
}

#pragma mark- 这是一个截取局部图片的方法
- (void)getImv{
    
    UIView *subV = self.contentTextView.subviews[0];
    UIView *selectionView;
    Class cla = NSClassFromString(@"UITextSelectionView");
    for (UIView *subView in subV.subviews) {
        if ([subView isKindOfClass:cla]) {
            [subView removeFromSuperview];
            selectionView = subView;
        }
    }

    CGRect frame1 = subV.frame;
    CGFloat maxY1 = CGRectGetMaxY(frame1);
    CGRect frame2 = self.topView.frame;
    CGFloat maxY2 = CGRectGetMaxY(frame2);
    CGRect tailorFrame = CGRectZero;
    if (maxY1 > maxY2) {
        tailorFrame = CGRectMake(frame1.origin.x, frame1.origin.y, frame1.size.width, frame1.size.height);
    }else{
        tailorFrame = CGRectMake(frame1.origin.x, frame1.origin.y, frame1.size.width, maxY2);
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //UIGraphicsBeginImageContext(CGSize size) 不清晰
        //下面的清晰 后面写.0
        UIGraphicsBeginImageContextWithOptions(tailorFrame.size, YES, .0);
        [self.bgImageView drawViewHierarchyInRect:tailorFrame afterScreenUpdates:NO];
        [[self.bgImageView layer] renderInContext:UIGraphicsGetCurrentContext()];
        UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
        self.bigImv.image = image;
        UIGraphicsEndImageContext();
    });
}

- (void)btAttachAction{
    
    if (self.signatureViewController.fullSignatureImage == nil) {
        return;
    }
    
    [self inserPicToAttributeStringWithImage:self.signatureViewController.fullSignatureImage bounds:CGRectMake(0, 0, 25, 25)];
}

- (void)inserPicToAttributeStringWithImage:(UIImage *)image bounds:(CGRect)bounds{

    NSAssert(image, @"大胸弟，图片不能为空");
    
    NSTextAttachment *attach = [[NSTextAttachment alloc] init];
    attach.image = image;
    attach.bounds = bounds;
    NSAttributedString *attachString = [NSAttributedString attributedStringWithAttachment:attach];
    
    //将图片插入到合适的位置
    [self.mAtts insertAttributedString:attachString atIndex:self.contentTextView.attributedText.length];
    self.contentTextView.attributedText = self.mAtts;
    
    [self.signatureViewController reset];
}

@end
