//
//  ViewController.swift
//  sampleapp
//
//  Created by Igor Shishkin on 26/03/16.
//  Copyright © 2016 Igor Shishkin. All rights reserved.
//

import UIKit

class ViewController: UIViewController, NSXMLParserDelegate {
    var strXMLData:String = ""
    var currentElement:String = ""
    var passData:Bool=false
    var passName:Bool=false
    var parser = NSXMLParser()
    
    // var refreshControl = UIKit.UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        NSLog("Initialized")
        refreshData()
        mainTextView.textContainer.lineBreakMode = NSLineBreakMode.ByCharWrapping
        // refreshControl.attributedTitle = NSAttributedString(string:"refreshing...")
        // refreshControl.addTarget(self, action: "refreshData", forControlEvents: UIControlEvents.ValueChanged)
    }

    func refreshData() {
        let url:String="http://bash.im/rss/"
        NSLog("Setting up NSURL object")
        let urlToSend: NSURL = NSURL(string: url)!
        // Parse the XML
        NSLog("Setting up NSXMLParser object")
        parser = NSXMLParser(contentsOfURL: urlToSend)!
        NSLog("Parser delegation")
        parser.delegate = self
        let success:Bool = parser.parse()
        
        if(success) {
            NSLog(strXMLData)
        } else {
            NSLog("Error parsing XML data")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        currentElement=elementName;
        if(elementName=="description")
        {
            if(elementName=="name"){
                passName=true;
            }
            passData=true;
        }
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        currentElement="";
        if(elementName=="description")
        {
            if(elementName=="name"){
                passName=false;
            }
            passData=false;
        }
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        if(passName){
            strXMLData=strXMLData+"\n\n"+string
        }
        
        if(passData) {
            mainTextView.text = String(string.stringByReplacingOccurrencesOfString("<br>", withString: "\n", options: NSStringCompareOptions.LiteralSearch, range: nil))
        }
    }
    
    func parser(parser: NSXMLParser, parseErrorOccurred parseError: NSError) {
        NSLog("failure error: %@", parseError)
    }
    
    @IBOutlet weak var mainTextView: UITextView!

    @IBAction func buttonPressed(sender: UIButton) {
        refreshData()
    }
}

