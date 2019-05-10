//
//  VidepPlayerViewController.swift
//  Motion Picture
//
//  Created by LogicalWings Mac on 29/04/19.
//  Copyright © 2019 Hiren Kadam. All rights reserved.
//

import UIKit
import AVFoundation

class VidePlayerViewController: UIViewController,UIScrollViewDelegate {

    @IBOutlet weak var ViewVideoPlayer: UIView!
    @IBOutlet weak var VideoListTableView: UITableView!
    @IBOutlet weak var lblVideoTitle: UILabel!
    @IBOutlet weak var lblVideoDescription: UILabel!
    @IBOutlet weak var VidepPlayerScrollView: UIScrollView!
    @IBOutlet weak var VideoPlayerViewInsideScroll: UIView!
    @IBOutlet weak var ViewVideoList: UIView!
    @IBOutlet weak var lblRelated: UILabel!
    @IBOutlet weak var btnPlayPause: UIButton!
    @IBOutlet weak var lblCurrentTime: UILabel!
    @IBOutlet weak var lblDuration: UILabel!
    @IBOutlet weak var timeSlider: UISlider!
    
    var videoPlayer : AVPlayer!
    var videoPlayerLayer : AVPlayerLayer!
    
    var selectedIndex = Int()
    var VideoList = [VideoListingData]()
    
    //var flag = false
    
    var isVideoPlaying = false
    
    // MARK: View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AppUtility.lockOrientation(.portrait)
        
        setVideoDetails()
        
        VideoListTableView.register(UINib(nibName: "VideoListTableViewCell", bundle: nil), forCellReuseIdentifier: "VideoListTableViewCell")
        VideoList = VideoListingArray.shared!
        VideoList.remove(at: selectedIndex)
        
        VideoListTableView.frame = CGRect(x: VideoListTableView.frame.origin.x, y: VideoListTableView.frame.origin.y, width: VideoListTableView.frame.width, height: 0)
        
        playVideoFromURL()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //super.viewDidAppear(animated)
        setViewDynamically()
        videoPlayingHandler()
    }
    
    override func viewDidLayoutSubviews() {
        
        //super.viewDidLayoutSubviews()
        
        videoPlayerLayer.frame = ViewVideoPlayer.bounds
        
        setViewDynamically()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        setViewDynamically()
    }
    
    
    // MARK: Slider Observer Functions
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == "duration",let duration = videoPlayer.currentItem?.duration.seconds,duration > 0.0 {
            self.lblDuration.text = getTimeString(time: videoPlayer.currentItem!.duration)
        }
    }
    
    // MARK: Custom Functions
    
    func setVideoDetails() {
        lblVideoTitle.text = VideoListingArray.shared![selectedIndex].title
        lblVideoDescription.text = VideoListingArray.shared![selectedIndex].description
    }
    
    func addCurrentTimeObserver() {
        let interval = CMTime(seconds: 0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        let mainQueue = DispatchQueue.main
        
        _ = videoPlayer.addPeriodicTimeObserver(forInterval: interval, queue: mainQueue, using: { [weak self] time in
            
            guard let currentitem = self?.videoPlayer.currentItem else {return}
            
            self?.timeSlider.maximumValue = Float((self?.videoPlayer.currentItem?.duration.seconds)!)
            self?.timeSlider.minimumValue = 0
            self?.timeSlider.value = Float(currentitem.currentTime().seconds)
            self?.lblCurrentTime.text = self?.getTimeString(time: currentitem.currentTime())
            
        })
    }
    
    @objc func playerDidFinishPlaying(note: NSNotification) {
        
        if selectedIndex < VideoListingArray.shared!.count - 1 {
            VideoList.insert(VideoListingArray.shared![selectedIndex], at: selectedIndex)
            selectedIndex = selectedIndex + 1
            VideoList.remove(at: selectedIndex)
            
        }else {
            VideoList.insert(VideoListingArray.shared![selectedIndex], at: selectedIndex)
            selectedIndex = 0
            VideoList.remove(at: selectedIndex)
        }
        
        setVideoDetails()
        VideoListTableView.reloadData()
        
        setViewDynamically()
        
        playVideoFromURL()
        isVideoPlaying = false
        videoPlayingHandler()
    }
    
    func getTimeString(time: CMTime) -> String{
        let totalSeconds = CMTimeGetSeconds(time)
        let hrs = Int(totalSeconds/3600)
        let min = Int(totalSeconds/60)%60
        let sec = Int(totalSeconds.truncatingRemainder(dividingBy: 60))
        
        if hrs > 0 {
            return String(format: "%2i:%02i:%02i", arguments: [hrs,min,sec])
        }else {
            return String(format: "%02i:%02i", arguments: [min,sec])
        }
    }
    
    func playVideoFromURL() {
        
        let url = URL(string: VideoListingArray.shared![selectedIndex].url!)
        
        videoPlayer = AVPlayer(url: url!)
        
        videoPlayerLayer = AVPlayerLayer(player: videoPlayer)
        videoPlayerLayer.videoGravity = .resize
        
        ViewVideoPlayer.layer.addSublayer(videoPlayerLayer)
        
        
        videoPlayer.currentItem?.addObserver(self, forKeyPath: "duration", options: [.new,.initial], context: nil)
        addCurrentTimeObserver()
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: videoPlayer.currentItem)
        
    }
    
    func setViewDynamically() {
        
        // Mark: Dynamic height of lblVideoTitle
        lblVideoTitle.translatesAutoresizingMaskIntoConstraints = false
        lblVideoTitle.frame = CGRect(x: lblVideoTitle.frame.origin.x, y: lblVideoTitle.frame.origin.y, width: VideoPlayerViewInsideScroll.bounds.width, height: estimatedHeightOfLabel(text: lblVideoTitle.text!, textsize: 25))
        lblVideoTitle.translatesAutoresizingMaskIntoConstraints = true
        
        // Mark: Dynamic height of lblVideoDescription
        lblVideoDescription.translatesAutoresizingMaskIntoConstraints = false
        lblVideoDescription.frame = CGRect(x: lblVideoDescription.frame.origin.x, y: lblVideoTitle.frame.origin.y + lblVideoTitle.frame.height + 16, width: VideoPlayerViewInsideScroll.bounds.width, height: estimatedHeightOfLabel(text: lblVideoDescription.text!, textsize: 18))
        lblVideoDescription.translatesAutoresizingMaskIntoConstraints = true
        
        // Mark: Dynamic height of lblVideoTitle
        lblRelated.translatesAutoresizingMaskIntoConstraints = false
        lblRelated.frame = CGRect(x: lblRelated.frame.origin.x, y: lblRelated.frame.origin.y, width: VideoPlayerViewInsideScroll.bounds.width, height: 24)
        lblRelated.translatesAutoresizingMaskIntoConstraints = true
        
        VideoListTableView.translatesAutoresizingMaskIntoConstraints = false
        VideoListTableView.setNeedsLayout()
        //VideoListTableView.frame = CGRect(x: VideoListTableView.frame.origin.x, y: lblRelated.frame.size.height + 16, width: VideoListTableView.frame.width, height: 500)
        VideoListTableView.frame = CGRect(x: VideoListTableView.frame.origin.x, y: lblRelated.frame.size.height + 16, width: VideoPlayerViewInsideScroll.bounds.width, height: VideoListTableView.contentSize.height)
        VideoListTableView.translatesAutoresizingMaskIntoConstraints = true
        
        // Mark: Dynamic height of ViewVideoList
        ViewVideoList.translatesAutoresizingMaskIntoConstraints = false
        ViewVideoList.frame = CGRect(x: ViewVideoList.frame.origin.x, y: lblVideoDescription.frame.origin.y + lblVideoDescription.frame.size.height + 16, width: VideoPlayerViewInsideScroll.bounds.width, height: VideoListTableView.contentSize.height + lblRelated.frame.size.height + 50)
        ViewVideoList.translatesAutoresizingMaskIntoConstraints = true
        
        
        VideoPlayerViewInsideScroll.frame = CGRect(x: VideoPlayerViewInsideScroll.frame.origin.x, y: VideoPlayerViewInsideScroll.frame.origin.y, width: VideoPlayerViewInsideScroll.bounds.width, height: lblVideoDescription.frame.origin.y + lblVideoDescription.frame.size.height + ViewVideoList.frame.size.height)
        
        VidepPlayerScrollView.contentSize = CGSize(width: VideoPlayerViewInsideScroll.bounds.width, height: VideoPlayerViewInsideScroll.bounds.height)
        
        //self.view.frame = CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y, width: self.view.frame.size.width, height: VidepPlayerScrollView.contentSize.height + 70)
        
        
    }
    
    func estimatedHeightOfLabel(text: String,textsize: CGFloat) -> CGFloat {
        
        let size = CGSize(width: view.frame.width - 16, height: 1000)
        
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: textsize, weight: .semibold)]
        
        let rectangleHeight = String(text).boundingRect(with: size, options: options, attributes: attributes, context: nil).height
        
        return rectangleHeight
    }
    
    func videoPlayingHandler() {
        if isVideoPlaying {
            videoPlayer.pause()
            btnPlayPause.setTitle("Play", for: .normal)
        }else {
            videoPlayer.play()
            btnPlayPause.setTitle("Pause", for: .normal)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        /*
        let yOffset = scrollView.contentOffset.y

        print("yoffset--\(yOffset)")
        print("Scroll view content--\(scrollView.contentSize.height)")
        print("screen height--\(UIScreen.main.bounds.height)")
        print("\((scrollView.contentSize.height - UIScreen.main.bounds.height)*(yOffset/(scrollView.contentSize.height - UIScreen.main.bounds.height)))")
        
        if scrollView == self.VidepPlayerScrollView {
            if (yOffset >= (scrollView.contentSize.height - UIScreen.main.bounds.height)) {
                
                if flag == true {
                    self.VidepPlayerScrollView.isScrollEnabled = true
                    self.VideoListTableView.isScrollEnabled = false
                    flag = false
                }else {
                    self.VidepPlayerScrollView.isScrollEnabled = false
                    self.VideoListTableView.isScrollEnabled = true
                }
            }
        }
        
        if scrollView == self.VideoListTableView {
            if yOffset <= 0 {
                self.VidepPlayerScrollView.isScrollEnabled = true
                self.VideoListTableView.isScrollEnabled = false
                flag = true
            }
        }
     */
    }
    
    // MARK: Button Actions
    
    @IBAction func btnPlayAction(_ sender: UIButton) {
        if isVideoPlaying {
            isVideoPlaying = false
        }else {
            isVideoPlaying = true
        }
        videoPlayingHandler()
    }
    @IBAction func btnPreviousAction(_ sender: UIButton) {
        
        let currentTime = CMTimeGetSeconds(videoPlayer.currentTime())
        var newTime = currentTime - 10.0
        
        if newTime < 0 {
            newTime = 0
        }
        
        let time: CMTime = CMTimeMake(value: Int64(newTime * 1000), timescale: 1000)
        videoPlayer.seek(to: time)
    }
    @IBAction func btnNextAction(_ sender: UIButton) {
        
        guard let duration = videoPlayer.currentItem?.duration else {return}
        
        let currentTime = CMTimeGetSeconds(videoPlayer.currentTime())
        let newTime = currentTime + 10.0
        
        if newTime < (CMTimeGetSeconds(duration) - 10.0) {
            let time: CMTime = CMTimeMake(value: Int64(newTime * 1000), timescale: 1000)
            videoPlayer.seek(to: time)
            
        }
    }
    
    @IBAction func sliderValueChangedAction(_ sender: UISlider) {
        
        videoPlayer.seek(to: CMTimeMake(value: Int64(sender.value * 1000), timescale: 1000))
    }
}

//MARK: TableView Delegates and Datasource
extension VidePlayerViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return VideoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = VideoListTableView.dequeueReusableCell(withIdentifier: "VideoListTableViewCell", for: indexPath) as! VideoListTableViewCell
        cell.ViewBackground.addBorderShadowDown(shadowOpacity: 0.7, shadowRadius: 7, shadowColor: UIColor.darkGray)
        cell.selectionStyle = .none
        cell.VideoObj = VideoList[indexPath.row]
        
        return cell
    }
    
    /*
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row < VideoList.count - 1 {
            VideoList.insert(VideoListingArray.shared![selectedIndex], at: selectedIndex)
            selectedIndex = indexPath.row+1
            VideoList.remove(at: indexPath.row + 1)
            
        }
        setVideoDetails()
        VideoListTableView.reloadData()
        
        setViewDynamically()
        
        print(Float((self.videoPlayer.currentItem?.duration.seconds)!))
        
        self.timeSlider.minimumValue = Float((self.videoPlayer.currentItem?.duration.seconds)!)
        
        playVideoFromURL()
        isVideoPlaying = false
        videoPlayingHandler()
    }
    */
}
