//
//  TakeCarPhotoViewController.swift
//  JoyMove
//
//  Created by 赵霆 on 16/9/1.
//  Copyright © 2016年 ting.zhao. All rights reserved.
//

import Foundation

let itemIdentifier = "photoCollection"
let placeImage = UIImage(named: "carPlaceholder")!

class TakeCarPhotoViewController: BaseViewController {
    
    var collectionView: UICollectionView?
    var damageSwitch: UISwitch?
    let itemWH = (ScreenWidth - 70) / 4
    // 展示图片数组
    fileprivate lazy var imageArray: NSMutableArray = {
        let imageAarray: NSMutableArray = [placeImage, placeImage, placeImage, placeImage]
         return imageAarray
    }()
    // 上传图片数组
    var imageStrArray: NSMutableArray = NSMutableArray()
    // 点击标记
    var clickIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        setupUI()
    }
    
    fileprivate func setupUI() {
        
        let damageLabel = UILabel(frame: CGRect(x: 20, y: 107, width: 0, height: 0))
        damageLabel.text = "车辆是否存在损伤"
        damageLabel.textColor = ColorWithRGB(114, g: 114, b: 114, a: 1)
        damageLabel.font = UIFont.systemFont(ofSize: 16)
        damageLabel.sizeToFit()
        view.addSubview(damageLabel)
        
        let frame = CGRect(x: ScreenWidth - 74, y: 100, width: 64, height: 20)
        let damageSwitch = UISwitch(frame: frame)
        damageSwitch.onTintColor = ColorWithRGB(238, g: 99, b: 80, a: 1)
        damageSwitch.isOn = false
        view.addSubview(damageSwitch)
        self.damageSwitch = damageSwitch
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: damageSwitch.frame.maxY + 15, width: ScreenWidth, height: itemWH), collectionViewLayout: flowLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = UIColor.clear
        collectionView.register(CarPhotoCell.self, forCellWithReuseIdentifier: itemIdentifier)
        view.addSubview(collectionView)
        self.collectionView = collectionView
        
        let button = UIButton(frame: CGRect(x: 20, y: collectionView.frame.maxY + 30, width: ScreenWidth - 40, height: 40))
        button.setTitle("提交图片", for: UIControlState())
        button.backgroundColor = ColorWithRGB(238, g: 99, b: 80, a: 1)
        button.addTarget(self, action: #selector(buttonClick), for: UIControlEvents.touchUpInside)
        view.addSubview(button)
        
    }
    
    fileprivate func useCamera() {
        
        let picker: UIImagePickerController = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = UIImagePickerControllerSourceType.camera
        self.present(picker, animated: true, completion: nil)
    }
    
    func buttonClick() {
        
        print("111111")
    }
}


extension TakeCarPhotoViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 4
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: itemIdentifier, for: indexPath) as! CarPhotoCell
        let image = imageArray[(indexPath as NSIndexPath).row] as? UIImage
        cell.image = image
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        clickIndex = (indexPath as NSIndexPath).row
        if imageArray[(indexPath as NSIndexPath).row] as? UIImage == placeImage {
            
            useCamera()
        }else{
            
            let actionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: nil, otherButtonTitles: "重新拍摄", "查看大图")
            actionSheet.show(in: view)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: itemWH, height: itemWH)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        dismiss(animated: true, completion: nil)
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageArray[clickIndex] = image
        collectionView?.reloadData()
    }
    
    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int) {
        
        if buttonIndex == 1{
            
            useCamera()
        }else if buttonIndex == 2{
            
            print("高清无码无码")
        }
    }
}


