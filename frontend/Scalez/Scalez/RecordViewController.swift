//
//  RecordViewController.swift
//  Scalez
//
//  Created by Gurion on 10/15/18.
//  Copyright © 2018 OOSE. All rights reserved.

import Foundation
import AVFoundation
import UIKit

class RecordViewController: UIViewController, AVAudioRecorderDelegate {
    
    var recordButton: UIButton!
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    
    @IBOutlet weak var testLabel: UILabel!
    
    @IBAction func recordOnTap(_ sender: Any) {
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default, options: [])
            try recordingSession.setActive(true)
            self.recordingSession.requestRecordPermission() { [unowned self] allowed  in
                DispatchQueue.main.async {
                    if allowed {
                        self.loadRecordingUI()
                    } else {
                        //failed to record
                    }
                }
            }
            
        } catch {
            print("catching error")
        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func loadRecordingUI() {
        self.recordButton = UIButton(frame: CGRect(x: 64, y: 64, width: 128, height: 64))
        self.recordButton.setTitle("Tap to Record", for: .normal)
        self.recordButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.title1)
        self.recordButton.addTarget(self, action: #selector(recordTapped), for: .touchUpInside)
        view.addSubview(self.recordButton)
    }
    
    func startRecording() {
        let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.m4a")
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            self.audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            self.audioRecorder.delegate = self
            self.audioRecorder.record()
            
            recordButton.setTitle("Tap to Stop", for: .normal)
        } catch {
            finishRecording(success: false)
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

    func finishRecording(success: Bool) {
        audioRecorder.stop()
        audioRecorder = nil
        
        if success {
            recordButton.setTitle("Tap to Re-record", for: .normal)
        } else {
            recordButton.setTitle("Tap to Record", for: .normal)
            // recording failed :(
        }
    }

    @objc func recordTapped() {
        if audioRecorder == nil {
            startRecording()
        } else {
            finishRecording(success: true)
        }
    }

    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: false)
        }
    }
    
    //posting something to a server
    //this code came from https://github.com/Kilo-Loco
    @IBAction func postOnTap(_ sender: Any) {
        let parameters = ["username": "@kilo_loco", "tweet": "HelloWorld"]
        
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }
        request.httpBody = httpBody
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response)
            }
            
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)
                } catch {
                    print(error)
                }
            }
            
            }.resume()
        
    }
    
}


