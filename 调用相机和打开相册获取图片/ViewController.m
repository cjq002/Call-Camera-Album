//
//  ViewController.m
//  调用相机和打开相册获取图片
//
//  Created by  on 15/9/21.
//  Copyright (c) 2015年 ck_chan. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    
    UIImageView *_imageView;
    UIImageView *_imageViewR;
    
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //在ViewController.m创建并初始化UIImageView用于显示获取的图片。
    _imageViewR = [[UIImageView alloc]initWithFrame:CGRectMake((self.view.frame.size.width-100)/2, 30, 100,100)];
    _imageViewR.backgroundColor = [UIColor grayColor];
    _imageViewR.layer.cornerRadius = 50;
    _imageViewR.layer.masksToBounds = YES;
    [self.view addSubview:_imageViewR];
    
    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(16, 140, self.view.frame.size.width-32,self.view.frame.size.width-32)];
    _imageView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:_imageView];
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(16, CGRectGetMaxY(_imageView.frame)+20, self.view.frame.size.width-32, 35);
    btn.backgroundColor = [UIColor orangeColor];
    btn.layer.cornerRadius = 5;
    btn.layer.masksToBounds = YES;
    [btn setTitle:@"去获取图片" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

#pragma mark - 按钮响应事件 弹出图片来源选择提示框
- (void)btnClick:(UIButton *)sender{
    
    //iOS8之后 使用UIAlertController 代替UIAlertView和UIActionSheet
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"获取图片"  message:nil  preferredStyle:UIAlertControllerStyleActionSheet];
    
    // 判断是否支持相机。注：模拟器没有相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            // 相机
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
            imagePickerController.delegate = self;
            imagePickerController.allowsEditing = YES;
            imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:imagePickerController animated:YES completion:^{}];
            
        }];
        
        [alertController addAction:defaultAction];
    }
    
    UIAlertAction *defaultAction1 = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        // 相册
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePickerController animated:YES completion:^{}];
        
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    
    
    [alertController addAction:cancelAction];
    [alertController addAction:defaultAction1];
    
    //弹出视图 使用UIViewController的方法
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - 选择完成后调用该方法。
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    // 保存图片至本地，上传图片到服务器需要使用
    [self saveImage:image withName:@"avatar.png"];
    
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"avatar.png"];
    
    UIImage *savedImage = [[UIImage alloc] initWithContentsOfFile:fullPath];
    
    //设置图片显示
    [_imageView setImage:savedImage];
    [_imageViewR setImage:savedImage];
}

#pragma mark - 按取消按钮用该方法。
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 保存图片至沙盒
- (void)saveImage:(UIImage *)currentImage withName:(NSString *)imageName
{
    
    NSData *imageData = UIImageJPEGRepresentation(currentImage, 1);//1为不缩放保存，取值（0.0-1.0）
    // 获取沙盒目录
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    // 将图片写入文件
    [imageData writeToFile:fullPath atomically:NO];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
