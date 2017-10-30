//
//  ActivityCell.swift
//  JoyMove
//
//  Created by 赵霆 on 16/8/17.
//  Copyright © 2016年 xin.liu. All rights reserved.
//

import Foundation
import Kingfisher

class ActivityCell: UITableViewCell {
    
    fileprivate var activityImg: UIImageView?
    fileprivate var timeLine: UIView?
    fileprivate var circleImg: UIImageView?
    
    var activityItem: ActivityModel? {
        didSet{
            let url = activityItem!.promotionTitle
             activityImg?.kf.setImage(with: URL(string: url!))
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = UITableViewCellSelectionStyle.none
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        activityImg = UIImageView()
        activityImg?.backgroundColor = UIColor.clear
        contentView.addSubview(activityImg!)
        
        timeLine = UIView()
        timeLine?.backgroundColor = ColorWithRGB(225, g: 225, b: 225, a: 1)
        contentView.addSubview(timeLine!)
        
        circleImg = UIImageView()
        circleImg?.image = UIImage(named: "activityCircle")
        circleImg?.backgroundColor = UIColor.clear
        contentView.addSubview(circleImg!)
        
    }
    
    override func layoutSubviews() {
        
        let activityImgW: CGFloat = 550 * 0.5 / 320 * ScreenWidth;
        let activityImgX = 59 * 0.5 / 320 * ScreenWidth
        activityImg?.frame = CGRect(x: activityImgX, y: 23, width: activityImgW, height: activityImgW / 3.5)
        
        let timeLineX = 29 * 0.5 / 320 * ScreenWidth
        timeLine?.frame = CGRect(x: timeLineX, y: 0, width: 0.5, height: self.height)
        
        let circleX = 17 * 0.5 / 320 * ScreenWidth
        let circleWH = 24 * 0.5 / 568 * ScreenHeight
        circleImg?.frame = CGRect(x: circleX, y: 23, width: circleWH, height: circleWH)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static fileprivate let identifier = "ActivityCell"
    class func activityCell(_ tableView: UITableView, indexPath: IndexPath) ->ActivityCell{
        
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? ActivityCell
        
        if cell == nil {
            cell = ActivityCell(style: .default, reuseIdentifier: identifier)
        }
                
        return cell!
    }
    
}
