//
//  ViewController.swift
//  BasicFairPlayPlayer
//
//  Copyright © 2019 Brightcove, Inc. All rights reserved.
//

import UIKit
import AVFoundation

// Add your Brightcove account and video information here.
// The video should be encrypted with FairPlay
let kViewControllerVideoCloudAccountId = "x"
let kViewControllerVideoCloudPolicyKey = "x"
let kViewControllerVideoReferenceId = "x"

// If you are using Dynamic Delivery you don't need to set these
let kViewControllerFairPlayApplicationId = ""
let kViewControllerFairPlayPublisherId = ""

enum ProgramError: Error {
       case missingApplicationCertificate
       case noCKCReturnedByKSM
   }

class ViewController: UIViewController, BCOVPlaybackControllerDelegate {
    let playbackService = BCOVPlaybackService(accountId: kViewControllerVideoCloudAccountId, policyKey: kViewControllerVideoCloudPolicyKey)
    var fairPlayAuthProxy: BCOVFPSBrightcoveAuthProxy?
    var playbackController :BCOVPlaybackController?
    @IBOutlet weak var videoContainerView: UIView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if kViewControllerVideoCloudAccountId == ""
        {
            print("\n***** WARNING *****")
            print("Remember to add your account credentials at the top of ViewController.swift")
            print("***** WARNING *****")
            return
        }
        
        let sdkManager = BCOVPlayerSDKManager.sharedManager()
        
        // This shows the two ways of using the Brightcove FairPlay session provider:
        // Set to true for Dynamic Delivery; false for a legacy Video Cloud account
        let using_dynamic_delivery = false
        
        if (( using_dynamic_delivery ))
        {
            // If you're using Dynamic Delivery, you don't need to load
            // an application certificate. The FairPlay session will load an
            // application certificate for you if needed.
            // You can just load and play your FairPlay videos.
            
            // If you are using Dynamic Delivery, you can pass nil for the publisherId and applicationId,
            //self.fairPlayAuthProxy = BCOVFPSBrightcoveAuthProxy(publisherId: nil,
                                                              //  applicationId: nil)
            //self.fairPlayAuthProxy = BCOVFPSAuthorizationProxy()
            
            
            
            // Create chain of session providers
            let psp = sdkManager?.createBasicSessionProvider(with:nil)
            let fps = sdkManager?.createFairPlaySessionProvider(withApplicationCertificate:nil,
                                                                authorizationProxy:self.fairPlayAuthProxy!,
                                                                upstreamSessionProvider:psp)
            
            // Create the playback controller
            let playbackController = sdkManager?.createPlaybackController(with:fps, viewStrategy:nil)
            
            playbackController?.isAutoAdvance = false
            playbackController?.isAutoPlay = true
            playbackController?.delegate = self
            
            if let _view = playbackController?.view {
                _view.translatesAutoresizingMaskIntoConstraints = false
                videoContainerView.addSubview(_view)
                NSLayoutConstraint.activate([
                    _view.topAnchor.constraint(equalTo: videoContainerView.topAnchor),
                    _view.rightAnchor.constraint(equalTo: videoContainerView.rightAnchor),
                    _view.leftAnchor.constraint(equalTo: videoContainerView.leftAnchor),
                    _view.bottomAnchor.constraint(equalTo: videoContainerView.bottomAnchor)
                ])
            }
            
            self.playbackController = playbackController
            
            self.requestContentFromPlaybackService()
            self.createPlayerView()
        }
        else
        {
            // Legacy Video Cloud account
            
            // You can create your FairPlay session provider first, and give it an
            // application certificate later, but in this application we want to play
            // right away, so it's easier to load our player as soon as we know
            // that we have an application certificate.
            
            // Retrieve application certificate using the FairPlay auth proxy
            self.fairPlayAuthProxy = BCOVFPSBrightcoveAuthProxy(publisherId: kViewControllerFairPlayPublisherId, applicationId: kViewControllerFairPlayApplicationId)
            
//            self.fairPlayAuthProxy =
//
//            self.fairPlayAuthProxy?.retrieveApplicationCertificate() { [weak self] (applicationCertificate: Data?, error: Error?) -> Void in
//                guard let appCert = applicationCertificate else
//                {
//                    print("ViewController Debug - Error retrieving app certificate: %@", error!)
//                    return
//                }
//                guard let strongSelf = self else {
//                    return
//                }
            
            let kVideoURLString: String = "https://ampas-2019-staging.akamaized.net/wmt:WMT1/Case-575206_V8_hls/Case-575206_V8-playlist.m3u8"
            
            let videoURL = URL(string: kVideoURLString)
            let source = BCOVSource(url: videoURL, deliveryMethod: kBCOVSourceDeliveryHLS, properties: nil)
            let video = BCOVVideo(source: source, cuePoints: nil, properties: nil)
            
            self.fairPlayAuthProxy?.fpsBaseURL = URL(string: "https://fp-keyos.licensekeyserver.com/getkey")
            
            var appCert: Data?
                       

                       do {
                           try appCert   = requestApplicationCertificate()

                       } catch  {
                           print("problem gathering the app cert")
                           
                       }
            
       //     self.fairPlayAuthProxy?.encryptedContentKey(forContentKeyIdentifier: <#T##String#>, contentKeyRequest: <#T##Data#>, source: source, options: <#T##[AnyHashable : Any]?#>, completionHandler: <#T##(URLResponse?, Data?, Error?) -> Void#>)
            
          //  var resourceLoadingRequest: AVAssetResourceLoadingRequest?
            
            //let contentKeyIdentifierURL = resourceLoadingRequest?.request.url
            
            //let spcData = try resourceLoadingRequest.streamingContentKeyRequestData(forApp: appCert, contentIdentifier: assetIDData, options: nil)
            
           // let postString = "spc=\(spcData.base64EncodedString())&assetId=\(assetID)"

            let postData: Data = "1.".data(using: .ascii, allowLossyConversion: true)!
            
            let assetId = "skd://fp-keyos.licensekeyserver.com/getkey?kid=db0217369a3b4b9a8ebcd8978efb51ca"
            //self.fairPlayAuthProxy?.encryptedContentKey(forContentKeyIdentifier: assetId , contentKeyRequest: ckr  , source: source!, options: nil, completionHandler: { [weak self] (response: URLResponse?, data: Data? ,error: Error?) -> Void in
                    
            //    guard let response = response else {
                    
            //        print("Error returning data")
            //        return
            //    }
                
            //    print("The response: \(response)")
            //    print("The data: \(data)")

                
                    
          //  })
           // self.fairPlayAuthProxy?.contentIdentifier(from: "skd://fp-keyos.licensekeyserver.com/getkey?kid=db0217369a3b4b9a8ebcd8978efb51ca")
            
           
            
            //self.fairPlayAuthProxy?.
                
                // Create chain of session providers
                let psp = sdkManager?.createBasicSessionProvider(with:nil)
                let fps = sdkManager?.createFairPlaySessionProvider(withApplicationCertificate:appCert,
                                                                    authorizationProxy:fairPlayAuthProxy!,
                                                                    upstreamSessionProvider:psp)
                
                // Create the playback controller
            var playbackController = sdkManager?.createPlaybackController(with:fps, viewStrategy:nil)
                
                playbackController?.isAutoAdvance = false
                playbackController?.isAutoPlay = true
                playbackController?.delegate = self
                
                if let _view = playbackController?.view {
                    _view.translatesAutoresizingMaskIntoConstraints = false
                    videoContainerView.addSubview(_view)
                    NSLayoutConstraint.activate([
                        _view.topAnchor.constraint(equalTo: videoContainerView.topAnchor),
                        _view.rightAnchor.constraint(equalTo: videoContainerView.rightAnchor),
                        _view.leftAnchor.constraint(equalTo: videoContainerView.leftAnchor),
                        _view.bottomAnchor.constraint(equalTo: videoContainerView.bottomAnchor)
                    ])
                }

            self.playbackController = playbackController
                
                requestContentFromPlaybackService()
                createPlayerView()
            //}
        }
    }
    
    func requestContentFromPlaybackService() {
//        playbackService?.findVideo(withReferenceID:kViewControllerVideoReferenceId, parameters: nil) { (video: BCOVVideo?, jsonResponse: [AnyHashable: Any]?, error: Error?) -> Void in
//            if video == nil
//            {
//                print("ViewController Debug - Error retrieving video: \(error?.localizedDescription ?? "unknown error")")
//                return
//            }
//
//            self.playbackController!.setVideos([ video! ] as NSArray)
//
//        }
        
        //no drm url http://solutions.brightcove.com/aorozco/FP/Non-Muxed/unencrypted/master.m3u8
        //drm url https://ampas-2019-staging.akamaized.net/wmt:WMT1/Case-575206_V8_hls/Case-575206_V8-playlist.m3u8
        
        let kVideoURLString: String = "https://ampas-2019-staging.akamaized.net/wmt:WMT1/Case-575206_V8_hls/Case-575206_V8-playlist.m3u8"
        
        let videoURL = URL(string: kVideoURLString)
        let source = BCOVSource(url: videoURL, deliveryMethod: kBCOVSourceDeliveryHLS, properties: nil)
        let video = BCOVVideo(source: source, cuePoints: nil, properties: nil)
        
        
        //video?.usesFairPlay = true

        playbackController?.setVideos([video] as NSFastEnumeration)
    }
    
    func requestApplicationCertificate() throws -> Data {
           
           // MARK: ADAPT - You must implement this method to retrieve your FPS application certificate.
           var applicationCertificate: Data? = nil
           
               do {
                   applicationCertificate = try Data(contentsOf:URL(string:"https://fp-keyos.licensekeyserver.net/cert/f248ed452493c77065c030fa9af97b6b.der")!)
               } catch {
                   print("Error loading FairPlay application certificate: \(error)")
               }
           
           guard applicationCertificate != nil else {
               throw ProgramError.missingApplicationCertificate
           }
           
           return applicationCertificate!
       }
    
    // Create the player view
    func createPlayerView() {
        let controlView = BCOVPUIBasicControlView.withVODLayout()
        guard let playerView = BCOVPUIPlayerView(playbackController: self.playbackController, options: nil, controlsView: controlView) else {
            return
        }
        videoContainerView.addSubview(playerView)
        playerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            playerView.topAnchor.constraint(equalTo: videoContainerView.topAnchor),
            playerView.rightAnchor.constraint(equalTo: videoContainerView.rightAnchor),
            playerView.leftAnchor.constraint(equalTo: videoContainerView.leftAnchor),
            playerView.bottomAnchor.constraint(equalTo: videoContainerView.bottomAnchor)
            ])
        
        playerView.playbackController = self.playbackController
    }
    
    func playbackController(_: BCOVPlaybackController!, didAdvanceTo: BCOVPlaybackSession!) {
        print("ViewController Debug: Advanced to new session.")
    }
    
    func playbackController(_ controller: BCOVPlaybackController!, playbackSession session: BCOVPlaybackSession, didReceive lifecycleEvent: BCOVPlaybackSessionLifecycleEvent!) {
        // Report any errors that may have occurred with playback.
        if (kBCOVPlaybackSessionLifecycleEventFail == lifecycleEvent.eventType)
        {
            let error = lifecycleEvent.properties["error"] as! NSError
            print("Playback error: \(error.localizedDescription)")
        }
    }
}
