//
//  FaceView.swift
//  FaceIt
//
//  Created by 김태현 on 2017. 9. 17..
//  Copyright © 2017년 JSJ. All rights reserved.
//

import UIKit

@IBDesignable // 인터페이스 빌더에 자동으로 나타내줌.
class FaceView: UIView {
    
    @IBInspectable  // Inspector 설정창에서 볼 수 있음 (* IBInspectable는 타입을 추론할 수 없기 때문에 타입을 반드시 명시해줘야함)
    var scale: CGFloat = 0.90 { didSet { setNeedsDisplay() } } // 프로퍼티 옵저버. setNeedsDisplay는 다시 그림을 요청
    @IBInspectable
    var mouthCurature: Double = 1.0 { didSet { setNeedsDisplay() } }
    // 입 굽은 비율. 1 함박웃음, -1 완전 찡그림
    @IBInspectable
    var eyesOpen: Bool = false { didSet { setNeedsDisplay() } }
    @IBInspectable
    var eyeBrowTilt:Double = 0.0 { didSet { setNeedsDisplay() } }
    // 눈썹 기울기. 1 눈썹 완전히 펴짐, -1 완전 찡그림
    @IBInspectable
    var color: UIColor = UIColor.blueColor() { didSet { setNeedsDisplay() } }
    @IBInspectable
    var lineWidth: CGFloat = 5.0 { didSet { setNeedsDisplay() } }

    func changeScale(recognizer: UIPinchGestureRecognizer) {
        switch recognizer.state {
        case .Changed, .Ended:
            scale *= recognizer.scale
            recognizer.scale = 1.0
        default: break
        }
    }
    
    
    // bounds : 본인의 좌표시스템 안에서 그릴 직사각형
    // radius(반경) : View의 넓이와 높이의 최소값과 같게 한다
    private var skullRadius : CGFloat {
        return min(bounds.size.width, bounds.size.height) / 2 * scale // 2를 나누는 것은 반지름
    }
    // 얼굴(skull)의 중앙(center)
    private var skullCenter: CGPoint {
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
        static let SkullRadiusToBrowOffset: CGFloat = 5     // 두개골반경에서 눈썹의 상대적 위치
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
        path.lineWidth = lineWidth // lineWidth : 선굵기
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
        if eyesOpen {   // 눈을 뜨고 있을 때
            return pathForCircleCenteredAtPoint(eyeCenter, withRadius: eyeRadius)
        } else {        // 눈을 감고 있을 때 : 선을 사용
            let path = UIBezierPath()
            path.moveToPoint(CGPoint(x: eyeCenter.x - eyeRadius, y: eyeCenter.y))
            path.addLineToPoint(CGPoint(x: eyeCenter.x + eyeRadius, y: eyeCenter.y))
            path.lineWidth = lineWidth
            return path
        }
        
    }
    
    private func pathForMouth() -> UIBezierPath {
        let mouthWidth = skullRadius / Ratios.SkullRadiusToMouthWidth
        let mouthHeight = skullRadius / Ratios.SkullRadiusToMouthHeight
        let mouthOffset = skullRadius / Ratios.SkullRadiusToMouthOffset
        
        // 입을 담을 사각형
        let mouthRect = CGRect(x: skullCenter.x - mouthWidth/2, y: skullCenter.y + mouthOffset, width: mouthWidth, height: mouthHeight)
        
        let smileOffset = CGFloat(max(-1, min(mouthCurature, 1))) * mouthRect.height
        let start = CGPoint(x: mouthRect.minX, y: mouthRect.minY)
        let end = CGPoint(x: mouthRect.maxX, y: mouthRect.minY)
        let cp1 = CGPoint(x: mouthRect.minX + mouthRect.width / 3, y: mouthRect.minY + smileOffset)
        let cp2 = CGPoint(x: mouthRect.maxX - mouthRect.width / 3, y: mouthRect.minY + smileOffset)
        // 커브포인트(cp)는 밑변의 1/3 지점이니까 /3을 함.
        
        let path = UIBezierPath()
        path.moveToPoint(start) // 시작 포인트
        path.addCurveToPoint(end, controlPoint1: cp1, controlPoint2: cp2)
        path.lineWidth = lineWidth
        
        return path
    }
    
    private func pathForBrow(eye: Eye) -> UIBezierPath {
        var tilt = eyeBrowTilt
        switch eye {
        case .Left: tilt *= -1.0
        case .Right: break
        }
        var browCenter = getEyeCenter(eye)
        browCenter.y -= skullRadius / Ratios.SkullRadiusToBrowOffset
        let eyeRadius = skullRadius / Ratios.SkullRadiusToEyeRadius
        let tiltOffset = CGFloat(max(-1, min(tilt, 1))) * eyeRadius / 2
        let browStart = CGPoint(x: browCenter.x - eyeRadius, y: browCenter.y - tiltOffset)
        let browEnd = CGPoint(x: browCenter.x + eyeRadius, y: browCenter.y + tiltOffset)
        let path = UIBezierPath()
        path.moveToPoint(browStart)
        path.addLineToPoint(browEnd)
        path.lineWidth = lineWidth
        return path
        
    }
    
    override func drawRect(rect: CGRect){

        color.set() // set()은 setFill, setStroke을 모두 설정하는 것
        pathForCircleCenteredAtPoint(skullCenter, withRadius: skullRadius).stroke() // 설정에 따라 선을 그림
        pathForEye(.Left).stroke()
        pathForEye(.Right).stroke()
        pathForMouth().stroke()
        pathForBrow(.Left).stroke()
        pathForBrow(.Right).stroke()
    }

}
