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
    @IBOutlet var countSwitch: UISwitch!
    
    let stopwatch = Stopwatch()
    let testSound = Sound(name: "alarm", type: "caf")
    var flag = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //UIApplication.sharedApplication().cancelAllLocalNotifications()
    
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
        
        print("notification switch status \(notificationSwicth.on)")
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.delegate = self
        
        if (sender.on) {
            
            if (UIApplication.sharedApplication().currentUserNotificationSettings()!.hashValue == 0) {
                //UIApplication.sharedApplication().cancelAllLocalNotifications()
                let notificationSettings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
                UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)
                
            } else {
                timerAction()
            }
            
            print("Alarm On!")

        } else {
            print("Alarm Off!")
            UIApplication.sharedApplication().cancelAllLocalNotifications()
        }
        
        
    }
    
    func timerAction() {
        
        NSUserDefaults.standardUserDefaults().setObject(notificationSwicth.on, forKey: "switchStatus")
        NSUserDefaults.standardUserDefaults().synchronize()

        UIApplication.sharedApplication().cancelAllLocalNotifications()
        
//        var notification = UILocalNotification()
//        notification = setUpNotification(notification)
//        notification.fireDate = NSDate.init(timeIntervalSinceNow: Double(5))
//        notification = publishLocalNotification(notification)
        
        
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
        
        if stopwatch.elapsedTime >= 20.1 {
            testSound.play()
            countSwitch.on = false
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
            NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector:(#selector(ViewController.updateElapsedTimeLabel(_:))), userInfo: nil, repeats: true)
            stopwatch.start()
        } else {
            elapsedTimeLabel.text = "00.0"
            stopwatch.stop()
            testSound.stop()
        }
    }
}


extension ViewController: AllowNotificationDelegate {
    
    func notificationAllowed(isAllowed: Bool) {
        if (isAllowed) {
            notificationSwicth.on = true
            timerAction()
        } else {
            notificationSwicth.on = false
            
            if (UIApplication.sharedApplication().currentUserNotificationSettings()!.hashValue == 0 && notificationSwicth.on == false && flag == 1) {
                let settings = UIApplication.sharedApplication().currentUserNotificationSettings()
                if settings!.types == .None {
                    let ac = UIAlertController(title: "Can't On Notification", message: "Please go to settings and Set Permission", preferredStyle: .Alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: okAction))
                    presentViewController(ac, animated: true, completion: nil)
                    return
                }
            }
            
            flag = 1
        }
    }
   
    
    func okAction(alert: UIAlertAction!) {
        dispatch_async(dispatch_get_main_queue()) {
           UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
        }
    }
    
}
