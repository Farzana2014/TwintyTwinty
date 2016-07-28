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
    @IBOutlet var notificationSwicth: UISwitch!
    
    let stopwatch = Stopwatch()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        guard let status = NSUserDefaults.standardUserDefaults().objectForKey("switchStatus") as? Bool else {
            notificationSwicth.on = false
            return
        }
        
        notificationSwicth.on = status
        setNotification(notificationSwicth)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func setNotification(sender: UISwitch) {
        print(sender.on)
        NSUserDefaults.standardUserDefaults().setObject(sender.on, forKey: "switchStatus")
        NSUserDefaults.standardUserDefaults().synchronize()
        
        if (sender.on) {
            print("Alarm On!")
            timerAction()
        } else {
            print("Alarm Off!")
            UIApplication.sharedApplication().cancelAllLocalNotifications()
        }
    }
    
    
    func timerAction() {
        
        UIApplication.sharedApplication().cancelAllLocalNotifications()
        let settings = UIApplication.sharedApplication().currentUserNotificationSettings()
        
        if settings!.types == .None {
            notificationSwicth.on = false
            let ac = UIAlertController(title: "Can't schedule", message: "Either we don't have permission to schedule notifications in Settings, or we haven't asked yet.", preferredStyle: .Alert)
            ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            presentViewController(ac, animated: true, completion: nil)
            return
        }
        
        var notification = UILocalNotification()
        notification = setUpNotification(notification)
        notification.fireDate = NSDate.init(timeIntervalSinceNow: Double(5))
        notification = publishLocalNotification(notification)
        
        for i in 1..<4 {
            var notificationR = UILocalNotification()
            notificationR = setUpNotification(notificationR)
            notificationR.fireDate = NSDate.init(timeIntervalSinceNow: Double(i * 20 * 60))
            notificationR = publishLocalNotification(notificationR)
        }
    }
    
    
    func setUpNotification(notification: UILocalNotification) -> UILocalNotification {
        notification.alertBody = "It's time to look 20m far from you for 20s !!"
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.timeZone = NSTimeZone.systemTimeZone()
        notification.repeatInterval = NSCalendarUnit.Hour
        notification.soundName = "alarm.caf"
        return notification
    }
    
    
    func publishLocalNotification(notification: UILocalNotification) -> UILocalNotification {
        UIApplication.sharedApplication().applicationIconBadgeNumber = 0
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
        return notification
    }
    
    
    func updateElapsedTimeLabel(timer: NSTimer) {
        
        if stopwatch.elapsedTime >= 20.0 {
            stopwatch.stop()
        }
        
        if stopwatch.isRunning {
            elapsedTimeLabel.text = stopwatch.elapsedTimeAsString
        } else {
            timer.invalidate()
        }
    }
    
    @IBAction func count20sec(sender: UISwitch) {
        
        if (sender.on) {
            NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector:("updateElapsedTimeLabel:"), userInfo: nil, repeats: true)
            stopwatch.start()
        } else {
            elapsedTimeLabel.text = "00.0"
            stopwatch.stop()
        }
    }
}

