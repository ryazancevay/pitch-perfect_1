//
//  RecordAudioViewController.swift
//  Pitch Perfect
//
//  Created by Admin on 11.05.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

import UIKit
import AVFoundation

class RecordAudioViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var statusRecordLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    
    var audioRecorder:AVAudioRecorder!
    var recordedAudio: RecordedAudio!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        stopButton.hidden = true
        statusRecordLabel.text = "Tap to record"
    }
    
    @IBAction func recordAudio(sender: UIButton) {
        statusRecordLabel.text = "recording..."
        stopButton.hidden = false
        recordButton.enabled = false
        
        // create file path
        let dirPath:NSArray = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let currentDataTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDataTime)+".wav"
        let pathArray = [dirPath.lastObject as! String, recordingName as String]
        NSLog("%@",pathArray)
        let filePath = NSURL.fileURLWithPathComponents(pathArray as [AnyObject])
        println(filePath)
        
        // init and start record
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if (flag){
            recordedAudio = RecordedAudio(newTitle: recorder.url.lastPathComponent, newFilePathUrl: recorder.url)
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }
        else{
            println("Recording not successfuly")
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording"){
            let playSoundVC: PlaySoundViewController = segue.destinationViewController as! PlaySoundViewController
            let data = sender as! RecordedAudio
            playSoundVC.receiveAudio = data
        }
    }
    
    @IBAction func stopRecord(sender: UIButton) {
        statusRecordLabel.text = "Tap to record"
        stopButton.hidden = true
        recordButton.enabled = true
    
        // stop record
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    }
    

}
