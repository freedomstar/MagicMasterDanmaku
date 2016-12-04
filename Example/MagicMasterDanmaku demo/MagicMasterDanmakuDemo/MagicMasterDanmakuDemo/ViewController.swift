//
//  ViewController.swift
//  MagicMasterDanmakuDemo
//
//  Created by 辉仔 on 2016/12/2.
//  Copyright © 2016年 辉仔. All rights reserved.
//

import UIKit
import MagicMasterDanmaku

class ViewController: UIViewController,MagicMasterDanmakudelegate
{
    @IBOutlet weak var playview: UIView!
    @IBOutlet weak var startAndStop: UIButton!
    var isplaying=true
    var magicMasterDanmaku:MagicMasterDanmaku?;
    var timer:Timer?
    var playerTime=0
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        timer=Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [unowned self](Timer) in
            self.playerTime=self.playerTime+1
        })
        magicMasterDanmaku=MagicMasterDanmaku.init(UrlString: "http://comment.bilibili.com/3733799.xml")
        magicMasterDanmaku?.delegate=self
        magicMasterDanmaku?.view.frame=CGRect.init(x: 0, y: 0, width: playview.frame.width, height: playview.frame.height)
        self.playview.addSubview((magicMasterDanmaku?.view)!);
        NotificationCenter.default.addObserver(self, selector: #selector(self.setDanmakuFinshed), name: NSNotification.Name.init(rawValue: "setDanmakuFinshed"), object: nil)
    }
    
    func setDanmakuFinshed()
    {
        magicMasterDanmaku?.fire()
    }

    func getPlayTime()->Int
    {
        return playerTime;
    }
    
    @IBAction func startAndStop(_ sender: Any)
    {
        if isplaying==false
        {
            magicMasterDanmaku?.resume()
            startAndStop.setTitle("stop", for: UIControlState.normal)
        }
        else
        {
            magicMasterDanmaku?.pause()
             startAndStop.setTitle("start", for: UIControlState.normal)
        }
        isplaying = !isplaying
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

