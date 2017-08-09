//
//  LFKRulerSlider.swift
//  LFKUIComponent
//
//  Created by alexlee on 2017/7/19.
//  Copyright © 2017年 Lifake. All rights reserved.
//

import UIKit

@IBDesignable public class LFKRulerSlider:UIView,UIScrollViewDelegate{
    
    /// 刻度板宽
    @IBInspectable var rulerWidth: CGFloat = 240{
        didSet{
            updateWidth()
        }
    }
    /// 刻度板高
    @IBInspectable var rulerHeight: CGFloat = 10{
        didSet{
            self.rulerHeightConstrait.constant = rulerHeight
        }
    }
    /// 刻度板图片
    @IBInspectable var rulerImage: UIImage?{
        didSet{
//            self.image.backgroundColor = UIColor(patternImage: rulerImage.re!)
        }
    }
    /// 刻度单位数（有多少格子）
    @IBInspectable var rulerUnit: Int = 24
    /// 刻度重复数（平铺多少把尺子）
    @IBInspectable var rulerRepeat: Int = 1{
        didSet{
            updateWidth()
        }
    }
    /// 阴影图片（左）
    @IBInspectable var shaddowImage: UIImage?{
        didSet{
            if let img = shaddowImage{
                //左边
                shaddowLeftImg.image = img
                
                //右边
                //翻转图片的方向
                let flipImageOrientation = (img.imageOrientation.rawValue + 4) % 8
                //翻转图片
                let flipImage =  UIImage(cgImage:img.cgImage!,
                                         scale:img.scale,
                                         orientation:UIImageOrientation(rawValue: flipImageOrientation)!
                )
                shaddowRightImg.image = flipImage
            }
        }
    }
    /// 刻度板图片
    @IBInspectable var lineColor: UIColor = UIColor.white{
        didSet{
            self.line.backgroundColor = lineColor
        }
    }
    
    
    @IBOutlet weak var line: UIView!
    @IBOutlet weak var image: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var widthConstrait: NSLayoutConstraint!
    @IBOutlet weak var rulerWidthConstrait: NSLayoutConstraint!
    @IBOutlet weak var rulerHeightConstrait: NSLayoutConstraint!
    @IBOutlet weak var shaddowLeftImg: UIImageView!
    @IBOutlet weak var shaddowRightImg: UIImageView!
    
    func updateWidth(){
//        self.rulerWidthConstrait.constant = rulerWidth * self.rulerRepeat
//        if let img = self.image.image{
//            img.resizableImage(withCapInsets: UIEdgeInsets(top: <#T##CGFloat#>, left: <#T##CGFloat#>, bottom: <#T##CGFloat#>, right: <#T##CGFloat#>)
//        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupSubviews()
    }
    
    func setupSubviews() {
        let bundle = Bundle.init(for: type(of: self))
        let nib = UINib(nibName: "LFKRulerSlider", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        addSubview(view)
        self.scrollView.delegate = self
        scrollView.decelerationRate = 0.9
    }
    
    override public func layoutSubviews() {
        self.subviews[0].frame = self.bounds
        let width = self.bounds.width
        widthConstrait.constant = self.rulerWidthConstrait.constant + width
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(scrollView.decelerationRate)
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        autoAlignRuler()
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        autoAlignRuler()
    }
    
    func autoAlignRuler(){
        let x = scrollView.contentOffset.x
        let unitWidth = self.rulerWidthConstrait.constant / CGFloat(rulerUnit)
        let xmod = CGFloat(fmodf(Float(x), Float(unitWidth)))
        var targetOffset = scrollView.contentOffset.x
        print("\(xmod),\(unitWidth)")
        if xmod <= (unitWidth / 2){
            targetOffset -= xmod
        }else{
            targetOffset += unitWidth-xmod
        }
        UIView.animate(withDuration: 0.05, animations: {
            self.scrollView.contentOffset.x = targetOffset
        })
    }
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print(1)
    }
}
