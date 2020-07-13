import UIKit

extension UIImageView {
    public func turnToBackground(_ view: UIView, image name: String) {
        let image = UIImage(named: name)
        self.contentMode = .scaleAspectFill
        self.image = image
        self.layer.zPosition = -1
        
        view.addSubview(self)
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: view.topAnchor),
            self.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            self.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    public func turnToString() {
        self.image = UIImage(named: "string")
        self.layer.zPosition = 2
        self.isUserInteractionEnabled = false
    }
}

extension UILabel {
    public func turnToContinueLabel(_ view: UIView) {
        self.text = "Tap anywhere to continue..."
        self.font = UIFont(name: "Didot", size: view.frame.height * 0.05)
        self.textAlignment = .center
        self.textColor = .white
        
        view.addSubview(self)
        NSLayoutConstraint.activate([
            self.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -24)
        ])
    }
    
    public func turnToStateLabel(_ text: String, font size: CGFloat) {
        self.textColor = .white
        self.font = UIFont(name: "Avenir-Light", size: size)
        self.textAlignment = .center
        self.text = text
        self.numberOfLines = 2
    }
}

extension UIButton {
    func configureButton(with image: String, target: UIViewController, and action: Selector) {
        self.setImage(UIImage(named: image), for: .normal)
        self.addTarget(target, action: action, for: .touchUpInside)
    }
}

extension UISwitch {
    func turnToMainVCSwitches(isOn: Bool, target: UIViewController, action: Selector) {
        self.isOn = isOn
        self.addTarget(target, action: action, for: .valueChanged)
    }
}

extension UIView {
    public func makeItDisappear() {
        self.isUserInteractionEnabled = false
        self.alpha = 0
    }
}


// MARK:- Global Functions
public func turnToKeyCV(vc: UIViewController, tag: Int, CellClass: AnyClass, direction: UICollectionView.ScrollDirection, spacing: CGFloat, topInset: CGFloat) -> UICollectionView {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = direction
    layout.sectionInset = UIEdgeInsets(top: topInset, left: 0, bottom: 0, right: 0)
    layout.minimumLineSpacing = spacing
    
    let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
    cv.register(CellClass, forCellWithReuseIdentifier: "reuseID")
    cv.isScrollEnabled = false
    
    cv.delegate = vc as? UICollectionViewDelegate
    cv.dataSource = vc as? UICollectionViewDataSource
    cv.tag = tag
    cv.isUserInteractionEnabled = true
    if tag > 1001 && tag != 1005 {
        cv.isUserInteractionEnabled = false
    }
    cv.backgroundColor = .clear
    return cv
}
