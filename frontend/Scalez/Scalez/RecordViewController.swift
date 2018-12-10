//
//  RecordViewController.swift
//  Scalez
//
//  Created by Gurion on 10/15/18.
//  Copyright © 2018 OOSE. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

class RecordViewController: UIViewController, AVAudioRecorderDelegate {
    
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var audioFilename: URL!
    var scoreData: String = ""
    var recording: Bool = false
    
    @IBOutlet var recordButton: UIButton!
    @IBOutlet var score: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Record"
        recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default, options: [])
            try recordingSession.setActive(true)
            
        } catch {
            print("catching error")
        }
    }
    
    @IBAction func recordAudio(_ sender: Any) {
        if (audioRecorder != nil) {
            stopRecording(success: true)
            setRecordButtonImage()
        } else {
            startRecording()
            setRecordButtonImage()
        }
    }
    
    func setScoreLabel() {
        if (self.scoreData != "") {
            self.score.text = scoreData
        } else {
            self.score.text = "_____"
        }
    }
    
    func setRecordButtonImage() {
        if self.recording {
            self.recordButton.setImage(UIImage(named: "stop_button"), for: .normal)
        } else {
            self.recordButton.setImage(UIImage(named: "play_button"), for: .normal)
        }
    }
    
    
    func startRecording() {
        self.recording = true
        self.scoreData = ""
        setScoreLabel()
        self.audioFilename = getDocumentsDirectory().appendingPathComponent("recording.m4a")
        print(audioFilename)
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
        } catch {
            stopRecording(success: false)
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

    func stopRecording(success: Bool) {
        self.recording = false
        audioRecorder.stop()
        audioRecorder = nil
        
        if success {
            setRecordButtonImage()
            postAudioFile()
            sleep(2)
            setScoreLabel()
        } else {
            setRecordButtonImage()
            // recording failed :(
        }
        
        //print(loadAudioSignal(audioURL: self.audioFilename))
    }

    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            stopRecording(success: false)
        }
    }
    
    func loadAudioSignal(audioURL: URL) -> (signal: [Float], rate: Double, frameCount: Int) {
        let file = try! AVAudioFile(forReading: audioURL)
        let format = AVAudioFormat(commonFormat: .pcmFormatFloat32, sampleRate: file.fileFormat.sampleRate, channels: file.fileFormat.channelCount, interleaved: false)
        let buf = AVAudioPCMBuffer(pcmFormat: format!, frameCapacity: UInt32(file.length))
        try! file.read(into: buf!) // You probably want better error handling
        let floatArray = Array(UnsafeBufferPointer(start: buf!.floatChannelData![0], count:Int(buf!.frameLength)))
        return (signal: floatArray, rate: file.fileFormat.sampleRate, frameCount: Int(file.length))
    }
    
    //posting something to a server
    //this code came from https://github.com/Kilo-Loco
    func postAudioFile() {
        let audioFileData = loadAudioSignal(audioURL: self.audioFilename)
        let audioFloatArray = audioFileData.signal
        let sampleRate = String(audioFileData.rate)
        let frameCount = String(audioFileData.frameCount)
        let strarr = audioFloatArray.map { String($0) }
        let str = strarr.joined(separator: ",")
        let username = UserDefaults.standard.string(forKey: "username")
        
        let parameters = ["username": username, "file": str, "rate": sampleRate, "frameCount": frameCount]
        
        guard let url = URL(string: UserDefaults.standard.string(forKey: "userUrl")!+"/recording") else { return }
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
                    //let json = try JSONSerialization.jsonObject(with: data, options: [])
                    //try print(String(data: data, encoding: .utf8)!)
                    //self.score.text = String(data: data, encoding: .utf8)!
                    self.scoreData = String(data: data, encoding: .utf8)!
                } catch {
                    print("This is the error being printed error")
                }
            }
        }.resume()
    }

}
