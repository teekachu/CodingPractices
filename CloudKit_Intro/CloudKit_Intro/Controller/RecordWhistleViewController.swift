//
//  RecordWhistleViewController.swift
//  CloudKit_Intro
//
//  Created by Tee Becker on 11/24/20.
/// Working with Audiovisual assets
/// Before recording begin, we will use Apple's AAC format as it gets the most quality for the lowest  bitrate.
import UIKit
import AVFoundation
/// Two classes are needed for recording Audio: AVAudioSession and AVAudioRecorder.
/// AVAudioSession is to enable and track sound recording as a whole, and ensure we are able to record
/// AVAudioRecorder is to do the recording

/// APP UI Breakdown
/// When Tap to record is pressed,  blue screen turns red, with label updated to Tap to stop
/// When Tap to stop is pressed, stack view show Tap to Re-record and play button). Next button in right corner.
/// If Re-record,  change screen back to red, play button dissapear


class RecordWhistleViewController: UIViewController {
    
    //MARK: Properties
    private let stackView : UIStackView = {
        let sv = UIStackView()
        return sv
    }()
    
    private var recordButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    private var recordingSession: AVAudioSession!
    
    private var whistleRecorder: AVAudioRecorder!
    
    private var whistlePlayer: AVAudioPlayer!
    
    private let playbutton: UIButton = {
        let butn = UIButton()
        butn.setTitle("Tap to Play", for: .normal)
        butn.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title1)
        butn.isHidden = true
        butn.alpha = 0
        return butn
    }()
    
    
    
    //MARK: Lifecycle
    override func loadView() {
        configureUI()
        configureStackview()
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureAVAudioSession()
        
    }
    
    
    //MARK: Selectors
    @objc func recordTapped(){
        //        print("Debug: recording ... ")
        if whistleRecorder == nil{
            startRecording()

            /// If play button is not hidden, hide
            if !playbutton.isHidden{
                UIView.animate(withDuration: 0.35) {[unowned self] in
                    self.playbutton.isHidden = true
                    self.playbutton.alpha = 0
                }
            }
            
        } else {
            finishRecording(success: true)
        }
    }
    
    
    @objc func nextTapped(){
//        print("Debug: next tapped")
        let vc = SelectGenreViewConroller()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @objc func playTapped(){
        print("Debug: playing recordings now... ")
        let audioURL = RecordWhistleViewController.getWhistleURL()
        
        do{
            whistlePlayer = try AVAudioPlayer(contentsOf: audioURL)
            whistlePlayer.play()
        }catch{
            showMessage(withTitle: "Playback failed", message: "There was a problem playing your Whistle, Please try to re-record. ")
        }
    }
    
    
    //MARK: Helpers
    /// We need to tell iOS where to save the recording when we create the AVAudioRecorder object.
    /// We will save it in the documentDirectory of user's home directory
    class func getDocumentsDirectory() -> URL{
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    
    class func getWhistleURL() -> URL{
        return getDocumentsDirectory().appendingPathComponent("Whistle.m4a")
    }
    
    
    //MARK: Privates
    private func configureUI(){
        
        view = UIView()
        view.backgroundColor = Constants.darkBlueColor
        
        title = "Record your whistle!"
        navigationController?.navigationBar.prefersLargeTitles = true
        let image = UIImage(systemName: "recordingtape")
        navigationItem.backBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: nil, action: nil)
    }
    
    
    private func configureButton(){
        stackView.addArrangedSubview(playbutton)
        playbutton.addTarget(self, action: #selector(playTapped), for: .touchUpInside)
    }
    
    
    func configureStackview(){
        stackView.spacing = 30
        stackView.distribution = UIStackView.Distribution.fillEqually
        stackView.alignment = .center
        stackView.axis = .vertical
        view.addSubview(stackView)
        
        stackView.centerY(inView: view)
        stackView.centerX(inView: view)
    }
    
    
    private func configureAVAudioSession(){
        recordingSession = AVAudioSession.sharedInstance()
        
        do{
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
            
            /// Need to request for user permission to record.
            recordingSession.requestRecordPermission {[unowned self] (allowed) in
                DispatchQueue.main.async {
                    if allowed{
                        self.loadRecordingUI()
                    } else {
                        self.loadFailedUI()
                    }
                }
            }
        }catch{
            self.loadFailedUI()
        }
    }
    
    
    private func loadRecordingUI(){
        //        print("Debug: Access approved, load recording UI")
        recordButton.setTitle("Tap to Record", for: .normal)
        recordButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title1)
        recordButton.addTarget(self, action: #selector(recordTapped), for: .touchUpInside)
        stackView.addArrangedSubview(recordButton)
        
        configureButton()
    }
    
    
    private func loadFailedUI(){
        //        print("Debug: Access denied, load failed UI")
        let failedLabel = UILabel()
        failedLabel.text = "Recording failed. \nPlease ensure the app has\n access to your microphone."
        failedLabel.textAlignment = .center
        failedLabel.textColor = Constants.mintBlueColor
        failedLabel.numberOfLines = 3
        stackView.addArrangedSubview(failedLabel)
    }
    
    
    private func startRecording(){
        /// Make the view red, so users know they are in recording mode.
        view.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        
        /// Change title of record button.
        recordButton.setTitle("Tap to Stop", for: .normal)
        
        /// Find out where to save the whistle.
        let audioURL = RecordWhistleViewController.getWhistleURL()
        print("Debug: \(audioURL.absoluteURL)")
        
        /// Create settings directory to describe the format, sample rate, channels  and quality.
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        /// Create AVAudioRecorder object pointing at our Whistle audioURL. Set ourselves as the delegate and call it's record method
        do{
            whistleRecorder = try AVAudioRecorder(url: audioURL, settings: settings)
            whistleRecorder.delegate = self
            whistleRecorder.record()
        }catch{
            /// if an error occurs, finish recording as false.
            finishRecording(success: false)
        }
    }
    
    
    /// This function will act depending on whether recording was success or failture.
    /// If success, set recordButton's title to be "Tap to Re-record", but show new right bar button item to progress into next step for submission.
    /// If failure, put the button's title back to "Tap to Record", and show error message.
    private func finishRecording(success: Bool){
        
        ///MARK: TO CHANGE LATER*
        view.backgroundColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        
        whistleRecorder.stop()
        whistleRecorder = nil
        
        if success{
            recordButton.setTitle("Tap to Re-record", for: .normal)
            let image = UIImage(systemName: "arrowshape.turn.up.right")
            
            /// If sucessfully recorded , show playbutton ONLY if playbutton is already hidden
            if playbutton.isHidden{
                UIView.animate(withDuration: 0.35) {
                    self.playbutton.isHidden = false
                    self.playbutton.alpha = 1
                }
            }
            
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(nextTapped))
            
        } else {
            recordButton.setTitle("Tap to Record", for: .normal)
            showMessage(withTitle: "Uh Oh, Recording failed :(",
                        message: "There was a problem recording your whistle, please try again ")
        }
    }
}


//MARK: Extension
extension RecordWhistleViewController: AVAudioRecorderDelegate{
    /// Once we are done with recording, the VC ( delegate = self) will receive a audioRecorderDidFinishRecording message
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        
        /// basically to clean up and restore the view if an error occurs.
        if !flag{
            finishRecording(success: false)
        }
    }
}
