//
//  MyCameraVC.swift
//  Drinks
//
//  Created by maninder on 9/5/17.
//  Copyright © 2017 Maninderjit Singh. All rights reserved.
//

import UIKit

enum VideoState : Int {
    
    case Stopped = 0,
    Started
}
enum CameraType : Int {
    
    case Rear = 0,
    Front
}



func getThumbnail(path : URL) 
{
    
    
    let filePath: URL = path
    
    
    do {
        let asset = AVURLAsset(url: filePath , options: nil)
        let imgGenerator = AVAssetImageGenerator(asset: asset)
        imgGenerator.appliesPreferredTrackTransform = true
        let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(0, 1), actualTime: nil)
        let thumbnail = UIImage(cgImage: cgImage)
        
        // thumbnail here
        
    } catch let error {
        print("*** Error generating thumbnail: \(error.localizedDescription)")
    }
}


class MyCameraVC: UIViewController,VideoRecordingManagerDelegate {

    @IBOutlet var btnCamera: UIButton!
    
    var recordingManager : VideoRecordingManager!
    
    var videoState : VideoState = .Stopped
    var cameraState : CameraType = .Rear

    
    
    var videoInterval = 59
    var timer : Timer!
    
    @IBOutlet var viewcapturing: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.layoutIfNeeded()
        self.navigationItem.hidesBackButton = true
        self.navigationController?.isNavigationBarHidden = true
        recordingManager = VideoRecordingManager()

        recordingManager.maxRecordingTime = 60.0
        recordingManager.delegate = self
        
        //_recordingManager = [[VideoRecordingManager alloc] init];
        
        recordingManager.previewLayer.frame = CGRect(x: 0, y: 0, width: viewcapturing.frame.size.width, height: viewcapturing.frame.size.height)
        self.viewcapturing.layer.insertSublayer( recordingManager.previewLayer , at: UInt32(0))
        self.recordingManager.startCapture()
        
        
        
        
//        
//        self.recordingManager.previewLayer.frame = self.view.bounds;
//        [self.view.layer insertSublayer:self.recordingManager.previewLayer atIndex:0];
//        [self.recordingManager startCapture];

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func actionBtnStartStop(_ sender: Any) {
        
        if videoState == .Stopped
        {
            videoState = .Started
            btnCamera.isSelected = true
            recordingManager.startRecoring()
            self.timer =  Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (result) in
                self.decreaseTimer()
            })
            
        }else
        {
          self.stopVideo()

        }
        
    }
    
    
    @IBAction func actionBtnRotate(_ sender: Any) {
        
        if cameraState == .Rear
        {
          //  self.recordingManager.closeFlashLight()
            cameraState = .Front

            self.recordingManager.switchCameraInputDeviceToFront()
        }else{
            self.recordingManager.swithCameraInputDeviceToBack()
            cameraState = .Rear
          
            
        }
        
//        if (sender.selected) {
//            _flashBtn.selected = NO;
//            [self.recordingManager closeFlashLight];
//            [self.recordingManager switchCameraInputDeviceToFront];
//        } else {
//            [self.recordingManager swithCameraInputDeviceToBack];
//        }

    }
    
    
    //MARK:-
    
    
    func updateRecordingProgress(_ progress: CGFloat)
    {
        
    }


    
    func decreaseTimer()
    {
        print(videoInterval)
        if videoInterval == 0 {
           self.stopVideo()
        }else{
            self.videoInterval = self.videoInterval - 1

        }
    }
    
    
    
    
    func stopVideo(){
    
    
    videoState = .Stopped
    btnCamera.isSelected = false
    self.videoInterval = 59
    recordingManager.stopRecoring()
    self.timer.invalidate()
    }
    
}
