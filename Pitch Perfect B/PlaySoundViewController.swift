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
    
        // новый код
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func commonAudioFunction(audioChangeNumber: Float, typeOfChange: String){
        
        audioPlayerNode = AVAudioPlayerNode()
        audioPlayerNode.stop()
        audioEngine.stop()
        audioEngine.reset()
        
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
        println("*** заяц ***")
        commonAudioFunction(1.6, typeOfChange: "rate")
    }
    @IBAction func snailSpeed(sender: UIButton) {
        println("*** улитка ***")
        commonAudioFunction(0.6, typeOfChange: "rate")
    }
    @IBAction func chipmunkEffect(sender: UIButton) {
        println("*** бурундук ***")
        commonAudioFunction(1100, typeOfChange: "pitch")
    }
    @IBAction func darthVaderEffect(sender: UIButton) {
        println("*** Дарт Вейдер ***")
        commonAudioFunction(-750, typeOfChange: "pitch")
    }

    @IBAction func stopPlayBack(sender: UIButton) {
        audioPlayerNode.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
