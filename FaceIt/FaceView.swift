//
//  FaceView.swift
//  FaceIt
//
//  Created by 김태현 on 2017. 9. 17..
//  Copyright © 2017년 JSJ. All rights reserved.
//

import UIKit

class FaceView: UIView {
    
    // 두개골의 스케일 조절(90% 크기 유지)
    var scale: CGFloat = 0.90
    
    // bounds : 본인의 좌표시스템 안에서 그릴 직사각형
    // radius(반경) : View의 넓이와 높이의 최소값과 같게 한다
    var skullRadius : CGFloat {
        return min(bounds.size.width, bounds.size.height) / 2 * scale // 2를 나누는 것은 반지름
    }
    // 얼굴(skull)의 중앙(center)
    var skullCenter: CGPoint {
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }
    // 값을 가져오기만 하는 Computed Property라면 get {}을 쓸 필요가 없다.
    
    // 얼굴의 비율
    private struct Ratios {
        static let SkullRadiusToEyeOffset: CGFloat = 3      // 두개골반경에서 눈 사이의 비율
        static let SkullRadiusToEyeRadius: CGFloat  = 10    // 눈 반경
        static let SkullRadiusToMouthWidth: CGFloat = 1     // 입 너비
        static let SkullRadiusToMouthHeight: CGFloat = 3    // 입 높이
        static let SkullRadiusToMouthOffset: CGFloat = 3    // 두개골반경에서 입 사이의 비율
    }
    
    private enum Eye {
        case Left
        case Right
    }
    
    private func pathForCircleCenteredAtPoint(midPoint: CGPoint, withRadius radius: CGFloat) -> UIBezierPath {
        let path = UIBezierPath(
            arcCenter: midPoint,
            radius: radius,
            startAngle: 0.0,
            endAngle: CGFloat(2*M_PI), // radians(라디안, 호도법) : 원 하나를 그릴때 0에서 2π 사이의 값으로 표기
            clockwise: false
        )
        path.lineWidth = 5.0 // lineWidth : 선굵기
        return path
    }
    
    private func getEyeCenter(eye: Eye) -> CGPoint {
        let eyeOffset = skullRadius / Ratios.SkullRadiusToEyeOffset
        var eyeCenter = skullCenter
        eyeCenter.y -= eyeOffset // y축은 -가 위로 올라가는 것.
        switch eye {
        case .Left: eyeCenter.x -= eyeOffset
        case .Right: eyeCenter.x += eyeOffset
        }
        return eyeCenter
    }
    
    private func pathForEye(eye: Eye) -> UIBezierPath {
        // 눈의 반경
        let eyeRadius = skullRadius / Ratios.SkullRadiusToEyeRadius
        let eyeCenter = getEyeCenter(eye)
        return pathForCircleCenteredAtPoint(eyeCenter, withRadius: eyeRadius)
    }
    
    override func drawRect(rect: CGRect){

        UIColor.blueColor().set() // set()은 setFill, setStroke을 모두 설정하는 것
        pathForCircleCenteredAtPoint(skullCenter, withRadius: skullRadius).stroke() // 설정에 따라 선을 그림
        pathForEye(.Left).stroke()
        pathForEye(.Right).stroke()
    }

}
