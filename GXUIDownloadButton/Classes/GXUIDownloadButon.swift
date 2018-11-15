//
//  GXUIDownloadButon.swift
//  GXUIDownloadButton
//
//  Created by Majid Hatami Aghdam on 11/14/18.
//  Copyright © 2018 Majid Hatami Aghdam. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class GXUIDownloadButon: UIButton {
    
    @IBInspectable var spinnerThickness: CGFloat = 2 {
        didSet {
            self.progressSpiner.thickness = self.progress
        }
    }
    
    @IBInspectable var progress: CGFloat = 0.1 {
        didSet {
            self.progressSpiner.progress = self.progress
        }
    }
    
    @IBInspectable var spinnerColor: UIColor = UIColor.white {
        didSet {
            spiner.spinnerColor = spinnerColor
        }
    }
    
    @IBInspectable var progressSpinnerColor: UIColor = UIColor.blue {
        didSet {
            self.progressSpiner.spinnerColor = self.progressSpinnerColor
        }
    }

    enum GXUIDownloadButonState{
        case normal
        case download
        case prepareForDownload
        case downloading
    }
    
    var GXState:GXUIDownloadButonState = .normal {
        didSet{
            if oldValue == self.GXState { return }
            self.updateUI()
        }
    }
    
    
    func updateUI(){
        self.spiner.thickness = self.spinnerThickness
        self.progressSpiner.thickness = self.spinnerThickness
        
        switch self.GXState {
        case .normal:
            self.progressSpiner.progress = 0
            self.spiner.progress = 0
            self.spiner.isHidden = true
            self.progressSpiner.isHidden = true
            self.titleLabel?.isHidden = false
            self.imageView?.isHidden = false
            break;
        case .download:
            self.spiner.progress = 0
            self.progressSpiner.progress = 0
            self.spiner.isHidden = true
            self.progressSpiner.isHidden = true
            self.titleLabel?.isHidden = false
            self.imageView?.isHidden = false
            
            break;
        case .prepareForDownload:
            self.spiner.progress = 0.9
            self.progressSpiner.progress = 0
            self.spiner.isHidden = false
            self.progressSpiner.isHidden = true
            self.spiner.animation()
            self.titleLabel?.isHidden = true
            self.imageView?.isHidden = true
            break
        case .downloading:
            self.spiner.progress = 1
            self.progressSpiner.progress = self.progress
            self.spiner.stopAnimation()
            self.spiner.isHidden = false
            self.progressSpiner.isHidden = false
            self.titleLabel?.isHidden = true
            self.imageView?.isHidden = true
            break;
        }
    }
    
    fileprivate lazy var spiner:mGXSpinerLayer! = {
        let s = mGXSpinerLayer(frame: self.frame, .spin)
        self.layer.addSublayer(s)
        return s
    }()
    fileprivate lazy var progressSpiner:mGXSpinerLayer! = {
        let s = mGXSpinerLayer(frame: self.frame, .progress)
        self.layer.addSublayer(s)
        return s
    }()
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.spiner.updateShape()
        self.progressSpiner.updateShape()
        updateUI()
    }
    
    
    func setup(){
        self.clipsToBounds = true
        spiner.mode = .spin
        spiner.spinnerColor = spinnerColor
        self.spiner.progress = 0.9
        self.spiner.thickness = self.spinnerThickness
        
        self.progressSpiner.mode = .progress
        progressSpiner.spinnerColor = self.progressSpinnerColor
        progressSpiner.progress = self.progress
        self.progressSpiner.thickness = self.spinnerThickness
        
        if self.GXState == .normal || self.GXState == .download {
            self.spiner.isHidden = true
            self.spiner.stopAnimation()
            self.progressSpiner.isHidden = true
            self.progressSpiner.stopAnimation()
        }
    }
    
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.setup()
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init!(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.setup()
    }
    
    fileprivate class mGXSpinerLayer: CAShapeLayer {
        
        enum GXSpinnerType{
            case progress
            case spin
        }
        var thickness:CGFloat = 3 {
            didSet{
                self.updateShape()
            }
        }
        var mode:GXSpinnerType = .spin
        var progress:CGFloat = 0.8{
            didSet{
                self.updateShape()
            }
        }
        fileprivate var lastProgress:CGFloat = 0
        var spinnerColor = UIColor.white {
            didSet {
                strokeColor = spinnerColor.cgColor
            }
        }
        
        init(frame:CGRect,_ mode:GXSpinnerType) {
            super.init()
            self.mode = mode
            self.frame = frame
            self.updateShape()
        }
        
        func updateShape(){
            
            self.frame = CGRect(x: 0, y: 0, width: frame.height, height: frame.height)
            let arcCenter = CGPoint(x: frame.height / 2, y: bounds.midY)
            
            
            let radius:CGFloat = (frame.height / 2) * 0.8
            let startAngle:CGFloat =  0 - (CGFloat.pi / 2)
//            let endAngle:CGFloat = CGFloat.pi * 2 - (CGFloat.pi / 2)
            let endAngle:CGFloat =  self.progress * 2 * CGFloat.pi + startAngle;
            let clockwise: Bool = true
            
            self.path = UIBezierPath(arcCenter: arcCenter, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: clockwise).cgPath
            
            self.fillColor = nil
            self.strokeColor = spinnerColor.cgColor
            self.lineWidth = self.thickness
            
            //self.isHidden = true
            
            let fromValue = (1 * lastProgress) / self.progress;
            if(self.progress != lastProgress){
                let anim = animationForStartAngle(startAngle: fromValue)
                self.add(anim, forKey: anim.keyPath)
            }
            lastProgress = self.progress;
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override init(layer: Any) {
            super.init(layer: layer)
        }
        
        func animation() {
            //self.isHidden = false
            let rotate = CABasicAnimation(keyPath: "transform.rotation.z")
            rotate.fromValue = 0
            rotate.toValue = Double.pi * 2
            rotate.duration = 1.0
            rotate.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
            
            rotate.repeatCount = HUGE
            rotate.fillMode = CAMediaTimingFillMode.forwards
            rotate.isRemovedOnCompletion = false
            self.add(rotate, forKey: rotate.keyPath)
            
        }
        
        func stopAnimation() {
            self.isHidden = true
            self.removeAllAnimations()
        }
        
        private func animationForStartAngle(startAngle:CGFloat)->CABasicAnimation {
            let downloadingAnimation = CABasicAnimation.init(keyPath: "strokeEnd")
            downloadingAnimation.duration = 0.3;
            downloadingAnimation.fromValue = startAngle
            downloadingAnimation.toValue = 1.0
            return downloadingAnimation
        }
    }


}

