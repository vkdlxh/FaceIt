//
//  ViewController.swift
//  FaceIt
//
//  Created by 김태현 on 2017. 9. 14..
//  Copyright © 2017년 JSJ. All rights reserved.
//

import UIKit

class FaceViewController: UIViewController {
    
    var expression = FacialExpression(eyes: .Open, eyeBrows: .Normal, mouth: .Smile) {
        didSet{
            updateUI()
        }
    }
    
    @IBOutlet weak var faceView: FaceView! { didSet{ updateUI() } }
    //outlet에 연결되는 직후 faceView를 지배할 수 있기 때문에 이곳에도 didSet으로 updateUI() 함수를 호출해줘야 한다.
    
    private var mouthCurvatures = [FacialExpression.Mouth.Frown:-1.0, .Grin:0.5, .Smile:1.0, .Smirk:-0.5, .Neutral:0.0 ]
    private var eyeBrowsTilts = [FacialExpression.EyeBrows.Normal:0.0, .Relaxed:0.5, .Furrowed:-0.5]
    
    private func updateUI(){
        switch expression.eyes {
        case .Open: faceView.eyesOpen = true
        case .Closed: faceView.eyesOpen = false
        case .Squinting: faceView.eyesOpen = false
        }
        faceView.mouthCurature = mouthCurvatures[expression.mouth] ?? 0.0 // 딕셔너리에서 찾고자 하는 값 없으면 0.0 반환
        faceView.eyeBrowTilt = eyeBrowsTilts[expression.eyeBrows] ?? 0.0
        
        
    }

}

