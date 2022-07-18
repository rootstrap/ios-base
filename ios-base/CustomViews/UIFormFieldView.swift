//
//  FormFieldView.swift
//  ios-base
//
//  Created by Lucas Miotti on 13/07/2022.
//  Copyright © 2022 Rootstrap Inc. All rights reserved.
//

import Foundation
import UIKit

class UIFormFieldView: UIView {
  
  var delegate: FormFieldDelegate?
  
  var secureTextEntry: Bool {
    get {
      return textField.isSecureTextEntry
    }
    set(isSecure) {
      textField.isSecureTextEntry = isSecure
    }
  }
    
  private lazy var label = UILabel.titleLabel(
    font: UIFont.boldSystemFont(ofSize: 11),
    textColor: UIColor.black,
    numberOfLines: 1,
    textAlignment: .center
  )
  
  private lazy var textField: UITextField = {
    let textField = UITextField()
    textField.layer.borderWidth = 1.5
    textField.layer.borderColor = UIColor.black.cgColor
    textField.addTarget(
      self,
      action: #selector(removeErrorState),
      for: .editingChanged
    )
    textField.font = .font(size: UIFont.Sizes.heading4)
    textField.textAlignment = .center
    textField.translatesAutoresizingMaskIntoConstraints = false
    return textField
  }()
  
  private lazy var errorLabel = UILabel.titleLabel(
    font: .font(size: UIFont.Sizes.heading5),
    textColor: UIColor.red,
    numberOfLines: 1,
    textAlignment: .center
  )
  
  private lazy var container: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [label, textField, errorLabel])
    stackView.axis = .vertical
    stackView.spacing = 4
    stackView.alignment = .center
    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }()
  
  override init(frame: CGRect) {
     super.init(frame: frame)
     setupView()
   }
   
   required init?(coder aDecoder: NSCoder) {
     super.init(coder: aDecoder)
     setupView()
   }
  
  private func setupView() {
    addSubview(container)
    container.centerVerticallyAndMatchSize(to: self)
    NSLayoutConstraint.activate([
      textField.widthAnchor.constraint(equalToConstant: 188),
      textField.heightAnchor.constraint(equalToConstant: 37)
    ])
    errorLabel.isHidden = true
  }
  
  func setForm(title: String, error: String = "") {
    label.text = title
    textField.placeholder = title
    errorLabel.text = error
  }
  
  @objc
  private func removeErrorState() {
    toggleErrorState(isError: false)
    delegate?.toggleErrorStatus(isError: false)
  }
  
  func toggleErrorState(isError: Bool) {
    errorLabel.isHidden = !isError
    textField.layer.borderColor = isError ? UIColor.red.cgColor : UIColor.black.cgColor
  }
}

protocol FormFieldDelegate {
  func toggleErrorStatus(isError: Bool)
}
