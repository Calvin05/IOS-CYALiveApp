//
//  ViewController.swift
//  Cya
//
//  Created by Cristopher Torres on 9/27/17.
//  Copyright © 2017 Cristopher Torres. All rights reserved.
//

import UIKit
import MobileCoreServices
import AVKit



class ViewController: UIViewController {

    @IBOutlet weak var chooseVideo: UIButton!
    @IBOutlet weak var vwVideoView: UIView!
    
    
    var urlVideo :URL = URL(string: "https://movies.synaptop.com/synaparty/Billy_dash/stream.mpd")!
    
    
    @IBAction func btnChooseVideoTapped(_ sender: UIButton) {
        
        let player = AVPlayer(url: urlVideo)
        
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = vwVideoView.bounds
        
        vwVideoView.layer.addSublayer(playerLayer)
        
        player.seek(to: CMTimeMakeWithSeconds(618.95, (player.currentItem?.asset.duration.timescale)!))
        
        player.play()
        
    }
    
    
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
        //TEST Chat - Questions
        let chatService: ChatService = ChatService(sessionId: "")
        
        chatService.onNewMessage(handler: {data, ack in
//            print(data!)
        })
        
        chatService.onChatHistory(handler: {data, ack in
//            print(data!)
        })
        
        chatService.onDeleteMesssage(handler: {data, ack in
//            print(data!)
        })
        
        chatService.onQuestionHistory(handler: {data, ack in
//            print(data![0].content!)
        })
        
        chatService.onNewMarkedQuestion(handler: {data, ack in
//            print(data!)
        })
        
        chatService.onNewQuestion(handler: {data, ack in
//            print(data!)
        })
        
        chatService.onDeleteQuestion(handler: {data, ack in
//            print(data!)
        })
        
        chatService.onUserBlocked(handler: {data, ack in
//            print(data!)
        })
        
        chatService.onUserUnblocked(handler: {data, ack in
//            print(data!)
        })
        
        //TEST EventsApi
//        var eventHelper: EventHelper = EventHelper()
//
//        eventHelper.getUrlMainStage(eventId: 5, userId: "186982")
//
//
//        //TEST SYNC
//        let syncService: SyncService = SyncService()
        
//        syncService.onSync(handler: {data, ack in
//            print(data!)
//        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

