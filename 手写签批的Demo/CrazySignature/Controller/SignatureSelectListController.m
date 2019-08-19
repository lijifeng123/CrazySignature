//
//  SignatureSelectListController.m
//  手写签批的Demo
//
//  Created by MacBook on 2019/8/19.
//  Copyright © 2019 MacBook. All rights reserved.
//

#import "SignatureSelectListController.h"
#import "Masonry.h"

@interface SignatureSelectListController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *selectTbv;


@end

static NSString *cellId = @"selectCell";

@implementation SignatureSelectListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configUI];
}

- (void)configUI{
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.selectTbv];
    [self.selectTbv mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.edges.mas_equalTo(self.view.safeAreaInsets);
        } else {
            make.edges.mas_equalTo(self.view);
        }
    }];
}

- (UITableView *)selectTbv{
    if (!_selectTbv) {
        _selectTbv = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _selectTbv.delegate = self;
        _selectTbv.dataSource = self;
        [_selectTbv registerClass:[UITableViewCell class] forCellReuseIdentifier:cellId];
    }
    return _selectTbv;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    cell.textLabel.text = @"123";
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self dismissViewControllerAnimated:YES completion:^{
        if ([self.delegate respondsToSelector:@selector(getSignaturePic:)]) {
            [self.delegate getSignaturePic:[UIImage new]];
        }
    }];
}

@end
