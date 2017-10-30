//
//  ActivityViewController.swift
//  JoyMove
//
//  Created by 赵霆 on 16/8/15.
//  Copyright © 2016年 xin.liu. All rights reserved.
//

import Foundation

class ActivityViewController: BaseViewController {
    
    //数据
    var items = [ActivityModel]()
    var tableView: UITableView!
    var webView: WebViewController!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        navigationItem.title = NSLocalizedString("Recent Events", comment: "")
        setNavBackButtonStyle(BaseViewTag.BVTagBack)
        buildTableView()
        
        // 获取首页数据
        weak var weakSelf = self
        TZNetworkTool.shareNetworkTool.loadActivityData { (activityItems) in
            
            weakSelf!.items = activityItems
            weakSelf!.tableView!.reloadData()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    fileprivate func buildTableView() {
        
        let frame: CGRect = CGRect(x: 0, y: 64, width: ScreenWidth, height: ScreenHeight - 64)
        tableView = UITableView.init(frame: frame, style: UITableViewStyle.plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.clear
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        view.addSubview(tableView)
        
    }
}

extension ActivityViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return items.count
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        //cell内图片高度
        let cellImgH = 550 * 0.5 / 320 * ScreenWidth / 3.5
        
        return cellImgH + 35;
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = ActivityCell.activityCell(tableView, indexPath: indexPath)
        cell.activityItem = items[(indexPath as NSIndexPath).row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        webView = WebViewController.init()
        webView.view.frame = ScreenBounds
        webView.setHideAgreeButton(true)
        webView.isActivityPush(true)
        webView.title = items[(indexPath as NSIndexPath).row].promotionName
        webView.getImageURL(items[(indexPath as NSIndexPath).row].promotionTitle)
        webView.loadUrl(items[(indexPath as NSIndexPath).row].promotionContent)
        navigationController?.pushViewController(webView, animated: true)
    }
}
