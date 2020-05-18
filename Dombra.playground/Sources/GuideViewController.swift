import UIKit

public class GuideViewController: UIViewController {
    // MARK:- Properties
    private var backgroundImageView = UIImageView()
    private var tapAnywhereLabel = UILabel()
    private lazy var infoTextView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont(name: "Hiragino Sans", size: view.frame.height * 0.04)
        tv.text = Content.infoText
        tv.backgroundColor = .clear
        tv.textColor = .white
        tv.isEditable = false
        tv.indicatorStyle = .white
        return tv
    }()
    private lazy var dimashImageView: UIImageView = {
        let image = UIImage(named: "Dimash")
        let iv = UIImageView()
        iv.image = image
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    private lazy var dimashLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: "Avenir-Light", size: view.frame.height * 0.03)
        lbl.textColor = .white
        lbl.text = "Dimash Kudaibergen"
        lbl.textAlignment = .center
        return lbl
    }()
    private var viewTap: UITapGestureRecognizer!
    private var textViewTap: UITapGestureRecognizer!


    // MARK:- View Lifecycle
    override public func viewDidLoad() {
        super.viewDidLoad()

        backgroundImageView.turnToBackground(view, image: "wood")
        tapAnywhereLabel.turnToContinueLabel(view)
        tapAnywhereLabel.text = "Tap anywhere to exit..."
        view.addSubview(infoTextView)
        view.addSubview(dimashImageView)
        view.addSubview(dimashLabel)
        setAutoresizingToFalse()
        activateConstraints()

        initTaps()
        self.view.addGestureRecognizer(viewTap)
        self.infoTextView.addGestureRecognizer(textViewTap)
    }

    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        setupInfoTextViewIndicatorInsets()
        infoTextView.flashScrollIndicators()
    }

    private func setAutoresizingToFalse() {
        _ = self.view.subviews.map { $0.translatesAutoresizingMaskIntoConstraints = false }
    }

    private func activateConstraints() {
        NSLayoutConstraint.activate([
            infoTextView.topAnchor.constraint(equalTo: view.topAnchor, constant: 24),
            infoTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -4),

            dimashImageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -4),
            dimashImageView.centerYAnchor.constraint(equalTo: infoTextView.centerYAnchor),
            dimashImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3),
            dimashImageView.widthAnchor.constraint(equalTo: infoTextView.widthAnchor),

            infoTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 4),
            infoTextView.trailingAnchor.constraint(equalTo: dimashImageView.leadingAnchor, constant: -24),

            dimashLabel.leadingAnchor.constraint(equalTo: dimashImageView.leadingAnchor),
            dimashLabel.trailingAnchor.constraint(equalTo: dimashImageView.trailingAnchor),
            dimashLabel.topAnchor.constraint(equalTo: dimashImageView.bottomAnchor, constant: 4),

            tapAnywhereLabel.centerXAnchor.constraint(equalTo: dimashImageView.centerXAnchor)
        ])
    }

    private func setupInfoTextViewIndicatorInsets() {
        infoTextView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: infoTextView.bounds.size.width - 5)
    }


    // MARK:- Actions
    private func initTaps() {
        self.viewTap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.textViewTap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
    }

    @objc
    private func handleTap() {
        self.navigationController?.popViewController(animated: true)
    }
}


