import UIKit
import OSLog



class UIDraftAndSaveButton: UIStackView {
    
    
    // MARK: - Properties
    static let reuseIdentifier = "UIDraftAndSaveButton"
    public var onDraftButtonTapped: (() -> Void)?
    public var onSaveButtonTapped: (() -> Void)?
    
    
    let draftButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Draft", for: .normal)
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
        
        // Create a stack view
        let stackView = UIStackView(arrangedSubviews: [draftButton, saveButton])
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 16 // Increased spacing for a more comfortable look
        
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
     
        // Add constraints to draftButton
        NSLayoutConstraint.activate([
            draftButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            draftButton.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            draftButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            draftButton.trailingAnchor.constraint(equalTo: saveButton.leadingAnchor, constant: -16),
            draftButton.widthAnchor.constraint(equalToConstant: 50)
        ])
        
        // Add constraints to saveButton
        NSLayoutConstraint.activate([
            saveButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            saveButton.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            saveButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            saveButton.widthAnchor.constraint(equalToConstant: 50)
        ])
        
        
        
        // Add targets for buttons
        draftButton.addTarget(self, action: #selector(draftButtonTapped), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Button Actions
    
    @objc public func draftButtonTapped() {
        os_log("Draft button tapped")
        onDraftButtonTapped?()
    }
    
    @objc public func saveButtonTapped() {
        os_log("Save button tapped")
        print("Save button tapped")
        if let onSaveButtonTapped = onSaveButtonTapped {
            print("onSaveButtonTapped closure is not nil")
            onSaveButtonTapped()
        } else {
            print("onSaveButtonTapped closure is nil")
        }
    }
    
    
 
}
