//
//  FormFieldView.swift
//  ios-base
//
//  Created by Lucas Miotti on 13/07/2022.
//  Copyright © 2022 Rootstrap Inc. All rights reserved.
//

import Foundation
import UIKit

class UIFormFieldView: UIView,
                        UIPickerViewDelegate,
                       UIPickerViewDataSource {
  
  var delegate: UIFormFieldDelegate?
    
  private var errorMessage: String = ""
  private var pickerData: [String] = []
  
  var text: String {
    textField.text ?? ""
  }
  
  var secureTextEntry: Bool {
    get {
      textField.isSecureTextEntry
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
    textField.layer.borderWidth = 0.5
    textField.layer.borderColor = UIColor.black.cgColor
    textField.addTarget(
      self,
      action: #selector(onTextChanged),
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
      textField.heightAnchor.constraint(equalToConstant: 37),
      errorLabel.heightAnchor.constraint(equalToConstant: 14)
    ])
  }
  
  func setForm(
    title: String,
    placeholder: String = "",
    error: String = ""
  ) {
    label.text = title
    textField.placeholder = placeholder
    errorMessage = error
  }
  
  func setPicker(
    array: [String]
  ) {
    let pickerView = UIPickerView()
    pickerView.delegate = self
    pickerView.dataSource = self
    textField.inputView = pickerView
    pickerData = array
  }
  
  @objc
  private func onTextChanged(_ sender: UITextField) {
    toggleErrorState(isError: false)
    delegate?.onTextChanged(self)
  }
  
  func toggleErrorState(isError: Bool) {
    errorLabel.text = isError ? errorMessage : ""
    textField.layer.borderColor = isError ? UIColor.red.cgColor : UIColor.black.cgColor
  }
  
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    1
  }
  
  func pickerView(
    _ pickerView: UIPickerView,
    numberOfRowsInComponent component: Int
  ) -> Int {
    pickerData.count
  }
  
  func pickerView(
    _ pickerView: UIPickerView,
    titleForRow row: Int,
    forComponent component: Int
  ) -> String? {
    let selectedData = pickerData[row]
    delegate?.onTextChanged(self)
    return selectedData
  }
  
  func pickerView(
    _ pickerView: UIPickerView,
    didSelectRow row: Int,
    inComponent component: Int
  ) {
      textField.text = pickerData[row]
  }
}

protocol UIFormFieldDelegate {
  func onTextChanged(_ sender: UIFormFieldView)
}
