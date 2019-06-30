//
//  RecordSoundViewController.swift
//  pitch-perfect
//
//  Created by Jerry Hanks on 30/06/2019.
//  Copyright © 2019 Mint Financial Services. All rights reserved.
//

import UIKit
import AVFoundation


class RecordSoundViewController: UIViewController,AVAudioRecorderDelegate {
    @IBOutlet weak var controlBtn: UIButton!
    @IBOutlet weak var infoLabel: UILabel!
    
    var audioRecorder:AVAudioRecorder!
    
    
//    override var prefersStatusBarHidden: Bool{
//        get{return true}
//    }
    
    enum ControlType:Int {
        case record = 0,stopRecording
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //make fullscreens
//        navigationController?.isNavigationBarHidden = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //make navbar seamles with the view background
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }

    @IBAction func onTapControlBtn(_ sender: UIButton) {
        let controlType = ControlType(rawValue: sender.tag)!
        toggleControlButton(previousType: controlType)
        
        switch (controlType) {
        case .record:
            print("Recording!")
            break
        case .stopRecording:
            print("Stop Recording")
            break
        }
    }
    
    func toggleControlButton(previousType:ControlType){
        switch previousType {
        case .record:
            controlBtn.setImage(UIImage(named: "Stop"), for: .normal)
            controlBtn.tag = 1
            infoLabel.text = "Tap to finish recording"
            
            startRecording()
            break
        case .stopRecording:
            controlBtn.setImage(UIImage(named: "Record"), for: .normal)
            controlBtn.tag = 0
            infoLabel.text = "Tap to start recording"
            
            finishRecording()
            break
        }
    }
    
    private func startRecording(){
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
        
        print("Recording audio at : \(filePath!)")
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
    }
    
    private func finishRecording(){
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPlayback"{
            let playbackVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playbackVC.recordedAudioURL = recordedAudioURL
            
        }
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag{
            performSegue(withIdentifier: "toPlayback", sender: audioRecorder.url)
        }else{
            print("Recording was not successful")
        }
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        print("Recording erro: \(String(describing: error))")
        finishRecording()
    }
    
}

