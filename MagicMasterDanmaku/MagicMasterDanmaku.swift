//
//  MagicMasterDanmaku.swift
//  MagicMasterDanmaku
//
//  Created by 辉仔 on 2016/11/13.
//  Copyright © 2016年 辉仔. All rights reserved.
//

import UIKit

public protocol MagicMasterDanmakudelegate
{
    func getPlayTime()->Int
}

public class MagicMasterDanmaku: UIViewController,CAAnimationDelegate
{
    public var isFire:Bool
        {
        get
        {
            return _isFire
        }
    }
    public var danmakuSpeed:TimeInterval?=5
    public var danmakuPoolMaxSize:Int?=50
    public var delegate : MagicMasterDanmakudelegate?
    public var maxDanmakuCount:Int?=30
    var _isFire:Bool=false
    var ispause:Bool=false
    var parseXmlManager:parseXML?
    var danmakuPool:[UILabel]=[]
    var firedanmakulist:[UILabel]=[]
    var useCount:Int?=0
    var danmakuList:[danmakuModle]?
    var timer:Timer?
    var lasttime:Int? = -1
    var playTime:Int?=0
    var lastdanmakuTrackCount:Int? = -1
    var lastindex:Int? = 0
    var lastViewWidth:CGFloat? = 0
    var danmakuTrackCount:Int? = 0
    let queue = DispatchQueue(label: "MagicMasterDanmakuQueue")
    var randomTrackArray:[Int]?
    
    
    
    override public func viewDidDisappear(_ animated: Bool)
    {
//        timer?.invalidate()
//        timer=nil
    }
    
    override public func viewWillAppear(_ animated: Bool)
    {
       
    }
    
    required public init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
   public  init(Url:URL)
    {
        super.init(nibName: nil, bundle: nil)
        danmakuList = []
        randomTrackArray=[]
        queue.async
            {
                [weak self]  in
                self?.parseXmlManager=parseXML.init(Url: Url)
                self?.danmakuList = self?.parseXmlManager?.parserXML()
        }
    }
    
    
   public  init(UrlString:String)
    {
        super.init(nibName: nil, bundle: nil)
        danmakuList = []
        randomTrackArray=[]
        queue.async
            {
                [weak self]  in
                self?.parseXmlManager=parseXML.init(UrlString: UrlString)
                self?.danmakuList = self?.parseXmlManager?.parserXML()
        }
    }
    
    override public func viewDidLoad()
    {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.setUp(notification:)), name: NSNotification.Name.init(rawValue: "ParserXMLFinshed"), object: nil)
        timer=Timer.init(timeInterval: 1, target: self, selector: #selector(self.updateDanmaku),userInfo: nil,repeats: true)
        RunLoop.main.add(timer!, forMode: RunLoopMode.defaultRunLoopMode)
        danmakuTrackCount = Int(self.view.frame.height/21+2)
    }
    
    
    func setUp(notification:Notification)
    {
        self.view.clipsToBounds = true;
        self.view.isUserInteractionEnabled=false
        let result:String = notification.userInfo?["result"] as! String
        if result=="succeed"
        {
            for _ in 0...29
            {
                let lable=UILabel.init()
                danmakuPool.append(lable)
            }
        }
        NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "setDanmakuFinshed"), object: nil,userInfo:["result":result,])
    }
    
    func updateDanmaku()
    {
        if ispause==false && _isFire == true
        {
            playTime=self.delegate?.getPlayTime()
            if lastdanmakuTrackCount! == (randomTrackArray?.count)! && playTime!%3==0
            {
                randomTrackArray?.removeAll()
                for i in 0...danmakuTrackCount!-3
                {
                    randomTrackArray?.append(i)
                }
            }
            if playTime != lasttime! && (danmakuList?.count)!>0
            {
                if((playTime!-lasttime!) != 1)
                {
                    lastindex=0
                }
                for i in lastindex!...(danmakuList?.count)!-1
                {
                    if firedanmakulist.count<maxDanmakuCount!
                    {
                        let model:danmakuModle = danmakuList![i]
                        if(playTime == model.time)
                        {
                            setUpDanmaku(model: model)
                        }
                        else if(model.time!>playTime!)
                        {
                            lastindex=i
                            break
                        }
                    }
                    else
                    {
                        break
                    }
                }
            }
            if (danmakuList?.count)! > 0
            {
                self.lasttime=playTime
                lastdanmakuTrackCount = (randomTrackArray?.count)!
            }
        }
    }
    
    func setUpDanmaku(model:danmakuModle)
    {
        if lastViewWidth != self.view.frame.width
        {
            danmakuTrackCount = Int(self.view.frame.height/21+2)
            randomTrackArray?.removeAll()
            lastViewWidth = self.view.frame.width
        }
        let Danmaku:UILabel = getPoolDanmaku()
        Danmaku.textColor=model.color
        Danmaku.shadowColor=UIColor.black
        firedanmakulist.append(Danmaku)
        Danmaku.frame=CGRect.init(x: -1000, y: -1000, width: 0, height: 0)
        Danmaku.text=model.content
        Danmaku.layer.borderWidth=0
        Danmaku.layer.borderColor=UIColor.clear.cgColor
        Danmaku.sizeToFit()
        fireDanmaku(Danmaku: Danmaku)
    }
    
    public  func insetDanmaku(message:String)
    {
        if _isFire==true
        {
            if danmakuPool.count < danmakuPoolMaxSize!+1
            {
                let lable=UILabel.init()
                danmakuPool.append(lable)
            }
            let Danmaku:UILabel = getPoolDanmaku()
            Danmaku.textColor=UIColor.white
            Danmaku.shadowColor=UIColor.black
            firedanmakulist.append(Danmaku)
            Danmaku.frame=CGRect.init(x: -1000, y: -1000, width: 0, height: 0)
            Danmaku.layer.borderWidth=1
            Danmaku.layer.borderColor=UIColor.yellow.cgColor
            Danmaku.text=message
            Danmaku.sizeToFit()
            fireDanmaku(Danmaku: Danmaku)
        }
    }

    
    func getPoolDanmaku() -> UILabel
    {
        if danmakuPool.count < danmakuPoolMaxSize!+1
        {
            let lable=UILabel.init()
            danmakuPool.append(lable)
        }
        let Danmaku:UILabel = danmakuPool.removeFirst()
        return Danmaku
    }
    
    func fireDanmaku(Danmaku:UILabel)
    {
        let height = Int(Danmaku.frame.height)*randomMan()
        self.view.addSubview(Danmaku)
        let anim:CABasicAnimation=CABasicAnimation.init(keyPath: "position")
        anim.fromValue=NSValue.init(cgPoint: CGPoint.init(x: UIScreen.main.bounds.width+(Danmaku.frame.width/2), y: CGFloat(height)+(Danmaku.frame.height/2)))
        anim.toValue=NSValue.init(cgPoint: CGPoint.init(x: -Danmaku.frame.size.width-5, y: CGFloat(height)+(Danmaku.frame.height/2)))
        anim.duration = danmakuSpeed!;
        anim.fillMode=kCAFillModeForwards;
        anim.delegate=self
        Danmaku.layer.add(anim, forKey: "position")
    }
    

    func randomMan() -> Int! {
        if (randomTrackArray?.count)! > 0
        {
            return randomTrackArray?.removeFirst()
        }
        else
        {
            for i in 0...danmakuTrackCount!-3
            {
                randomTrackArray?.append(i)
            }
            return randomTrackArray?.removeFirst()
        }
    }

    public func changeViewFrame(frame:CGRect)
    {
        self.view.frame=frame
    }
    
    
    
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool)
    {
        let lable = firedanmakulist.removeFirst()
        lable.layer.removeAllAnimations()
        lable.text=""
        lable.layoutIfNeeded()
        lable.removeFromSuperview()
        danmakuPool.append(lable)
    }
    
    public func fire()
    {
        if _isFire == false
        {
            timer?.fire()
            _isFire=true
        }
    }
    
    public func pause()
    {
        ispause = true
        if firedanmakulist.count>0
        {
            for i in 0...firedanmakulist.count-1
            {
                let lable = firedanmakulist[i]
                let pausedTime:CFTimeInterval = lable.layer.convertTime(CACurrentMediaTime(), from: nil)
                lable.layer.speed = 0.0;
                lable.layer.timeOffset = pausedTime;
            }
        }
    }
    
    public func resume()
    {
        ispause = false
        if firedanmakulist.count>0
        {
            for i in 0...firedanmakulist.count-1
            {
                let lable = firedanmakulist[i]
                let pauseTime:CFTimeInterval = lable.layer.timeOffset
                let begin:CFTimeInterval=CACurrentMediaTime()-pauseTime
                lable.layer.beginTime=begin
                lable.layer.timeOffset = 0;
                lable.layer.speed = 1;
            }
        }
    }
    
    public func shutdown()
    {
        self.timer?.invalidate()
        timer=nil
    }
    

    override public func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
