//
//  RecordSoundViewController.swift
//  Pitch Perfect B
//
//  Created by Iļja Ketris on 28/7/2015.
//  Copyright (c) 2015 Ilja Ketris. All rights reserved.
//
import UIKit
import AVFoundation

class RecordSoundViewController: UIViewController, AVAudioRecorderDelegate {
    
    var audioRecorder:AVAudioRecorder!
    var recordedAudio = RecordedAudio()
    
    @IBOutlet weak var mikeButton: UIButton!
    @IBOutlet weak var progressNotice: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordingError: UILabel!
    
    func recordingInProgress(recording: Bool) {
        progressNotice.text = "recording, push to stop"
        stopButton.hidden = !recording
        mikeButton.enabled = !recording
        mikeButton.hidden = recording
        stopButton.enabled = recording
        progressNotice.text = recording ? "recording, push to stop" : "push to record"
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        recordingInProgress(false)
    }

    @IBAction func recordSound(sender: UIButton) {
        println("Идёт запись")
        recordingError.hidden = true
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        // let's make it unique
        let uuid = NSUUID().UUIDString
        let recordingName = "sample.\(uuid).wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()

        recordingInProgress(true)
        audioRecorder.recordForDuration(15)

    }
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if (flag) {
            println("Запись успешна")
            recordedAudio = RecordedAudio(title: recorder.url.lastPathComponent, path: recorder.url)
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        } else {
            println("Ошибка при записи")
            recordingError.hidden = false
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording") {
            let playSoundsVC = segue.destinationViewController as! PlaySoundViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }

    @IBAction func stopRecording(sender: UIButton) {
        recordingInProgress(false)
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)

    }
}

