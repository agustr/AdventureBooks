//
//  BookView.swift
//  aevintyri
//
//  Created by Agust Rafnsson on 2020-12-03.
//  Copyright © 2020 Agust Rafnsson. All rights reserved.
//

import UIKit

class BookView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        self.backgroundColor = UIColor.green
    }
    
    func setupConstraints() {
        //
    }
}
