//
//  GoNetAlertContainerView.swift
//  GoNetSwift
//
//  Created by Abraham Lopez on 3/14/22.
//

import UIKit

class GoNetAlertContainerView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // This method will let us configure a UIView to be reusable the way we want
    private func configure() {
        backgroundColor       = .systemBackground
        layer.cornerRadius    = 16
        layer.borderWidth     = 2
        layer.borderColor     = UIColor.white.cgColor
        translatesAutoresizingMaskIntoConstraints = false
    }

}
