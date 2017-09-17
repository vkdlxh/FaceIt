//
//  FaceView.swift
//  FaceIt
//
//  Created by 김태현 on 2017. 9. 17..
//  Copyright © 2017년 JSJ. All rights reserved.
//

import UIKit

class FaceView: UIView {
    
    override func drawRect(rect: CGRect){
        
        // bounds : 본인의 좌표시스템 안에서 그릴 직사각형
        // radius(반경) : View의 넓이와 높이의 최소값과 같게 한다
        let skullRadius = min(bounds.size.width, bounds.size.height) / 2 // 2를 나누는 것은 반지름
        // 얼굴(skull)의 중앙(center)
        let skullCenter = CGPoint(x: bounds.midX, y: bounds.midY)
        
        // radians(라디안, 호도법) : 원 하나를 그릴때 0에서 2π 사이의 값으로 표기
        let skull = UIBezierPath(arcCenter: skullCenter, radius: skullRadius, startAngle: 0.0, endAngle: CGFloat(2*M_PI), clockwise: false)

        skull.lineWidth = 5.0 // lineWidth : 선굵기
        UIColor.blueColor().set() // set()은 setFill, setStroke을 모두 설정하는 것
        skull.stroke() // 설정에 따라 선을 그림
    }

}
