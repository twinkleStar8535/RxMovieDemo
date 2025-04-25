//
//  CustomSegent.swift
//  RxMovieDemoApp
//
//  Created by YcLin on 2025/3/20.
//

import UIKit
import SnapKit
import RxTheme

protocol CustomSegmentDelegate:AnyObject {
    func change(to index:Int)
}

class CustomSegent: UIView{

   weak var delegate:CustomSegmentDelegate?

    var segments:[UIButton]!
    private var segmentTitles:[String]! {
        didSet{
            setTitles(titles: segmentTitles)
        }
    }
    var stackView:UIStackView!
    private var selectorView = UIView()
    private var selectedIndex:Int = 0
    private var selectorWidth :CGFloat = 0


    var textColor:UIColor = UIColor.white
    var selectTextColor:UIColor = .clear
    var selectViewColor:UIColor = .clear

    convenience init(frame:CGRect,segmentTitles:[String] = []) {
        self.init(frame: frame)
        self.segmentTitles = segmentTitles
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.backgroundColor = .clear
        updateView()
    }

    func setSegmentStyleColor(color:UIColor ,unselectColor:UIColor) {
        selectTextColor = color
        selectViewColor = color
        textColor = unselectColor
    }



     func updateView() {
        createCustomSegemnt()
        configFullSegmentView()
        configSelectorView()
    }

    private func createCustomSegemnt(){
        segments = [UIButton]()
        segments.removeAll()
        subviews.forEach({$0.removeFromSuperview()})

        for segTitle in segmentTitles {
             let segmentBtn = UIButton(type: .system)
             segmentBtn.setTitle(segTitle, for: .normal)
             segmentBtn.addTarget(self,
                                 action:#selector(CustomSegent.segmentAction(sender:))
                                 , for: .touchUpInside)
             segmentBtn.setTitleColor(self.textColor, for: .normal)
             segments.append(segmentBtn)
        }
        segments[0].setTitleColor(selectTextColor, for: .normal)
    }

    private func configFullSegmentView() {
        stackView = UIStackView(arrangedSubviews: segments)
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        addSubview(stackView)
        stackView.frame = self.bounds
    }

    private func configSelectorView() {
        selectorWidth = (frame.width / CGFloat(self.segmentTitles.count)) - 60

        selectorView = UIView(frame: CGRect(x: 30, y: self.frame.height - 3, width:selectorWidth, height: 3))
        selectorView.backgroundColor = selectViewColor

        selectorView.clipsToBounds = true
        selectorView.layer.cornerRadius = 2
        selectorView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        addSubview(selectorView)
    }

    private func setTitles(titles:[String]){
        segments.forEach { segBtn in
            segmentTitles.forEach { eachTitle in
                segBtn.setTitle(eachTitle, for: .normal)
            }
        }
    }

    @objc func segmentAction(sender:UIButton) {

        for (segmentIndex,segment) in segments.enumerated() {
            segment.setTitleColor(textColor, for: .normal)

            if segment == sender {
                let selectorPosition = frame.width/CGFloat(segmentTitles.count) * CGFloat(segmentIndex)

                selectedIndex = segmentIndex
                delegate?.change(to:segmentIndex) // 結果

                UIView.animate(withDuration: 0.3) {
                    self.selectorView.frame.origin.x = selectorPosition + (sender.bounds.width - self.selectorWidth) / 2
                }

                segment.setTitleColor(selectTextColor, for: .normal)
            }

        }
    }

}
