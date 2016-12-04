//
//  parseXML.swift
//  MagicMasterDanmaku
//
//  Created by 辉仔 on 2016/11/13.
//  Copyright © 2016年 辉仔. All rights reserved.
//

import UIKit


class parseXML: NSObject,XMLParserDelegate
{
    var parser:XMLParser?
    var count:Int = 0
    var danmakuList:[danmakuModle]?
    var isdanmaku:Bool=false
    
    
    init(Url:URL)
    {
        super.init()
        danmakuList=[]
        parser=XMLParser.init(contentsOf:Url)
        parser?.delegate = self
        NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "setDanmakuStart"), object: nil)
        parser?.parse()
    }
    
    
    init(UrlString:String)
    {
        super.init()
        danmakuList=[]
        parser=XMLParser.init(contentsOf:URL.init(string: UrlString)!)
        parser?.delegate = self
        NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "setDanmakuStart"), object: nil)
        parser?.parse()
    }

    public func parserXML() ->[danmakuModle]
    {
        danmakuList?.sort(by: { (danmaku1, danmaku2) -> Bool in
           return  danmaku1.time!<danmaku2.time!
        })
        return danmakuList!
    }
    
    var attributeString:String?
    public func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:])
    {
        if let p = attributeDict["p"]
        {
            attributeString = p
            isdanmaku=true
        }
        else
        {
            isdanmaku=false
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String)
    {
        let str:String! = string.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        if isdanmaku==true && str != ""
        {
            let modle:danmakuModle=danmakuModle.init(attributes: attributeString!, content: str)
            danmakuList?.append(modle)
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser)
    {
        var result:String?
        if parser.parserError != nil
        {
            result="succeed"
        }
        else
        {
            result="fail"
        }
        NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "ParserXMLFinshed"), object: nil,userInfo:["result":result!,])
    }


}
