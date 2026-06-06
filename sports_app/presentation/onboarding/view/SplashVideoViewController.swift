//
//  SplashVideoViewController.swift
//  sports_app
//
//  Created by Thaowpsta Saiid on 05/06/2026.
//


import UIKit
import AVFoundation

class SplashVideoViewController: UIViewController {
    
    var onVideoFinished: (() -> Void)?
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        playSplashVideo()
    }

    private func playSplashVideo() {
        guard let path = Bundle.main.path(forResource: "splash_video", ofType: "mp4") else {
            print("Video file not found in bundle.")
            finish()
            return
        }

        let url = URL(fileURLWithPath: path)
        player = AVPlayer(url: url)
        
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.frame = view.bounds
        playerLayer?.videoGravity = .resizeAspectFill
        
        if let playerLayer = playerLayer {
            view.layer.addSublayer(playerLayer)
        }
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(videoDidFinish),
            name: .AVPlayerItemDidPlayToEndTime,
            object: player?.currentItem
        )
        
        player?.play()
    }

    @objc private func videoDidFinish() {
        finish()
    }

    private func finish() {
        DispatchQueue.main.async { [weak self] in
            self?.onVideoFinished?()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        playerLayer?.frame = view.bounds
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
