//
//  OrderNoteTableViewCell.swift
//  FlowerShop
//
//  Created by Razvan Cozma on 26/08/2020.
//  Copyright © 2020 Razvan Cozma. All rights reserved.
//

import UIKit

class OrderNoteTableViewCell: UITableViewCell {
    private let padding: CGFloat = Constants.UI.defaultPadding
    lazy var noteTitleLable: UILabel = {
        let label = UILabel()
        label.text = "Note"
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.textColor =  .black
        return label
    }()
    
    lazy var noteContentLable: UILabel = {
        let label = UILabel()
        label.text = ""
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.textColor = Constants.UI.grayColor
        return label
    }()
    
    lazy var cornerBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8.0
        view.clipsToBounds = true
        self.layer.shadowOffset = CGSize(width: 0, height: 2.5)
        self.layer.shadowRadius = 2.5
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOpacity = 0.4
        return view
    }()
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.clear
        self.selectionStyle = .none
        let halfPadding = padding / 2
        self.contentView.addSubview(cornerBackgroundView)
        cornerBackgroundView.leadingAnchor(equalTo: contentView.leadingAnchor, constant: padding)
            .trailingAnchor(equalTo: contentView.trailingAnchor, constant: -padding)
            .topAnchor(equalTo: contentView.topAnchor, constant: padding)
            .bottomAnchor(equalTo: contentView.bottomAnchor)
        
        cornerBackgroundView.addSubview(noteTitleLable)
        noteTitleLable.leadingAnchor(equalTo: cornerBackgroundView.leadingAnchor, constant: halfPadding)
            .trailingAnchor(equalTo: cornerBackgroundView.trailingAnchor, constant: -halfPadding)
            .topAnchor(equalTo: cornerBackgroundView.topAnchor, constant: padding)
//            .bottomAnchor(equalTo: contentView.bottomAnchor, constant: -padding)
        
        cornerBackgroundView.addSubview(noteContentLable)
        noteContentLable.leadingAnchor(equalTo: noteTitleLable.leadingAnchor)
            .trailingAnchor(equalTo: cornerBackgroundView.trailingAnchor, constant: -halfPadding)
            .topAnchor(equalTo: noteTitleLable.bottomAnchor, constant: halfPadding)
            .bottomAnchor(equalTo: contentView.bottomAnchor, constant: -padding)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
