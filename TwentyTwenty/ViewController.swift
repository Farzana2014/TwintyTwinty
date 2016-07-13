//
//  ViewController.swift
//  TwentyTwenty
//
//  Created by Farzana on 7/10/16.
//  Copyright (c) 2016 Farzana. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var elapsedTimeLabel: UILabel!
    let stopwatch = Stopwatch()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        UIApplication.sharedApplication().cancelAllLocalNotifications()
        
        let notificationSettings =  UIUserNotificationSettings(
            forTypes: [.Alert, .Badge, .Sound],
            categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func setNotification(sender: UISwitch) {
        
        if (sender.on) {
            print("Alarm On!")
            timerAction()
        } else {
            print("Alarm Off!")
            UIApplication.sharedApplication().cancelAllLocalNotifications()
        }
    }
    
    @IBAction func count20sec(sender: UISwitch) {
        
        if (sender.on) {
            NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: #selector(updateElapsedTimeLabel), userInfo: nil, repeats: true)
            stopwatch.start()
        } else {
            elapsedTimeLabel.text = "00.0"
            stopwatch.stop()
        }
    }
    
    func timerAction() {
        
        UIApplication.sharedApplication().cancelAllLocalNotifications()
        let settings = UIApplication.sharedApplication().currentUserNotificationSettings()
        
        if settings!.types == .None {
            let ac = UIAlertController(title: "Can't schedule", message: "Either we don't have permission to schedule notifications, or we haven't asked yet.", preferredStyle: .Alert)
            ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            presentViewController(ac, animated: true, completion: nil)
            return
        }
        
    
        for i in 1..<4 {
            let notification = UILocalNotification()
            notification.alertBody = "It's time to look 20m far from you for 20s !!"
            notification.soundName = UILocalNotificationDefaultSoundName
            notification.fireDate = NSDate.init(timeIntervalSinceNow: Double(i * 2 * 60))
            notification.timeZone = NSTimeZone.systemTimeZone()
            notification.repeatInterval = NSCalendarUnit.Hour
            notification.soundName = "alarm.wav"
            
            UIApplication.sharedApplication().applicationIconBadgeNumber = 0
            UIApplication.sharedApplication().scheduleLocalNotification(notification)
        }
    }
    
    func updateElapsedTimeLabel(timer: NSTimer) {
        
        if stopwatch.elapsedTime >= 20.0
        {
            print("time up")
            stopwatch.stop()
        }
        if stopwatch.isRunning {
            elapsedTimeLabel.text = stopwatch.elapsedTimeAsString
        } else {
            timer.invalidate()
        }
    }
}

