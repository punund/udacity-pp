//
//  PlaySoundViewController.swift
//  Pitch Perfect B
//
//  Created by Ilja Ketris on 29/7/2015.
//  Copyright (c) 2015 Ilja Ketris. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundViewController: UIViewController {
    
    var receivedAudio: RecordedAudio!
    var auTimePitch: AVAudioUnitTimePitch!
    var audioEngine: AVAudioEngine!
    var audioFile: AVAudioFile!
    var audioPlayerNode: AVAudioPlayerNode!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
    }

    func initializePlayer() {
        audioPlayerNode = AVAudioPlayerNode()
        audioPlayerNode.stop()
        audioEngine.stop()
        audioEngine.reset()
    }

    func commonAudioFunction(audioChangeNumber: Float, typeOfChange: String) {
        initializePlayer()
        audioEngine.attachNode(audioPlayerNode)
        
        var changeAudioUnitTime = AVAudioUnitTimePitch()
        
        switch (typeOfChange) {
        case "rate":
            changeAudioUnitTime.rate = audioChangeNumber
        case "pitch":
            changeAudioUnitTime.pitch = audioChangeNumber
        default:
            println("Wrong use of function")
            NSException(name: "argument", reason: "Must be pitch or rate", userInfo: nil).raise()
        }
        audioEngine.attachNode(changeAudioUnitTime)
        audioEngine.connect(audioPlayerNode, to: changeAudioUnitTime, format: nil)
        audioEngine.connect(changeAudioUnitTime, to: audioEngine.outputNode, format: nil)
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }
    
    @IBAction func hareSpeed(sender: UIButton) {
        commonAudioFunction(1.6, typeOfChange: "rate")
    }
    @IBAction func snailSpeed(sender: UIButton) {
        commonAudioFunction(0.6, typeOfChange: "rate")
    }
    @IBAction func chipmunkEffect(sender: UIButton) {
        commonAudioFunction(1100, typeOfChange: "pitch")
    }
    @IBAction func darthVaderEffect(sender: UIButton) {
        commonAudioFunction(-750, typeOfChange: "pitch")
    }
    @IBAction func stopPlayBack(sender: UIButton) {
        initializePlayer()
    }

}
