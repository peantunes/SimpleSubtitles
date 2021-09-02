//
//  SubtitleCollectionViewCell.swift
//  tvos-full-app
//
//  Created by Pedro Antunes on 19/07/2021.
//  Copyright © 2021 EaselTV. All rights reserved.
//

import UIKit

public protocol Reusable: AnyObject {
  /// The reuse identifier to use when registering and later dequeuing a reusable cell
  static var reuseIdentifier: String { get }
}

public extension Reusable {
  /// By default, use the name of the class as String for its reuseIdentifier
  static var reuseIdentifier: String {
    return String(describing: self)
  }
}

class SubtitleCollectionViewCell: UICollectionViewCell, Reusable {
    private let hStackView: UIStackView!
    private let selectedIcon: UIImageView!
    private let label: UILabel!
    
    private let lowAlpha: CGFloat = 0.6
    
    override init(frame: CGRect) {
        hStackView = UIStackView()
        selectedIcon = UIImageView(image: .checkmarkImage?.withRenderingMode(.alwaysTemplate))
        selectedIcon.alpha = lowAlpha
        label = UILabel()
        label.alpha = lowAlpha
        super.init(frame: frame)
        selectedIcon.tintColor = activeColor
        setupHStackView()
    }
    
    func setup(label: String, selected: Bool) {
        selectedIcon.isHidden = !selected
        self.label.font = .systemFont(ofSize: 29)
        self.label.alpha = lowAlpha
        self.label.text = label
    }
    
    func setFocused(_ focused: Bool) {
        let color = focused ? .white : activeColor
        let alpha: CGFloat = focused ? 1.0 : lowAlpha
        label.alpha = alpha
        label.textColor = color
        selectedIcon.alpha = alpha
        selectedIcon.tintColor = color
    }
    
    private var activeColor: UIColor {
        switch traitCollection.userInterfaceStyle {
        case .dark, .unspecified:
            return .white
        case .light:
            return .black
        default:
            return .black
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        selectedIcon.tintColor = activeColor
    }
    
    private func setupHStackView() {
        hStackView.axis = .horizontal
        hStackView.alignment = .center
        hStackView.distribution = .fill
        hStackView.spacing = 16
        
        hStackView.addArrangedSubview(selectedIcon)
        
        selectedIcon.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            selectedIcon.widthAnchor.constraint(equalToConstant: 39),
            selectedIcon.heightAnchor.constraint(equalToConstant: 29)
        ])
        
        hStackView.addArrangedSubview(label)
        
        addSubview(hStackView)
        hStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hStackView.topAnchor.constraint(equalTo: topAnchor),
            hStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            hStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            hStackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        hStackView = UIStackView()
        selectedIcon = UIImageView(image: .checkmarkImage)
        label = UILabel()
        super.init(coder: coder)
    }
    
}

private extension UIImage {
    static var checkmarkImage: UIImage? {
        if #available(tvOS 13.0, *), #available(iOS 13.0, *) {
            return UIImage(systemName: "checkmark")
        } else {
            return UIImage(named: "checkmark")
        }
    }
}
