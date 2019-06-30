//
//  PlaySoundsViewController.swift
//  pitch-perfect
//
//  Created by Jerry Hanks on 30/06/2019.
//  Copyright © 2019 Mint Financial Services. All rights reserved.
//

import UIKit
import AVFoundation


class PlaySoundsViewController: UIViewController {
    @IBOutlet weak var slowBtn: UIButton!
    @IBOutlet weak var fastBtn: UIButton!
    @IBOutlet weak var hightPitchBtn: UIButton!
    @IBOutlet weak var lowPitchBtn: UIButton!
    @IBOutlet weak var echoBtn: UIButton!
    @IBOutlet weak var reverbBtn: UIButton!
    @IBOutlet weak var playBackControlBtn: UIButton!
    
    var recordedAudioURL:URL!
    var audioFile:AVAudioFile!
    var audioEngine:AVAudioEngine!
    var audioPlayerNode:AVAudioPlayerNode!
    var stopTimer:Timer!
    
    
    enum FilterTypes : Int{
        case slow = 0, fast,highPtich,lowPitch,echo,reverb
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Pitch Perfect"
        self.navigationItem.backBarButtonItem = nil
        self.navigationItem.hidesBackButton = true
        
        //set up audio
        setupAudio()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureUI(.notPlaying)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //make navbar seamles with the view background
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    @IBAction func onTapFilterBtn(_ sender: UIButton) {
        let filterType = FilterTypes(rawValue: sender.tag)!
        
        switch filterType {
        case .slow:
            playSound(rate: 0.5)
        case .fast:
             playSound(rate: 1.5)
        case .highPtich:
            playSound(pitch:1000)
        case .lowPitch:
            playSound(pitch:-1000)
        case .echo:
            playSound(echo:true)
        case .reverb:
            playSound(reverb:true)
        }
        
        
        //update the UI
        configureUI(.playing)
    }
    
    @IBAction func onTapPlayBackControlBtn(_ sender: UIButton) {
        stopAudio()
    }
    
    
    @IBAction func onTapRecordNewsoundBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
