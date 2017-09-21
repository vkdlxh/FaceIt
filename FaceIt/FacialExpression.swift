//
//  FacialExpression.swift
//  FaceIt
//
//  Created by 김태현 on 2017. 9. 19..
//  Copyright © 2017년 JSJ. All rights reserved.
//

import Foundation

struct FacialExpression {
    
    enum Eyes: Int {
        case Open
        case Closed
        case Squinting  // 가늘게 뜬 눈
    }
    
    enum EyeBrows: Int {
        case Relaxed
        case Normal
        case Furrowed
    
        func moreRelaxedBrow() -> EyeBrows {
            return EyeBrows(rawValue: rawValue - 1) ?? .Relaxed
        }
        func moreFurrowedBrow() -> EyeBrows {
            return EyeBrows(rawValue: rawValue + 1) ?? .Furrowed
        }
    }
    
    enum Mouth: Int {
        case Frown      // 찌푸린
        case Smirk      // 실실 웃는
        case Neutral    // 평상시
        case Grin       // 활짝 웃는
        case Smile      // 미소 짓는
        
        func sadderMouth() -> Mouth {
            return Mouth(rawValue: rawValue - 1) ?? .Frown
        }
        func happierMouth() -> Mouth {
            return Mouth(rawValue: rawValue + 1) ?? .Smile
        }
    }
    
    var eyes: Eyes
    var eyeBrows: EyeBrows
    var mouth: Mouth
    
}
