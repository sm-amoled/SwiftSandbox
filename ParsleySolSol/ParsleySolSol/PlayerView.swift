//
//  PlayerView.swift
//  ParsleySolSol
//
//  Created by Park Sungmin on 2022/08/26.
//

import AVFoundation
import UIKit

class PlayerView: UIView {
    var player: AVPlayer!
    var playerLayer: AVPlayerLayer!
    
    func setPlayerURL(url: URL) {
        player = AVPlayer(url: url)
        player.allowsExternalPlayback = true
        
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resizeAspectFill
        
        self.layer.addSublayer(playerLayer)
        playerLayer.frame = self.bounds
    }
}
