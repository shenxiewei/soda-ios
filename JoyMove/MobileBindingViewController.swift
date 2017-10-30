//
//  MobileBindingViewController.swift
//  JoyMove
//
//  Created by 赵霆 on 16/10/9.
//  Copyright © 2016年 ting.zhao. All rights reserved.
//

import Foundation

class MobileBindingViewController: BaseViewController {
    
    var mobileNo: UITextField?
    var verificationText: UITextField?
    var verificationBtn: TimeButton?
    var bindingBtn: UIButton?
    var sessionId: String = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        verificationBtn?.stop(NSLocalizedString("验证码", comment: ""))
    }
    
    fileprivate func setupUI() {
        
        title = NSLocalizedString("绑定手机号", comment: "")
        setNavBackButtonStyle(BaseViewTag.BVTagBack)
        
        mobileNo = UITextField(frame: CGRect(x: 20, y: 40, width: ScreenWidth - 110, height: 44))
        mobileNo?.borderStyle = UITextBorderStyle.roundedRect
        mobileNo?.placeholder = NSLocalizedString("请输入手机号", comment: "")
        mobileNo?.keyboardType = UIKeyboardType.numberPad
        mobileNo?.returnKeyType = UIReturnKeyType.done
        mobileNo?.delegate = self
        mobileNo?.addTarget(self, action: #selector(textFieldDidChange), for: UIControlEvents.allEditingEvents)
        baseView.addSubview(mobileNo!)
        
        verificationBtn = TimeButton(type: UIButtonType.roundedRect)
        verificationBtn?.frame = CGRect(x: (mobileNo?.frame.maxX)! + 10, y: 40, width: 60, height: 44)
        verificationBtn?.timeButtonDelegate = self
        verificationBtn?.layer.cornerRadius = 4
        verificationBtn?.layer.masksToBounds = true
        verificationBtn?.buttonUsableStatus = true
        verificationBtn?.setTitle(NSLocalizedString("验证码", comment: ""), for: UIControlState.normal)
        verificationBtn?.titleLabel?.adjustsFontSizeToFitWidth = true
        verificationBtn?.addTarget(self, action: #selector(getVerification), for: UIControlEvents.touchUpInside)
        setButton(button: verificationBtn!, with: 0)
        baseView.addSubview(verificationBtn!)
        
        verificationText = UITextField(frame:CGRect(x: 20, y: (mobileNo?.frame.maxY)! + 20, width: ScreenWidth - 40, height: 44))
        verificationText?.borderStyle = UITextBorderStyle.roundedRect
        verificationText?.placeholder = NSLocalizedString("请输验证码", comment: "")
        verificationText?.keyboardType = UIKeyboardType.numberPad
        verificationText?.returnKeyType = UIReturnKeyType.done
        verificationText?.delegate = self
        verificationText?.addTarget(self, action: #selector(textFieldDidChange), for: UIControlEvents.allEditingEvents)
        baseView.addSubview(verificationText!)
        
        bindingBtn = UIButton(type: UIButtonType.roundedRect)
        bindingBtn?.frame = CGRect(x: 20, y: (verificationText?.frame.maxY)! + 35, width: ScreenWidth - 40, height: 44)
        bindingBtn?.layer.cornerRadius = 4
        bindingBtn?.layer.masksToBounds = true
        bindingBtn?.setTitle(NSLocalizedString("绑定", comment: ""), for: UIControlState.normal)
        bindingBtn?.addTarget(self, action: #selector(binding), for: UIControlEvents.touchUpInside)
        setButton(button: bindingBtn!, with: 0)
        baseView.addSubview(bindingBtn!)
    }
    
    fileprivate func setButton(button: UIButton, with type: Int){
        
        if type == 0 {
            
            button.setTitleColor(UIColor.white, for: UIControlState.normal)
            button.backgroundColor = ColorWithRGB(210, g: 210, b: 210, a: 1)
            button.isEnabled = false
        }else{
            
            button.setTitleColor(UIColor.white, for: UIControlState.normal)
            button.backgroundColor = ColorWithRGB(236, g: 105, b: 65, a: 1)
            button.isEnabled = true
        }
    }
    
    func getVerification() {
        //获取验证码
        TZNetworkTool.shareNetworkTool.getVerificationCode(mobileNo: (mobileNo?.text)!) { (isSuccess) in
            if isSuccess {
                self.verificationBtn?.setTime(60)
            }
        }
    }
    
    func binding() {
        //deviceId:SDCUUID.getUUID()
        let uuid =  SDCUUID.getUUID();
        // 绑定
        TZNetworkTool.shareNetworkTool.mobileNoBindindToWeChat(mobile: (mobileNo?.text)!,sessionId: sessionId ,deviceId:uuid!, seccode: (verificationText?.text)!) { (isSuccess,code) in
            if isSuccess {
                
                if code == 100014
                {
                    self.callService()
                }else
                {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
        
    }
    
    fileprivate func callService()
    {
//    NSString *message = @"您的帐号已与其他设备绑定，如有疑问请拨打客服电话：\n400-0627-927";
//    UIAlertController *alertController = [UIAlertController showAlertInViewController:self withTitle:@"联系客服" message:message cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil
//    tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
//    NSMutableString *str = [[NSMutableString alloc] initWithFormat:@"telprompt://%@", serviceTelephone];
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
//    }];
//    
//    NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:message];
//    NSRange redRange = NSMakeRange([[noteStr string] rangeOfString:@"400-0627-927"].location, [[noteStr string] rangeOfString:@"400-0627-927"].length);
//    [noteStr addAttribute:NSForegroundColorAttributeName value:UIColorFromSixteenRGB(0x0096ed) range:redRange];
//    [noteStr addAttribute:NSFontAttributeName value:UIBoldFontFromSize(16) range:redRange];
//    
//    [alertController setValue:noteStr forKey:@"attributedMessage"];
    }
    
    func textFieldDidChange() {
        
        if mobileNo?.text?.characters.count == 11 && verificationBtn?.buttonUsableStatus == true {
            
            setButton(button: verificationBtn!, with: 1)
        }else{
            setButton(button: verificationBtn!, with: 0)
        }
        
        if mobileNo?.text?.characters.count == 11 && verificationText?.text?.characters.count != 0 {
            
            setButton(button: bindingBtn!, with: 1)
        }else{
            setButton(button: bindingBtn!, with: 0)
        }
    }
}

extension MobileBindingViewController: UITextFieldDelegate,TimeButtonDelegate {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        mobileNo?.resignFirstResponder()
        verificationText?.resignFirstResponder()
    }
    
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == mobileNo {
            if range.location == 11 {
                return false
            }
        }
        return true
    }
    
    func updateTimeButtonStatus() {
        
       textFieldDidChange()
    }
    
}
