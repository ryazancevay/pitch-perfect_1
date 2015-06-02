//
//  PlaySoundViewController.swift
//  Pitch Perfect
//
//  Created by Admin on 19.05.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundViewController: UIViewController {

    var audioPlayer: AVAudioPlayer!
    var receiveAudio: RecordedAudio!
    
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        println(receiveAudio.filePathUrl)
        
        // set file path for audioPlayer
        audioPlayer = AVAudioPlayer(contentsOfURL: receiveAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true
        
        // set file path for audioEngine
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receiveAudio.filePathUrl, error: nil)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    func stopAudio(){
        // stop all audio
        audioEngine.stop()
        audioPlayer.stop()
    }
    
    func playAudio(rate: Float){
        // play by audio player
        audioPlayer.rate = rate
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
    }
    
    @IBAction func playSlowButton(sender: UIButton) {
        stopAudio()
        playAudio(0.5)
    }

    @IBAction func playFastButton(sender: UIButton) {
        stopAudio()
        playAudio(1.5)
    }

    @IBAction func stopButton(sender: UIButton) {
        stopAudio()
    }
    
    @IBAction func playChipmunkButton(sender: UIButton) {
        playAudioWithVariablePitch(1000)
    }
    
    @IBAction func playDarthvaderAudio(sender: UIButton) {
        playAudioWithVariablePitch(-1000)
    }
    
    func playAudioWithVariablePitch(pitch: Float){
        stopAudio()
        audioEngine.reset()
        
        // init nodes and attach
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        // set pitch
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        // connect nodes
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }
    
}
