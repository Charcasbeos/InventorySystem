import UIKit
import OSLog



class UISaveButton: UIStackView {
    
    
    // MARK: - Properties
    static let reuseIdentifier = "UISaveButton"
    public var onSaveButtonTapped: (() -> Void)?
    
    
    let saveButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Save", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.backgroundColor = UIColor(.blue)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.2
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 6
        
        
        return button
    }()
    
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        
        // Add constraints to saveButton
        NSLayoutConstraint.activate([
            saveButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            saveButton.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            saveButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            saveButton.widthAnchor.constraint(equalToConstant: 50)
        ])
        
        
        
        // Add targets for button
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Button Actions
    
    @objc public func saveButtonTapped() {
        os_log("Save button tapped")        
        if let onSaveButtonTapped = onSaveButtonTapped {
            print("onSaveButtonTapped closure is not nil")
            onSaveButtonTapped()
        } else {
            print("onSaveButtonTapped closure is nil")
        }
    }
    
    
 
}
