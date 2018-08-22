//
//  ResonanceViewController.swift
//  ResonanceIosSdkExample
//
//  Created by Vitaly Seroshtanov on 21.08.2018.
//  Copyright © 2018 Vitaly Seroshtanov. All rights reserved.
//

import UIKit
import AVFoundation
import Resonance
class ResonanceViewController: UIViewController {

    @IBOutlet weak var payloadTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var textView: UITextView!
    
    var isSearching = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textView.text = "Log:"
    }


    @IBAction func searchButtonPressed(_ sender: Any) {
        self.view.endEditing(true)
        self.searchButton.isEnabled = false
        if isSearching == true {
            self.stop()
        }else{
            self.tryToStartSearch()
        }
    }
    
    
    
    func tryToStartSearch() {
        let permissionStatus = AVAudioSession.sharedInstance().recordPermission()
        if permissionStatus == .granted {
            self.startResonsnceSearch()
        } else {
            AVAudioSession.sharedInstance().requestRecordPermission { (granted) in
                if granted == true {
                    DispatchQueue.main.async {
                        self.startResonsnceSearch()
                    }
                } else {
                    self.log(message: "user denied microphone access")
                }
            }
        }
    }
    
    func startResonsnceSearch() {
        if let payload = self.payloadTextField.text {
            RSNResonance.startSearching(withPayload: payload, onSearchStartedBlock: {
                let logMessage = "Search started. My payload: \(payload)"
                self.log(message: logMessage)
                self.didStartSearch()
            }, onClientFound: { (client) in
                let logMessage = "Found: \(client.payload)"
                self.log(message: logMessage)
            }, onClientLost: { (client) in
                let logMessage = "Lost: \(client.payload)"
                self.log(message: logMessage)
            }, onSearchStoppedBlock: { (error) in
                if error != nil {
                    let logMessage = "Search stopped. Error: \(error!.localizedDescription)"
                    self.log(message: logMessage)
                } else {
                    let logMessage = "Search stopped."
                    self.log(message: logMessage)
                }
                self.didStopSearch()
            })
        }
    }
    
    func stop()  {
        RSNResonance.stopSearch()
        self.didStopSearch()
    }
    
    func didStopSearch()  {
        isSearching = false
        self.searchButton.setTitle("START SEARCH", for: .normal)
        self.searchButton.isEnabled = true
    }
    
    func didStartSearch() {
        isSearching = true
        self.searchButton.setTitle("STOP SEARCH", for: .normal)
        self.searchButton.isEnabled = true
    }
    
    
    func log(message: String) {
        self.textView.text =  self.textView.text + "\n" + message
    }
    
    
}
