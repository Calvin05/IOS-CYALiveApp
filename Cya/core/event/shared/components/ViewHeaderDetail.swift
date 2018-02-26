//
//  ViewHeaderDetail.swift
//  Cya
//
//  Created by Rigo on 16/11/17.
//  Copyright © 2017 Cristopher Torres. All rights reserved.
//

import UIKit
import AVKit

class ViewHeaderDetail: UIView {

    var coverImage: UIImageView = UIImageView()
    var controlsContainer: UIView = UIView()
    var playPauseButton: UIButton = UIButton(type: .system)
    var playBackSlider: UISlider = UISlider()
    var videoLengthLabel: EdgeInsetLabel = EdgeInsetLabel()
    var currentTimeLabel: EdgeInsetLabel = EdgeInsetLabel()
    
    var activityIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView()
    var isPLaying: Bool = true
    
    
    var eventTimerLiveNow: EdgeInsetLabel = EdgeInsetLabel()
    var playerMovie: AVPlayer?
    var playerLayerMovie: AVPlayerLayer?
    var urlData: String = ""
    
    var data:Event = Event()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = frame
        
        setViewHeaderDetail()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCurrenView(currentView: String, data: String){
        urlData = data
        
        self.playerMovie = AVPlayer(url: URL(string: urlData)!)
        self.playerLayerMovie = AVPlayerLayer(player: playerMovie)
        self.layer.addSublayer(self.playerLayerMovie!)
        
        if(currentView == "image"){
            coverImageView()
        }
        
    }
    
    func playVideo(){
        
        playerLayerMovie?.frame = self.bounds

        playerMovie?.play()
        
        
        
        setControlsContainer()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if(keyPath == "currentItem.loadedTimeRanges"){
            activityIndicatorView.stopAnimating()
            playPauseButton.isHidden = false
            isPLaying = true
            
            let duration = playerMovie?.currentItem?.duration
            let seconds = CMTimeGetSeconds(duration!)
            let secondsText = Int(seconds) % 60
            let minutesText = String(format: "%02d", Int(seconds) / 60)
            videoLengthLabel.text = "\(minutesText):\(secondsText)"
        }
    }
    
    @objc func handlePlayPauseButton(){
        if(isPLaying){
            playerMovie?.pause()
            playPauseButton.setImage(UIImage(named: "cya_play"), for: .normal)
        }else{
            playerMovie?.play()
            playPauseButton.setImage(UIImage(named: "cya_pause"), for: .normal)
        }
        
        isPLaying = !isPLaying
    }
    
    @objc func handleSliderChange(){
        if let duration = playerMovie?.currentItem?.duration {
            let totalSeconds = CMTimeGetSeconds(duration)
            let value = Float64(playBackSlider.value) * totalSeconds
            let seekTime = CMTime(value: Int64(value), timescale: 1)
            
            playerMovie?.seek(to: seekTime)
            playerMovie?.seek(to: seekTime, completionHandler: {(completedSeek) in
                
            })
        }
    }

}


extension ViewHeaderDetail{
    
    func coverImageView(){
        
        self.addSubview(coverImage)
        
        coverImage.downloadedFrom(defaultImage: "thumb-logo", link: urlData)
        
        coverImage.translatesAutoresizingMaskIntoConstraints = false
        
        coverImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        coverImage.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        coverImage.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        coverImage.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
        
    }
    
    func setControlsContainer(){
        
        controlsContainer.frame = frame
        
        controlsContainer.backgroundColor = UIColor.clear
        
        self.addSubview(controlsContainer)
        controlsContainer.addSubview(activityIndicatorView)
        
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        
        activityIndicatorView.startAnimating()
        activityIndicatorView.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
        activityIndicatorView.activityIndicatorViewStyle = .whiteLarge
        
        
        playerMovie?.addObserver(self, forKeyPath: "currentItem.loadedTimeRanges", options: .new, context: nil)
        
        let interval = CMTime(value: 1, timescale: 2)
        playerMovie?.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main, using: {(progressTime) in
            let seconds = CMTimeGetSeconds(progressTime)
            let secondsString = String(format: "%02d", Int(seconds) % 60)
            let minutesString = String(format: "%02d", Int(seconds) / 60)
            self.currentTimeLabel.text = "\(minutesString):\(secondsString)"
            
            if let duration = self.playerMovie?.currentItem?.duration {
                let durationSeconds = CMTimeGetSeconds(duration)
                self.playBackSlider.value = Float(seconds / durationSeconds)
                
                if(progressTime == duration){
                    print("fin")
                    self.isPLaying = false
                    self.playPauseButton.setImage(UIImage(named: "cya_play"), for: .normal)
                }
            }
            
            
        })
        
        setPlayPauseButton()
        setPlayBackSlider()
    }
    
    func setPlayPauseButton(){
        
        controlsContainer.addSubview(playPauseButton)
        
        playPauseButton.translatesAutoresizingMaskIntoConstraints = false
        
        playPauseButton.isHidden = true
        
        playPauseButton.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
        playPauseButton.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
        playPauseButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        playPauseButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        playPauseButton.setImage(UIImage(named: "cya_pause"), for: .normal)
        playPauseButton.tintColor = UIColor.white
        playPauseButton.addTarget(self, action: #selector(handlePlayPauseButton), for: .touchUpInside)
    }
    
    func setPlayBackSlider(){
        
        controlsContainer.addSubview(playBackSlider)
        controlsContainer.addSubview(videoLengthLabel)
        controlsContainer.addSubview(currentTimeLabel)
        
        playBackSlider.translatesAutoresizingMaskIntoConstraints = false
        videoLengthLabel.translatesAutoresizingMaskIntoConstraints = false
        currentTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        videoLengthLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -5).isActive = true
        videoLengthLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -3).isActive = true
        
        videoLengthLabel.textColor = UIColor.white
        videoLengthLabel.numberOfLines = 0
        videoLengthLabel.textAlignment = .center
        videoLengthLabel.lineBreakMode = .byWordWrapping
        videoLengthLabel.sizeToFit()
        videoLengthLabel.text = "00:00"
        videoLengthLabel.font = UIFont(name: "Avenir", size: 11)
        
        
        currentTimeLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 5).isActive = true
        currentTimeLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -3).isActive = true
        
        currentTimeLabel.textColor = UIColor.white
        currentTimeLabel.numberOfLines = 0
        currentTimeLabel.textAlignment = .center
        currentTimeLabel.lineBreakMode = .byWordWrapping
        currentTimeLabel.sizeToFit()
        currentTimeLabel.text = "00:00"
        currentTimeLabel.font = UIFont(name: "Avenir", size: 11)
        
        
        playBackSlider.leftAnchor.constraint(equalTo: currentTimeLabel.rightAnchor, constant: 10).isActive = true
        playBackSlider.rightAnchor.constraint(equalTo: videoLengthLabel.leftAnchor, constant: -10).isActive = true
        playBackSlider.heightAnchor.constraint(equalToConstant: 15).isActive = true
        playBackSlider.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -3).isActive = true
        
        playBackSlider.minimumTrackTintColor = UIColor.cyaMagenta
        playBackSlider.setThumbImage(UIImage(named: "AVControl"), for: .normal)
        playBackSlider.addTarget(self, action: #selector(handleSliderChange), for: .valueChanged)
    }
    
    func setViewHeaderDetail(){
        self.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
}
