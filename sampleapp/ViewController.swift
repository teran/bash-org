//
//  ViewController.swift
//  sampleapp
//
//  Created by Igor Shishkin on 26/03/16.
//  Copyright © 2016 Igor Shishkin. All rights reserved.
//

import UIKit

import Just
import Kanna

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        // Operations on load
        refreshData()

        // textView settings
        mainTextView.textContainer.lineBreakMode = NSLineBreakMode.ByCharWrapping
        mainTextView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);

        // Gesture handlers
        let tapGesture = UITapGestureRecognizer(target: self, action: "handleTap:")
        self.view.addGestureRecognizer(tapGesture)
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: "handleSwipe:")
        self.view.addGestureRecognizer(swipeGesture)
    }

    func refreshData() {
        let request = Just.get("http://bash.im/random")
        if request.ok {
            let text = String(data:request.content!, encoding: NSWindowsCP1251StringEncoding)
            let doc = Kanna.HTML(html: text!, encoding: NSWindowsCP1251StringEncoding)
            var quote = doc!.css("div .text")[0].innerHTML
            quote = quote?.stringByReplacingOccurrencesOfString("<br>", withString: "\n")
            quote = quote?.stringByReplacingOccurrencesOfString("&lt;", withString: "<")
            quote = quote?.stringByReplacingOccurrencesOfString("&gt;", withString: ">")
            mainTextView.text = quote
        } else {
            NSLog("Error performing HTTP request: code \(request.statusCode)")
        }
    }
    
    func handleTap(tapGesture: UIGestureRecognizer) {
        refreshData()
    }

    func handleSwipe(swipeGesture: UIGestureRecognizer) {
        let vc = UIActivityViewController(activityItems: [mainTextView.text], applicationActivities: nil)
        self.presentViewController(vc, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var mainTextView: UITextView!
}

