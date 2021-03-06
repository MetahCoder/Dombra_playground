import UIKit

// UICollection View Classes
public class KeyCollectionViewCell: UICollectionViewCell {
    // MARK:- Properties
    var clearBlurEffectView: UIVisualEffectView?
    var greenBlurEffectView: UIVisualEffectView?
    
    
    //MARK:- Cell separation
    override public func draw(_ rect: CGRect) {
        let cgContext = UIGraphicsGetCurrentContext()
        cgContext?.move(to: CGPoint(x: rect.minX, y: rect.minY))
        cgContext?.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        cgContext?.setStrokeColor(Content.silverColor.cgColor)
        cgContext?.setLineWidth(4.0)
        cgContext?.strokePath()
    }
    
    
    // MARK:- Highlighting
    public func addBlurEffectViews() {
        clearBlurEffectView = addBlurEffectView(.clear, alpha: 1.0)
        greenBlurEffectView = addBlurEffectView(Content.highlightColor, alpha: 0.0)
    }
    
    private func addBlurEffectView(_ color: UIColor?, alpha: CGFloat) -> UIVisualEffectView {
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        
        blurEffectView.backgroundColor = Content.highlightColor
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        blurEffectView.backgroundColor = color
        blurEffectView.alpha = alpha
        
        self.addSubview(blurEffectView)
        return blurEffectView
    }
    
    public func removeBlurs() {
        clearBlurEffectView?.removeFromSuperview()
        greenBlurEffectView?.removeFromSuperview()
    }
}


public class TitleCollectionViewCell: UICollectionViewCell {
    public var title = "" {
        didSet {
            titleLabel.text = title
        }
    }
    private lazy var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: "Avenir-Light", size: self.frame.height * 0.5)
        lbl.textAlignment = .center
        lbl.textColor = .white
        return lbl
    }()
    
    // MARK:- Initialization
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        activateConstraints()
    }
    
    private func activateConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}


public class DotCollectionViewCell: UICollectionViewCell {
    public func createDot() {
        let circle = UIView()
        circle.backgroundColor = .white
        circle.translatesAutoresizingMaskIntoConstraints = false
            
        self.addSubview(circle)
        let constant = self.frame.height * 0.2
        NSLayoutConstraint.activate([
            circle.heightAnchor.constraint(equalToConstant: constant),
            circle.widthAnchor.constraint(equalToConstant: constant),
            circle.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            circle.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        circle.layer.cornerRadius = constant * 0.5
    }
}


public class ImageCollectionViewCell: UICollectionViewCell {
    // MARK:- Properties
    public var imageName = "" {
        didSet {
            imageView.image = UIImage(named: imageName)
        }
    }
    private var imageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    
    // MARK:- Initialization
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(imageView)
        activateConstraints()
    }
    
    private func activateConstraints() {
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}


public class ContainerView: UIView {
    // MARK:- Properties
    weak var playBtn: UIButton!
    
    private lazy var leftDot: UIView = {
        let view = UIView()
        setupDot(view)
        return view
    }()
    private lazy var rightDot: UIView = {
        let view = UIView()
        setupDot(view)
        return view
    }()
    private func setupDot(_ view: UIView) {
        view.backgroundColor = .gray
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.cornerRadius = 15
        
        view.layer.masksToBounds = false
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
    }
    
    
    // MARK:- Constraints
    func setupLayout(_ playBtn: UIButton) {
        self.playBtn = playBtn
        self.addSubview(leftDot)
        self.addSubview(rightDot)
        activateConstraints()
    }
    
    private func activateConstraints() {
        NSLayoutConstraint.activate([
            leftDot.trailingAnchor.constraint(equalTo: playBtn.leadingAnchor, constant: 4),
            leftDot.topAnchor.constraint(equalTo: self.topAnchor),
            leftDot.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            leftDot.widthAnchor.constraint(equalTo: leftDot.heightAnchor),
            
            rightDot.leadingAnchor.constraint(equalTo: playBtn.trailingAnchor, constant: -4),
            rightDot.topAnchor.constraint(equalTo: self.topAnchor),
            rightDot.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            rightDot.widthAnchor.constraint(equalTo: rightDot.heightAnchor),
        ])
    }
    
    
    // MARK:- Helpful methods
    func clearAllDots() {
        for subview in self.subviews {
            subview.backgroundColor = .gray
        }
    }
    
    func fillLeftDot() {
        leftDot.backgroundColor = .green
    }
    
    func fillRightDot() {
        rightDot.backgroundColor = .green
    }
}
