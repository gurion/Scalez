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
import Alamofire
import SwiftyJSON

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension CGRect{
    init(_ x:CGFloat,_ y:CGFloat,_ width:CGFloat,_ height:CGFloat) {
        self.init(x:x,y:y,width:width,height:height)
    }
    
}

class RecordViewController: UIViewController, AVAudioRecorderDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var audioFilename: URL!
    var scoreData: Double = -1
    var recording: Bool = false
    var possibleScales: [String] = [String]()
    var waveformView:SCSiriWaveformView!
    
    @IBOutlet var keySelector: UISegmentedControl!
    @IBOutlet var scaleSelector: UIPickerView!
    @IBOutlet var recordButton: UIButton!
    @IBOutlet var score: UITextField!
    
    @objc func updateMeters() {
        if let audioRecorder = audioRecorder {
            audioRecorder.updateMeters()
            let normalizedValue:CGFloat = pow(10, CGFloat(audioRecorder.averagePower(forChannel: 0))/20)
            waveformView.update(withLevel: normalizedValue)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Record"
        
        self.scaleSelector.delegate = self
        self.scaleSelector.dataSource = self
        self.possibleScales = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"]
        
        recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default, options: [])
            try recordingSession.setActive(true)
            
        } catch {
            print("catching error")
        }

        let bounds = UIScreen.main.bounds
        
        waveformView = SCSiriWaveformView(frame: CGRect(0, 90, bounds.width, bounds.height/4))
        waveformView.waveColor = UIColor.red
        waveformView.primaryWaveLineWidth = 3.0
        waveformView.secondaryWaveLineWidth = 1.0
        waveformView.backgroundColor = UIColor.white
        self.view.addSubview(waveformView)
        self.view.sendSubviewToBack(waveformView)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return possibleScales.count;
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return possibleScales[row] as String
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // This method is triggered whenever the user makes a change to the picker selection.
        // The parameter named row and component represents what was selected.
    }
    
    func convertIntToKey() -> String {
        let value = self.keySelector.selectedSegmentIndex
        if (value == 0) {
            return "major"
        } else {
            return "minor"
        }
    }
    
    func getSelectedScale() -> String {
        return possibleScales[scaleSelector.selectedRow(inComponent: 0)] as String
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
        if (self.scoreData != -1) {
            self.score.text = String(scoreData)
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
            self.audioRecorder.isMeteringEnabled = true
            self.audioRecorder.record()
            
            let displayLink = CADisplayLink(target: self, selector: #selector(updateMeters))
            displayLink.add(to: RunLoop.current, forMode: RunLoop.Mode.common)

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
            })
            //sleep(2)
            //setScoreLabel()
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
    
    func okButtonAlert(title : String, message : String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    func generalAlert() {
        self.okButtonAlert(title: "Something went wrong!", message: "Sorry! Please try again.")
    }
    
    func loadAudioSignal(audioURL: URL) -> (signal: [Float], rate: Double, frameCount: Int) {
        let file = try! AVAudioFile(forReading: audioURL)
        let format = AVAudioFormat(commonFormat: .pcmFormatFloat32, sampleRate: file.fileFormat.sampleRate, channels: file.fileFormat.channelCount, interleaved: false)
        let buf = AVAudioPCMBuffer(pcmFormat: format!, frameCapacity: UInt32(file.length))
        try! file.read(into: buf!) // You probably want better error handling
        let floatArray = Array(UnsafeBufferPointer(start: buf!.floatChannelData![0], count:Int(buf!.frameLength)))
        return (signal: floatArray, rate: file.fileFormat.sampleRate, frameCount: Int(file.length))
    }
    
    
    func postAudioFile(completion: @escaping ()->()) {
        let audioFileData = loadAudioSignal(audioURL: self.audioFilename)
        let audioFloatArray = audioFileData.signal
        let strarr = audioFloatArray.map { String($0) }
        let str = strarr.joined(separator: ",")
        
        let parameters:[String:String] = ["file": str, "key" : convertIntToKey(), "scale" : getSelectedScale()]
        let url:String = UserDefaults.standard.string(forKey: "userUrl")! + "/recording"
                
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { response in
                print(response)
                if let status = response.response?.statusCode {
                    switch(status) {
                    case 201:
                        let json = JSON(response.result.value!)
                        self.scoreData = json["score"].doubleValue
                    case 400:
                        DispatchQueue.main.async {
                            self.generalAlert()
                        }
                    default:
                        DispatchQueue.main.async {
                            self.generalAlert()
                        }
                    }
                }
                completion()
        }
    }
    //posting something to a server
    //this code came from https://github.com/Kilo-Loco
    /*func postAudioFile() {
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
    }*/

}
