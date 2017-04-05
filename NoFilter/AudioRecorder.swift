//
//  AudioRecorder.swift
//  NoFilter
//
//  Created by harpreet singh on 2017-04-02.
//  Copyright © 2017 mapd.centennial.proapptive. All rights reserved.
//

import UIKit
import AVFoundation
import FirebaseStorage//import
class AudioRecorder: UIViewController,AVAudioPlayerDelegate, AVAudioRecorderDelegate {
    
    
   public var pid:String!
    var soundFileURL:Any!
    @IBOutlet weak var showTime: UILabel!
    
    var counter = 10
    var audioPlayer: AVAudioPlayer!                  // declares
    
    var audioRecorder: AVAudioRecorder!               // recorder & audioplayer
    @IBOutlet weak var recordBtn: UIButton!
    @IBOutlet weak var recordDoneBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        //shadow for numbers
        
        
       print("PID IS THIS.........>>>>>>>\(pid)")
        showTime.layer.shadowOffset = CGSize(width: 0, height: 0)
        showTime.layer.shadowOpacity = 3
        showTime.layer.shadowRadius = 6
        
        //shadow end
        
        var t = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
        
        
        recordDoneBtn.isEnabled=false
        recordDoneBtn.isHidden=true
        // recoder default settings
        let fileMgr = FileManager.default
        let dirPaths = fileMgr.urls(for: .documentDirectory,
                                    in: .userDomainMask)
        soundFileURL = dirPaths[0].appendingPathComponent("sound.caf")
        
        let recordSettings =
            [AVEncoderAudioQualityKey: AVAudioQuality.min.rawValue,
             AVEncoderBitRateKey: 16,
             AVNumberOfChannelsKey: 2,
             AVSampleRateKey: 44100.0] as [String : Any]
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setCategory(
                AVAudioSessionCategoryPlayAndRecord)
        } catch let error as NSError {
            print("audioSession error: \(error.localizedDescription)")
        }
        
        do {
            try audioRecorder = AVAudioRecorder(url: soundFileURL as! URL,
                                                settings: recordSettings as [String : AnyObject])
            audioRecorder?.prepareToRecord()
        } catch let error as NSError {
            print("audioSession error: \(error.localizedDescription)")
        }
        
        
    }
    
    // timer functionality
    
    
    @IBAction func recordBtnAction(_ sender: UIButton) {
        recordBtn.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 9, options: .allowUserInteraction, animations:
            {
                self.recordBtn.transform=CGAffineTransform.identity
        }, completion: nil)
        recordBtn.isHidden=true
        
        recordBtn.isEnabled=false
        
        if audioRecorder?.isRecording == false {
            
            recordDoneBtn.isEnabled=true
            recordDoneBtn.isHidden=false
            audioRecorder?.record()
        }
        
        
        
        
        
        
        
    }
    
    
    @IBAction func recordDoneBtnAction(_ sender: UIButton) {
        recordBtn.isEnabled=true
        recordBtn.isHidden=false
        recordDoneBtn.isEnabled=false
        recordDoneBtn.isHidden=true
       // dismiss(animated: true, completion: nil)
        
        
        
        
        if audioRecorder?.isRecording == true {
            audioRecorder?.stop()
        } else {
            audioPlayer?.stop()
        }
        /// uploading audio
        let fileName = UUID().uuidString + ".m4a"
        
        FIRStorage.storage().reference().child("aucomments").child(fileName).putFile(soundFileURL as! URL, metadata: nil) { (metadata, error) in
            if error != nil {
                print(error ?? "error")
            }
            
            if let downloadUrl = metadata?.downloadURL()?.absoluteString {
                print(downloadUrl)
                let values: [String : Any] = ["audioUrl": downloadUrl]
               // self.sendMessageWith(properties: values)
            }
        }
        
         /// uploading audio end
    }
    
    @IBAction func playAction(_ sender: UIButton) {
        
        if audioRecorder?.isRecording == false {
            recordDoneBtn.isEnabled = true
            recordBtn.isEnabled = false
            
            do {
                try audioPlayer = AVAudioPlayer(contentsOf:
                    (audioRecorder?.url)!)
                audioPlayer!.delegate = self
                audioPlayer!.prepareToPlay()
                audioPlayer!.play()
            } catch let error as NSError {
                print("audioPlayer error: \(error.localizedDescription)")
            }
        }
        
    }
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        recordBtn.isEnabled = true
        recordDoneBtn.isEnabled = false
        recordDoneBtn.isHidden=true
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        print("Audio Play Decode Error")
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        print("Audio Record Encode Error")
    }
    
    func updateCounter() {
        //you code, this is an example
        if counter > 0 {
            showTime.text=String(counter)
            counter -= 1
        }
        else if(counter==0 )
        {
            dismiss(animated: true, completion: nil)
            
        }
    }
    
}

