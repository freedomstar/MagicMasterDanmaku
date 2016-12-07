//
//  danmakuModel.swift
//  MagicMasterDanmaku
//
//  Created by 辉仔 on 2016/12/6.
//  Copyright © 2016年 辉仔. All rights reserved.
//

import UIKit

public enum danmakuModle
{
    case normal
    case bottom
    case top
    case countercurrent
}

class danmakuModel: NSObject
{
    public var time:Int?
    public var fontSize:Int?
    public var content:String?
    public var color:UIColor?
    public var modle:danmakuModle?
    
    
    init(attributes:String,content:String)
    {
        super.init()
        let array:[String] = attributes.components(separatedBy: ",")
        time=Int(Double.init(array[0])!)
        
        let modleString:String=array[2]
        switch modleString
        {
        case "4":
            modle=danmakuModle.bottom
            break
        case "5":
            modle=danmakuModle.top
            break
        case "6":
            modle=danmakuModle.countercurrent
            break
        default:
            modle=danmakuModle.normal
            break
        }
        
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
