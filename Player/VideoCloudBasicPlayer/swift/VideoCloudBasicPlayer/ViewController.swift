//
//  ViewController.swift
//  VideoCloudBasicPlayer
//
//  Copyright © 2019 Brightcove, Inc. All rights reserved.
//

import AVKit
import UIKit
import BrightcovePlayerSDK

struct ConfigConstants {
    static let AccountID = "4800266849001"
    static let PolicyKey = "BCpkADawqM3n0ImwKortQqSZCgJMcyVbb8lJVwt0z16UD0a_h8MpEYcHyKbM8CGOPxBRp0nfSVdfokXBrUu3Sso7Nujv3dnLo0JxC_lNXCl88O7NJ0PR0z2AprnJ_Lwnq7nTcy1GBUrQPr5e"
    static let videoID = "5255514387001"
    static let videoID2 = "6030821731001"
}

class ViewController: BaseVideoViewController, UICollectionViewDelegate , UICollectionViewDataSource {

    //let sharedSDKManager = BCOVPlayerSDKManager.shared()

    
    let videosArray: [String] = [ConfigConstants.videoID,ConfigConstants.videoID2]
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SampleCollectionViewCell", for: indexPath) as! SampleCollectionViewCell
        
      //  for video in videosArray {
        
        cell.pbController = createNewPlaybackController(onView: cell.videoPlayer)
        //playbackController?.setVideos([])
        
        retrieveVideo(withVideo: videosArray[indexPath.item], forPBC: cell.pbController! )
       // }
        return cell
    }
    
    private func retrieveVideo(withVideo video: String, forPBC playbackController: BCOVPlaybackController) {
                      
           // Retrieve a playlist through the BCOVPlaybackService
           let playbackServiceRequestFactory = BCOVPlaybackServiceRequestFactory(accountId: ConfigConstants.AccountID, policyKey: ConfigConstants.PolicyKey)
           
           let playbackService = BCOVPlaybackService(requestFactory: playbackServiceRequestFactory)
           
        
        playbackService?.findVideo(withVideoID: video, parameters: nil, completion: { [weak self] (bcvideo: BCOVVideo?, jsonResponse: [AnyHashable:Any]?, error: Error?) in
           
            if let bcv = bcvideo {
             
                playbackController.setVideos([bcv] as NSFastEnumeration)

             
             } else {
                print("No video for ID \"\(video)\" was found.")
                
            }
            
        } )
        
    }
        
        
        //(with: video, parameters: queryParams, completion: { [weak self] (bcvideo: BCOVVideo?, jsonResponse: [AnyHashable:Any]?, error: Error?) in
               
               //self?.refreshControl.endRefreshing()
               
              
      

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        
        //retrievePlaylist()
        
    }
    
 
    
  

    
}
