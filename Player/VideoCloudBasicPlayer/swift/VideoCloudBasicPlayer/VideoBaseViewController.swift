//
//  BaseVideoViewController.swift
//  OfflinePlayer
//
//  Copyright © 2019 Brightcove, Inc. All rights reserved.
//

import UIKit
import BrightcovePlayerSDK

class BaseVideoViewController: UIViewController,  BCOVPlaybackControllerDelegate {
    
    private lazy var authProxy: BCOVFPSBrightcoveAuthProxy? = {
        // Publisher/application IDs not required for Dynamic Delivery
        let _authProxy = BCOVFPSBrightcoveAuthProxy(publisherId: nil, applicationId: nil)
        
        // You can use the same auth proxy for the offline video manager
        // and the call to create the FairPlay session provider.
        BCOVOfflineVideoManager.shared()?.authProxy = _authProxy
        
        return _authProxy
    }()
    
    var playbackController: BCOVPlaybackController?
    var isFullscreen: Bool = false
    
    
    var delegate: BCOVPUIPlayerViewDelegate?
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        playbackController?.pause()
        

        
    }
    
    func createNewPlaybackController(onView videoContainerView: UIView) -> BCOVPlaybackController? {
         let playerView: BCOVPUIPlayerView? = {
            
            let options = BCOVPUIPlayerViewOptions()
            options.presentingViewController = self
            
            
            //var delegate: BCOVPUIPlayerViewDelegate?
            
            // Create PlayerUI views with normal VOD controls.
            let controlView = BCOVPUIBasicControlView.withVODLayout()
            
            controlView?.layout.compactLayoutMaximumWidth = 100
            
            controlView?.setFontSizeForButtons(15.0)
            
            controlView?.setFontSizeForLabels(15.0)
            
            controlView?.layout.horizontalItemSpacing = 0
            
            
            let layoutDic = controlView?.layout.allLayoutItems
            
            for item in layoutDic! {
                
                guard let i = item as? BCOVPUILayoutView else {
                    
                    print("unable to do something")
                    
                    return nil
                    
                }
                
                i.elasticity = 0
                
                i.minimumWidth = 50
                
            }
        
            
            

            
            print("Elements: \(controlView?.layout.horizontalItemSpacing)")
            
            
            
            guard let _playerView = BCOVPUIPlayerView(playbackController: nil, options: options, controlsView: controlView) else {
                return nil
            }
            
            // Add to parent view
            videoContainerView.addSubview(_playerView)
            _playerView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                _playerView.topAnchor.constraint(equalTo: videoContainerView.topAnchor),
                _playerView.rightAnchor.constraint(equalTo: videoContainerView.rightAnchor),
                _playerView.leftAnchor.constraint(equalTo: videoContainerView.leftAnchor),
                _playerView.bottomAnchor.constraint(equalTo: videoContainerView.bottomAnchor)
            ])
            
            // Receive delegate method callbacks
            _playerView.delegate = self
            
            return _playerView
        }()
        
        // This app shows how to set up your playback controller for playback of FairPlay-protected videos.
        // The playback controller, as well as the download manager will work with either FairPlay-protected
        // videos, or "clear" videos (no DRM protection).
        let sdkManager = BCOVPlayerSDKManager.shared()
        
        // Create the session provider chain
        let options = BCOVBasicSessionProviderOptions()
        options.sourceSelectionPolicy = BCOVBasicSourceSelectionPolicy.sourceSelectionHLS(withScheme: kBCOVSourceURLSchemeHTTPS)
        //guard let basicSessionProvider = sdkManager?.createBasicSessionProvider(with: options), let authProxy = self.authProxy else {
       //     return
        //}
        //let fairPlaySessionProvider = sdkManager?.createFairPlaySessionProvider(withApplicationCertificate: nil, authorizationProxy: authProxy, upstreamSessionProvider: basicSessionProvider)
        
        // Create the playback controller
        let _playbackController = sdkManager?.createPlaybackController()
        //fairPlaySessionProvider, viewStrategy: nil)
        
        // Start playing right away (the default value for autoAdvance is false)
        _playbackController?.isAutoAdvance = true
        _playbackController?.isAutoPlay = false
        
        
        
        // Register the delegate method callbacks
        _playbackController?.delegate = self
        
        playerView?.playbackController = _playbackController
        
        
        playbackController = _playbackController
        
        return playbackController!
    }

}

extension BaseVideoViewController: BCOVPUIPlayerViewDelegate {
    
    
    func playerView(_ playerView: BCOVPUIPlayerView!, controlsFadingViewDidFadeIn controlsFadingView: UIView!) {
        
        print("Controlls are showing")
        
        
        UIApplication.shared.setStatusBarHidden(false, with: .fade)
        
                
        if isFullscreen {
            
                UIApplication.shared.statusBarStyle = .lightContent
        
        } else {
            
            if #available(iOS 13.0, *) {
                UIApplication.shared.statusBarStyle = .darkContent
            } else {
                // Fallback on earlier versions
            }
            
        }
        
        
        
    }
    
    func playerView(_ playerView: BCOVPUIPlayerView!, controlsFadingViewDidFadeOut controlsFadingView: UIView!) {
        print("Controlls are hidding")

         if isFullscreen {
             
                UIApplication.shared.setStatusBarHidden(true, with: .fade)

            } else {
            
                UIApplication.shared.statusBarStyle = .lightContent

                UIApplication.shared.setStatusBarHidden(false, with: .fade)

                  if #available(iOS 13.0, *) {
                    
                      UIApplication.shared.statusBarStyle = .darkContent
                    
                  } else {
                      // Fallback on earlier versions
                  }
              }
    }
    
    func playerView(_ playerView: BCOVPUIPlayerView!, willTransitionTo screenMode: BCOVPUIScreenMode) {

        if screenMode.rawValue == 1 {
            
            isFullscreen = true
            
        } else {
            
            isFullscreen = false
            
        }
        
    }
    
    func playbackController(_ controller: BCOVPlaybackController!, playbackSession session: BCOVPlaybackSession!, didReceive lifecycleEvent: BCOVPlaybackSessionLifecycleEvent!) {
        
        guard let type = lifecycleEvent.eventType else {
            
            print("Unable to get player event")
            
            return
        }
        
        switch type {
        case "kBCOVPlaybackSessionLifecycleEventPlaybackStalled":
            //DO SOMETHING TO DISPLAY A SPIN WHEEL
            print("Player is buffering")
        case "kBCOVPlaybackSessionLifecycleEventPlaybackRecovered":
            //DO SOMETHING TO DISMISS THE SPIN WHEEL
            print("Player is not buffering anymore")
        case "kBCOVPlaybackSessionLifecycleEventPlay":
            print("Play")
        case "kBCOVPlaybackSessionLifecycleEventPause":
            print("Pause")
        case "kBCOVPlaybackSessionLifecycleEventPlaybackBufferEmpty":
            print("Buffering")
        case "kBCOVPlaybackSessionLifecycleEventPlaybackLikelyToKeepUp":
            print("Ready to play again")
        default:
            print("Do Nothing")
        }


    }
    
}


extension UIView {
    
    func addConstraintsWithFormat(format: String, views: UIView...) {
        
        var viewsDictionary = [String: UIView]()
        
        for(index, view) in views.enumerated(){
            
            let key = "v\(index)"
            
            view.translatesAutoresizingMaskIntoConstraints = false
            
            viewsDictionary[key] = view
            
        }
    
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary))
    
    }
    
}
