//
//  PopupViewController.swift
//  MechKeyboard
//
//  Created by Julius Cebreros on 7/4/15.
//  Copyright (c) 2015 Julius Cebreros. All rights reserved.
//

import Cocoa

class PopupViewController: NSViewController {
    var volume: Float = 0.0;
    var callback: Selector = nil;
    @IBOutlet var volumeSlider: NSSlider!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        NSLog("Loaded to here");
//        volumeSlider.setValue(volume * 100);
        volumeSlider.intValue = (Int32)(volume * 100);
    }

    
    func setControllerVolume(v:Float){
        volume = v;
    }
    
}

extension PopupViewController {
    @IBAction func adjustVolume(sender: NSSlider) {
        self.volume = (Float)(sender.integerValue) / 100;
        NSNotificationCenter.defaultCenter().postNotificationName("AdjustVolume", object:self);
    }
    
    @IBAction func quit(sender: NSButton) {
        NSApplication.sharedApplication().terminate(sender)
    }
}
