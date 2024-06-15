//
//  PageControl.swift
//  TelegrameClone
//
//  Created by Lubomyr Chorniak on 14.06.2024.
//

import UIKit

class PageControl: UIView {
    
    private let stackView = UIStackView()
    private var pagers = [UIView]()
    
    public var selectedPage = 0 {
        didSet {
            UIView.animate(withDuration: 0.2) {
                self.pagers[oldValue].alpha = 0.4
            }
            pagers[selectedPage].alpha = 1
        }
    }
    
    init(numberOfPages: Int) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.distribution = .fill
        
        for _ in 0..<numberOfPages {
            let pager = UIView()
            pagers.append(pager)
            pager.backgroundColor = .white
            pager.alpha = 0.4
            pager.translatesAutoresizingMaskIntoConstraints = false
            pager.layer.cornerRadius = 5
            pager.snp.makeConstraints { $0.size.equalTo(10) }
            stackView.addArrangedSubview(pager)
        }
        
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
