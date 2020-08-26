//
//  OrderItemTableViewCell.swift
//  FlowerShop
//
//  Created by Razvan Cozma on 26/08/2020.
//  Copyright © 2020 Razvan Cozma. All rights reserved.
//

import UIKit

class OrderItemTableViewCell: UITableViewCell {
    private let padding: CGFloat = Constants.UI.defaultPadding
    lazy var productNameLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        return label
    }()
    
    lazy var deliverToLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor =  Constants.UI.grayColor
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        return label
    }()
    
    lazy var orderDateLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.textColor = Constants.UI.grayColor
        return label
    }()
    
    lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
//        label.textColor = UIColor(red: 80/255, green: 174/255, blue: 85/255, alpha: 1)
        return label
    }()
    
    lazy var statusImage: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        imageView.image = UIImage(named: "icon-checked")
        return imageView
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
            .topAnchor(equalTo: contentView.topAnchor, constant: halfPadding)
        .bottomAnchor(equalTo: contentView.bottomAnchor, constant: -halfPadding)
//        .heightAnchor(equalTo: 100)
        
        cornerBackgroundView.addSubview(statusImage)
        statusImage.leadingAnchor(equalTo: cornerBackgroundView.leadingAnchor, constant: halfPadding)
            .centerYAnchor(equalTo: cornerBackgroundView.centerYAnchor)
            .widthAnchor(equalTo: 30)
            .heightAnchor(equalTo: 30)
        
        cornerBackgroundView.addSubview(priceLabel)
        priceLabel.trailingAnchor(equalTo: cornerBackgroundView.trailingAnchor, constant: -10)
            .centerYAnchor(equalTo: statusImage.centerYAnchor)
        
        cornerBackgroundView.addSubview(productNameLabel)
        productNameLabel.leadingAnchor(equalTo: statusImage.trailingAnchor, constant: 7)
            .trailingAnchor(lessThanOrEqualTo: priceLabel.leadingAnchor)
            .topAnchor(equalTo: cornerBackgroundView.topAnchor, constant: halfPadding)
        
        cornerBackgroundView.addSubview(deliverToLabel)
        deliverToLabel.leadingAnchor(equalTo: productNameLabel.leadingAnchor)
            .trailingAnchor(lessThanOrEqualTo: priceLabel.leadingAnchor)
            .topAnchor(equalTo: productNameLabel.bottomAnchor)
        
        cornerBackgroundView.addSubview(orderDateLabel)
        orderDateLabel.leadingAnchor(equalTo:  productNameLabel.leadingAnchor)
            .trailingAnchor(lessThanOrEqualTo: priceLabel.leadingAnchor)
            .topAnchor(equalTo: deliverToLabel.bottomAnchor)
            .bottomAnchor(equalTo: cornerBackgroundView.bottomAnchor, constant: -halfPadding)
        
        priceLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        orderDateLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        deliverToLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        productNameLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    }
    
    func update(item: Order, dateFormatter: DateFormatter){
        productNameLabel.text = item.description
        deliverToLabel.text = item.deliverTo
        orderDateLabel.text = dateFormatter.string(from: item.created ?? Date())
        priceLabel.text = "\(item.price ?? 0) USD"
        statusImage.image = UIImage(named: item.deliveredOn != nil ? "icons-checked" : "icons-delivery")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
