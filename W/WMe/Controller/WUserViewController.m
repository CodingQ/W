//
//  WUserViewController.m
//  W
//
//  Created by harry.qian on 17/3/29.
//  Copyright © 2017年 harry.qian. All rights reserved.
//

#import "WUserViewController.h"
#import "WUserHeadView.h"
#import "WUserModel.h"
#import "WButton.h"
#import "WUserEditViewController.h"
#import "WDecideViewController.h"
@interface WUserViewController () <WUserHeadDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) WUserHeadView   *userHead;
@property (nonatomic, copy)   NSArray           *images;
@property (nonatomic, copy)   NSArray           *titles;
@property (nonatomic, strong) WUserHeadView   *headView;
@property (nonatomic, strong) WUserModel      *userModel;

@end

@implementation WUserViewController

- (NSArray *)images {
    if (!_images) {
//        _images = @[@"userEdit", @"upData", @"history", @"set"];
        _images = @[@"ziliao-sel",@"dianhua-sel",@"xuanze-sel"];
    }
    return _images;
}

- (NSArray *)titles {
    if (!_titles) {
//        _titles = @[@"个人资料", @"数据同步", @"历史记录", @"设置"];
         _titles = @[@"个人资料",@"呼叫",@"选择恐惧"];
    }
    return _titles;
}

- (WUserModel *)userModel {
    if (!_userModel) {
        _userModel = [[WUserModel alloc] init];
    }
    return _userModel;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshImage) name:Notic_updateImage object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadUserMessage) name:Notic_updateUser object:nil];
    
    [self.userModel loadData];
    [self setUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Set UI Method
- (void)setUI {
   
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *imageData = [defaults objectForKey:@"userIcon"];
    UIImage *image = [UIImage imageWithData:imageData];
    if (image == nil) {
        image = [UIImage imageNamed:@"3"];
    }
    
    self.headView = [[WUserHeadView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH / 2.0)];
    self.headView.delegate = self;
    [self.headView setUserImage:image];
    [self.headView setUserHeight:[self.userModel.height doubleValue]];
    [self.headView setUserWeight:[self.userModel.weight doubleValue]];
    [self.headView setUserBMI:[[NSString stringWithFormat:@"%.1f", [self.userModel.weight doubleValue] /
                                pow([self.userModel.height doubleValue] / 100, 2)] doubleValue]];
    [self.headView setUserTarget:[self.userModel.tag integerValue]];
    [self.view addSubview:self.headView];
    
    for (int index = 0; index < self.titles.count; index++) {
        WButton *button = [[WButton alloc] initWithFrame:CGRectZero];
        button.tag = index + 1001;
        button.image = [UIImage imageNamed:self.images[index]];
        button.descStr = self.titles[index];
        __weak typeof(self) weakSelf = self;
        button.buttonAction = ^(void) {
            [weakSelf WButtonAction:index + 1001];
        };
        
        [self.view addSubview:button];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.headView.mas_bottom).offset(kScreenH / 15 + (kScreenH / 6 * (index / 3)));
            make.left.equalTo(self.view.mas_left).offset(kScreenW / 3.0 * (index % 3));
            make.width.mas_equalTo(kScreenW / 3.0);
            make.height.mas_equalTo(kScreenW / 8);
        }];
    }
}

- (void)WButtonAction:(NSInteger)tag {
    NSLog(@"WButtonAction");
    NSInteger row = tag - 1001;
    switch (row) {
        case 0: {
            WUserEditViewController *userEdit = [[WUserEditViewController alloc] init];
            userEdit.title = @"个人资料";
            userEdit.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:userEdit animated:YES];
            break;
        }
        case 1: {
            NSString *num = [[NSString alloc] initWithFormat:@"telprompt://18321009404"]; //而这个方法则打电话前先弹框  是否打电话 然后打完电话之后回到程序中 网上说这个方法可能不合法 无法通过审核
                             [[UIApplication sharedApplication] openURL:[NSURL URLWithString:num]];
//         WHealthDataManager *man =   [[WHealthDataManager alloc] init];
//            [man getMenstrualCycleStart];
            break;
        }
        case 2: {
            WDecideViewController *decideVC = [[WDecideViewController alloc] init];
            decideVC.title = @"选择恐惧";
            decideVC.hidesBottomBarWhenPushed = YES;
            [self presentViewController:decideVC animated:YES completion:nil];
            break;
        }
//        case 3: {
//            RUNSettingViewController *setVC = [[RUNSettingViewController alloc] init];
//            setVC.title = @"设置";
//            setVC.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:setVC animated:YES];
//            break;
//        }
            
        default:
            break;
    }
}

#pragma mark - RUNUser Delegate
- (void)userHeadClick {
    UIImagePickerController * imgpickVC =[[UIImagePickerController alloc] init];
    imgpickVC.delegate =self;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选取图片" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        imgpickVC.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        imgpickVC.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        
        [self presentViewController:imgpickVC animated:YES completion:^{}];
    }];
    
    UIAlertAction *photosAction = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        imgpickVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imgpickVC animated:YES completion:^{}];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [alert addAction:cameraAction];
    }
    [alert addAction:photosAction];
    [alert addAction:cancelAction];

    [self presentViewController:alert animated:YES completion:nil];

    
}

- (void)refreshImage {
       // 刷新数据
    [self.userModel loadData];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *imageData = [defaults objectForKey:@"userIcon"];
    UIImage *image = [UIImage imageWithData:imageData];
    if (image == nil) {
        image = [UIImage imageNamed:@"3"];
    }
    [self.headView setUserImage:image];
    [self.headView setUserHeight:[self.userModel.height doubleValue]];
    [self.headView setUserWeight:[self.userModel.weight doubleValue]];
    [self.headView setUserBMI:[[NSString stringWithFormat:@"%.1f", [self.userModel.weight doubleValue] /
                                pow([self.userModel.height doubleValue] / 100, 2)] doubleValue]];
    [self.headView setUserTarget:[self.userModel.tag integerValue]];
}

- (void)reloadUserMessage {
    // 刷新数据
    [self.userModel loadData];
    [self.headView setUserName:self.userModel.name];
    [self.headView setUserHeight:[self.userModel.height doubleValue]];
    [self.headView setUserWeight:[self.userModel.weight doubleValue]];
    [self.headView setUserBMI:[[NSString stringWithFormat:@"%.1f", [self.userModel.weight doubleValue] /
                                pow([self.userModel.height doubleValue] / 100, 2)] doubleValue]];
    [self.headView setUserTarget:[self.userModel.tag integerValue]];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    [SVProgressHUD showWithStatus:@"保存中.."];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *imgData = UIImageJPEGRepresentation(image, 0.5);
    [defaults setObject:imgData forKey:@"userIcon"];
    [defaults synchronize];
    
    SEL selectorToCall = @selector(image:didFinishSavingWithError:contextInfo:);
    
    UIImageWriteToSavedPhotosAlbum(image, self, selectorToCall, NULL);
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error == nil){
        [SVProgressHUD showSuccessWithStatus:@"保存成功!"];
        [[NSNotificationCenter defaultCenter] postNotificationName:Notic_updateImage object:nil];
    
        
    } else {
        NSLog(@"An error happened while saving the image. error = %@", error);
        [SVProgressHUD showErrorWithStatus:@"保存失败!"];
    }
}





@end
