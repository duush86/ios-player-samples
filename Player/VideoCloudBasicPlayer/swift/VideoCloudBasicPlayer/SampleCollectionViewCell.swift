//
//  SampleCollectionViewCell.swift
//  VideoCloudBasicPlayer
//
//  Created by Antonio Orozco on 11/6/19.
//  Copyright © 2019 Brightcove. All rights reserved.
//

import UIKit
import BrightcovePlayerSDK
import AVKit



class SampleCollectionViewCell: UICollectionViewCell {
          
    @IBOutlet weak var videoPlayer: UIView!
   
    var pbController: BCOVPlaybackController?
    
    override func awakeFromNib() {
        
        
        
    }
}
