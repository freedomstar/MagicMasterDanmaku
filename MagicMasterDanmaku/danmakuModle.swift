//
//  danmakuModle.swift
//  MagicMasterDanmaku
//
//  Created by 辉仔 on 2016/11/13.
//  Copyright © 2016年 辉仔. All rights reserved.
//

import UIKit

class danmakuModle: NSObject
{
    public var time:Int?
    public var fontSize:Int?
    public var content:String?
    public var color:UIColor?

    
    init(attributes:String,content:String)
    {
        super.init()
        let array:[String] = attributes.components(separatedBy: ",")
        time=Int(Double.init(array[0])!)
        let colorInt:Int64=Int64.init(array[3])!
        color=getColor(color: colorInt)
        self.content=content
    }
    
    func getColor(color:Int64) -> UIColor
    {
        let r:Float = Float(color % 256)/255.0
        let g:Float = Float((color/256) % 256)/255.0
        let b:Float = Float((color/256/256) % 256)/255.0
        return UIColor.init(red:CGFloat(r), green: CGFloat(g), blue: CGFloat(b) , alpha: 1)
    }
   
}
