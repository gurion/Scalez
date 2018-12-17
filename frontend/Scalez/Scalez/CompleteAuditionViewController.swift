//
//  CompleteAuditionViewController.swift
//  Scalez
//
//  Created by Gurion on 12/10/18.
//  Copyright © 2018 OOSE. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit
import Alamofire
import SwiftyJSON

class CompleteAuditionViewController: UIViewController, AVAudioRecorderDelegate {
    
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var audioFilename: URL!
    var scoreData: String = ""
    var recording: Bool = false
    var auditionID: String = ""
    var isComplete: Bool = false
    
    @IBOutlet var auditionerUsernameLabel: UILabel!
    @IBOutlet var scaleLabel: UILabel!
    @IBOutlet var keyLabel: UILabel!
    @IBOutlet var recordButton: UIButton!
    @IBOutlet var score: UITextField!
    
    @IBAction func backButton(_ sender: Any) {
         dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.getAuditionInfo(completion: {})
        title = "Record"
        isComplete = false
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
            self.score.text = "Score: " + scoreData
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
            postAudioFile(completion: {
                self.setScoreLabel()
                if (self.isComplete) {
                    DispatchQueue.main.async {
                        self.okButtonAlert(title: "You completed this audition with a score of: \(self.scoreData)!", message: "Nicely Done!")
                    }
                }
            })
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
    
    func okButtonAlert(title : String, message : String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    func generalAlert() {
        self.okButtonAlert(title: "Something went wrong!", message: "Sorry! Please try again.")
    }
    
    func getAuditionInfo(completion : @escaping ()->()) {
        let url: String = UserDefaults.standard.string(forKey: "userUrl")!+"/audition/\(auditionID)"
        Alamofire.request(url).responseJSON { response in
            if let status = response.response?.statusCode {
                switch(status) {
                case 200:
                    let jsonResponse = JSON(response.result.value!)
                    self.auditionerUsernameLabel.text = "Auditioner:  " + jsonResponse["auditioner"].stringValue
                    self.scaleLabel.text = "Scale: " + jsonResponse["scale"].stringValue
                    self.keyLabel.text = "Key: " + jsonResponse["key"].stringValue
                default:
                    DispatchQueue.main.async {
                        self.generalAlert()
                    }
                }
            }
            completion()
        }
        
    }
    
    func postAudioFile(completion: @escaping ()->()) {
        let audioFileData = loadAudioSignal(audioURL: self.audioFilename)
        let audioFloatArray = audioFileData.signal
        let strarr = audioFloatArray.map { String($0) }
        let str = strarr.joined(separator: ",")
        
        let parameters:[String:String] = ["file": str]
        let url:String = UserDefaults.standard.string(forKey: "userUrl")!+"/audition/\(auditionID)"
        
        print(parameters)
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { response in
                print(response)
                if let status = response.response?.statusCode {
                    switch(status) {
                    case 200:
                        let json = JSON(response.result.value!)
                        self.scoreData = json["score"].stringValue
                        self.isComplete = true
                    default:
                        DispatchQueue.main.async {
                            self.generalAlert()
                        }
                    }
                }
                completion()
        }
    }
    
}
