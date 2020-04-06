//
//  SegmentedControlView.swift
//  Clocks
//
//  Created by Brian Cooke on 3/29/20.
//  Copyright © 2020 Brian Cooke. All rights reserved.
//

import UIKit

@IBDesignable
public class SegmentedControlView: UIStackView  {
    
    var buttonArray: [UIButton] = []
    
    @IBInspectable var TextColor : UIColor = UIColor.black
    
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
    
    var selectedSegmentIndex : Int = 0
    {
        didSet
        {
            
            redrawSelectionIndicators()
        }
    }
    
    func redrawSelectionIndicators() -> Void
    {
        var i = 0
        for aSubview in arrangedSubviews
        {
            if let stackView = aSubview as? UIStackView
            {
                let selectedIndicatorView = stackView.arrangedSubviews[0]
                selectedIndicatorView.backgroundColor = (i == selectedSegmentIndex) ? SelectedIndicatorColor : UnselectedIndicatorColor
                i += 1
            }
        }
    }
    @IBInspectable var SegmentTitles : String = ""
        {
        didSet
        {
            let newSegmentTitles = SegmentTitles.components(separatedBy: ";")
            distribution = .fillEqually
            alignment = .top
            self.buttonArray.removeAll()
            for subView in self.subviews
            {
                removeArrangedSubview(subView)
            }
            
            for title in newSegmentTitles
            {
                addArrangedSubview(CreateSubView(Title: title))
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
