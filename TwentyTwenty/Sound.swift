//
//  Sound.swift
//  TwentyTwenty
//
//  Created by Farzana on 7/31/16.
//  Copyright © 2016 Farzana. All rights reserved.
//

import AVFoundation

class Sound {
    
    var audioPlayer = AVAudioPlayer()
    
    init(name: String, type: String) {
        let coinSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(name, ofType: type)!)
        do {
            audioPlayer = try AVAudioPlayer(contentsOfURL: coinSound)
            audioPlayer.prepareToPlay()
        } catch let error as NSError {
            print(error.description)
        }
    }
    
    func play() {
        audioPlayer.play()
    }
    
    func stop() {
        audioPlayer.stop()
    }
}
