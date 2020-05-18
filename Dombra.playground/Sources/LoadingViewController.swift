import UIKit

public class LoadingViewController: UIViewController {
    // MARK:- Properties
    private var backgroundImageView = UIImageView()
    private var tapAnywhereLabel = UILabel()
    private lazy var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Dombra"
        lbl.font = UIFont(name: "Zapfino", size: view.frame.height * 0.06)
        lbl.adjustsFontSizeToFitWidth = true
        lbl.textAlignment = .center
        lbl.textColor = .black
        return lbl
    }()
    private lazy var dombraImage: UIImageView = {
        let image = UIImage(named: "volumetricDombra")
        let iv = UIImageView(image: image)
        iv.contentMode = .scaleAspectFit
        iv.layer.shadowColor = UIColor.black.cgColor
        iv.layer.shadowOpacity = 1
        iv.layer.shadowOffset = .zero
        iv.layer.shadowRadius = 10
        return iv
    }()
    private var tap: UITapGestureRecognizer!
    
    
    // MARK:- View Lifecycle
    override public func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationController()
        view.backgroundColor = .white
        
        backgroundImageView.turnToBackground(view, image: "steppe")
        tapAnywhereLabel.turnToContinueLabel(view)
        view.addSubview(titleLabel)
        view.addSubview(dombraImage)
        
        setAutoresizingToFalse()
        activateConstraints()
        
        initTap()
        self.view.addGestureRecognizer(tap)
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AudioPlayer.turnOnBackgroundMusic()
    }
    
    private func setupNavigationController() {
        navigationController?.navigationBar.isHidden = true
        navigationController?.delegate = self
    }
    
    private func setAutoresizingToFalse() {
        _ = self.view.subviews.map { $0.translatesAutoresizingMaskIntoConstraints = false }
    }
    
    private func activateConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 8),
            titleLabel.bottomAnchor.constraint(equalTo: dombraImage.topAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            dombraImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dombraImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            dombraImage.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6),
            dombraImage.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3),
            
            tapAnywhereLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    
    // MARK:- Actions
    private func initTap() {
        self.tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
    }
    
    @objc
    private func handleTap() {
        self.show(MainViewController(), sender: nil)
    }
}

extension LoadingViewController: UINavigationControllerDelegate {
    public func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return Animator()
    }
}

