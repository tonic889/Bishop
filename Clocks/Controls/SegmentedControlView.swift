//
//  SegmentedControlView.swift
//  Clocks
//
//  Created by Brian Cooke on 3/29/20.
//  Copyright © 2020 Brian Cooke. All rights reserved.
//

import UIKit

@IBDesignable
public class SegmentedControlView: UIControl  {
    
    var mainStackView = UIStackView()
    var buttonArray: [UIButton] = []
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        initView()
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initView()
    }
    
    func initView() -> Void {
        addSubview(mainStackView)
        self.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        mainStackView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }
    
    @IBInspectable var TextColor : UIColor = UIColor.black
        {
        didSet {
            setButtonColor()
        }
    }
    
    @IBInspectable var SelectedIndicatorColor : UIColor = UIColor.white
        {
        didSet
        {
            redrawSelectionIndicators()
        }
    }
    @IBInspectable var UnselectedIndicatorColor : UIColor = UIColor.gray
        {
        didSet
        {
            redrawSelectionIndicators()
        }
    }
    
    
    func setButtonColor() -> Void
    {
        for aButton in buttonArray
        {
            aButton.setTitleColor(TextColor, for: .normal)
        }
        
    }
    var selectedSegmentIndex : Int = 0
    {
        didSet
        {
            self.sendActions(for: .valueChanged)
            redrawSelectionIndicators()
        }
    }
    
    func redrawSelectionIndicators() -> Void
    {
        var i = 0
        for aSubview in mainStackView.arrangedSubviews
        {
            if let stackView = aSubview as? UIStackView
            {
                let selectedIndicatorView = stackView.arrangedSubviews[0]
                selectedIndicatorView.backgroundColor = (i == selectedSegmentIndex) ? SelectedIndicatorColor : UnselectedIndicatorColor
                i += 1
            }
        }
    }
    
    var SegmentFonts : [UIFont] = [LightFont!, LightFont!]
    {
        didSet
        {
            var i = 0
            for aButton in buttonArray {
                aButton.titleLabel?.font = SegmentFonts[i]
                i += 1
            }
        }
    }
    @IBInspectable var SegmentTitles : String = ""
        {
        didSet
        {
            let newSegmentTitles = SegmentTitles.components(separatedBy: ";")
            mainStackView.distribution = .fillEqually
            mainStackView.alignment = .top
            self.buttonArray.removeAll()
            for subView in mainStackView.subviews
            {
                mainStackView.removeArrangedSubview(subView)
            }
            
            for title in newSegmentTitles
            {
                mainStackView.addArrangedSubview(CreateSubView(Title: title))
            }
            
            selectedSegmentIndex = 0
        }
    }
    
    func CreateSubView(Title : String) -> UIView
    {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        
        let selectedIndicatorView = UIView()
        selectedIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        selectedIndicatorView.backgroundColor = self.UnselectedIndicatorColor
        
        let button = UIButton()
        button.setTitle(Title, for: .normal)
        button.tintColor = self.TextColor
        button.addTarget(self, action: #selector(self.buttonClicked), for: .touchUpInside)
        
        stackView.addArrangedSubview(selectedIndicatorView)
        stackView.addArrangedSubview(button)
        buttonArray.append(button)
        
        selectedIndicatorView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 1).isActive = true
        selectedIndicatorView.heightAnchor.constraint(equalToConstant: CGFloat(5)).isActive = true
        return stackView
    }
    
    @objc func buttonClicked(sender: UIButton!) {
        self.selectedSegmentIndex = self.buttonArray.firstIndex(of: sender) ?? 0
    }
    
}
