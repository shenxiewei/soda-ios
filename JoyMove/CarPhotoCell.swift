//
//  CarPhotoCell.swift
//  JoyMove
//
//  Created by 赵霆 on 16/9/2.
//  Copyright © 2016年 ting.zhao. All rights reserved.
//

import Foundation

class CarPhotoCell: UICollectionViewCell {
    // 懒加载
    fileprivate lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "carPlaceholder")
        imageView.contentMode = UIViewContentMode.scaleAspectFill
        return imageView
    }()
    
    var image: UIImage? {
        didSet{
            
            imageView.image = image
        }
    }
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(imageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        
        imageView.frame = bounds
    }
    
    
}
