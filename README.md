CLProgressHUD
=============

MBProgressHUD is a colorful progress loading view for your iPhone or iPad APP.It works on any iOS version and is compatible with ARC projects. 

###ScreenShots
<span><img src="./Screenshot/1.png" width="320px" heght="480px"></span>
<span><img src="./Screenshot/2.png" width="320px" heght="480px"></span>
<span><img src="./Screenshot/3.png" width="320px" heght="480px"></span>
<span><img src="./Screenshot/4.png" width="320px" heght="480px"></span>


###Usage
####Example
```  
CLProgressHUD *hud = [CLProgressHUD shareInstance];   
hud.type = CLProgressHUDTypeDarkForground;
hud.shape = CLProgressHUDShapeCircle;
[hud showInView:self.view withText:@"Loading text..."];
[hud performSelector:@selector(dismiss) withObject:nil afterDelay:5];
```
####Method
```
- (void)showInView:(UIView *)view;
- (void)showInView:(UIView *)view withText:(NSString *)text;
- (void)showInView:(UIView *)view withText:(NSString *)text duration:(NSTimeInterval)duration;
+ (void)dismiss;
```
####You Can Set up
* CLProgressHUDType
* CLProgressHUDShape
* diameter