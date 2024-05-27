import UIKit
import OSLog

class UIDraftAndSaveButton: UICollectionReusableView {
    
    // MARK: - Properties
    static let reuseIdentifier = "UIDraftAndSaveButton"
    
    private let draftButton: UIButton = {
        let button = UIButton()
        button.setTitle("Draft", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.2
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 6
        return button
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("Save", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.2
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 6
        return button
    }()
    
    private let draftButtonGradientLayer = CAGradientLayer()
    private let saveButtonGradientLayer = CAGradientLayer()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        // Configure gradient layers
        draftButtonGradientLayer.colors = [UIColor.systemBlue.cgColor, UIColor.systemTeal.cgColor]
        draftButtonGradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        draftButtonGradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        
        saveButtonGradientLayer.colors = [UIColor.systemGreen.cgColor, UIColor.systemTeal.cgColor]
        saveButtonGradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        saveButtonGradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        
        // Create a stack view
        let stackView = UIStackView(arrangedSubviews: [draftButton, saveButton])
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 16 // Increased spacing for a more comfortable look
        
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
        
        // Add gradient layers to buttons
        draftButton.layer.insertSublayer(draftButtonGradientLayer, at: 0)
        saveButton.layer.insertSublayer(saveButtonGradientLayer, at: 0)
        
        // Add targets for buttons
        draftButton.addTarget(self, action: #selector(draftButtonTapped), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Button Actions
    
    @objc private func draftButtonTapped() {
        os_log("Draft button tapped")
    }
    
    @objc private func saveButtonTapped() {
        os_log("Save button tapped")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Ensure gradient layers are properly sized
        draftButtonGradientLayer.frame = draftButton.bounds
        saveButtonGradientLayer.frame = saveButton.bounds
    }
}
