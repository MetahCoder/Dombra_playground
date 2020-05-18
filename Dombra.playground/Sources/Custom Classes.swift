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
