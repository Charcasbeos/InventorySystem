import UIKit
import OSLog
class UIDraftAndSaveButton: UIStackView {
    
    // MARK: - Properties
    
    private let draftButton: UIButton = {
           let button = UIButton()
           button.setTitle("Draft", for: .normal)
           button.setTitleColor(.white, for: .normal)
           button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
           
           // Set gradient background
           let gradientLayer = CAGradientLayer()
           gradientLayer.colors = [UIColor.blue.cgColor, UIColor.systemBlue.cgColor]
           gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
           gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
           gradientLayer.frame = button.bounds
           button.layer.insertSublayer(gradientLayer, at: 0)
           
           // Set corner radius
           button.layer.cornerRadius = 8
           button.layer.masksToBounds = true
           
           // Set shadow
           button.layer.shadowColor = UIColor.black.cgColor
           button.layer.shadowOpacity = 0.3
           button.layer.shadowOffset = CGSize(width: 2, height: 2)
           button.layer.shadowRadius = 4
           
           return button
       }()
           
       private let saveButton: UIButton = {
           let button = UIButton()
           button.setTitle("Save", for: .normal)
           button.setTitleColor(.white, for: .normal)
           button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
           
           // Set gradient background
           let gradientLayer = CAGradientLayer()
           gradientLayer.colors = [UIColor.blue.cgColor, UIColor.systemBlue.cgColor]
           gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
           gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
           gradientLayer.frame = button.bounds
           button.layer.insertSublayer(gradientLayer, at: 0)
           
           // Set corner radius
           button.layer.cornerRadius = 8
           button.layer.masksToBounds = true
           
           // Set shadow
           button.layer.shadowColor = UIColor.black.cgColor
           button.layer.shadowOpacity = 0.3
           button.layer.shadowOffset = CGSize(width: 2, height: 2)
           button.layer.shadowRadius = 4
           
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
        // Customize stack view properties if needed
        axis = .horizontal
        
        alignment = .fill
        
        distribution = .fillEqually
        spacing = 8
        
        
        
        // Add buttons to stack view
        addArrangedSubview(draftButton)
        addArrangedSubview(saveButton)
        

        
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
           if let gradientLayers = draftButton.layer.sublayers?.compactMap({ $0 as? CAGradientLayer }) {
               for gradientLayer in gradientLayers {
                   gradientLayer.frame = draftButton.bounds
               }
           }
           
           if let gradientLayers = saveButton.layer.sublayers?.compactMap({ $0 as? CAGradientLayer }) {
               for gradientLayer in gradientLayers {
                   gradientLayer.frame = saveButton.bounds
               }
           }
       }
}
