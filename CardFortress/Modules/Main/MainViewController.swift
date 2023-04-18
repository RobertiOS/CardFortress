//
//  MainViewController.swift
//  CardFortress
//
//  Created by Roberto Corrales on 16/04/23.
//

import UIKit

final class MainViewController: UIViewController {

    //MARK: Properties
    var viewModel: MainViewModelProtocol?

    // MARK: Initialization

    init(viewModel: MainViewModelProtocol? = nil){
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
        title = LocalizableString.mainViewTitle.value
        bindViewController()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Views

    let label: UILabel = {
        let label: UILabel = .init()
        label.text = LocalizableString.labelTest.value
        label.backgroundColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let qtylabel: UILabel = {
        let label: UILabel = .init()
        label.backgroundColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var button: UIButton = {
        let button: UIButton = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(LocalizableString.buttonTest.value, for: .normal)
        button.backgroundColor = .black
        button.addTarget(self, action: #selector(moveToNextView), for: .touchUpInside)
        return button
    }()
    
    lazy var increaseQuantityButton: UIButton = {
        let button: UIButton = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(LocalizableString.increaseQty.value, for: .normal)
        button.backgroundColor = .black
        button.addTarget(self, action: #selector(increaseQuantity), for: .touchUpInside)
        return button
    }()
    
    let stackViewContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .equalSpacing
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    //MARK: view construction

    func setUPViewHerachy() {
        view.addSubview(label)
        view.addSubview(qtylabel)
        view.addSubview(stackViewContainer)
        stackViewContainer.addArrangedSubview(button)
        stackViewContainer.addArrangedSubview(increaseQuantityButton)
    }

    func setUpLayout() {
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 200),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            qtylabel.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 10),
            qtylabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackViewContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            stackViewContainer.heightAnchor.constraint(equalToConstant: 70),
            stackViewContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            stackViewContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
        ])
    }

    //MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUPViewHerachy()
        setUpLayout()
        bindViewController()
        view.backgroundColor = .white
    }

    //MARK: actions

    @objc func moveToNextView() {
        viewModel?.goToOtherVC()
    }
    
    @objc func increaseQuantity() {
        viewModel?.increaseQuantity()
    }
    
    //MARK: binding
    
    func bindViewController() {
        viewModel?.quantity.bind { [weak self] in
            self?.qtylabel.text = "\($0)"
        }
    }
}

// MARK: - TestHooks

#if DEBUG
extension MainViewController {
    struct TestHooks {
        let target: MainViewController
        var labelText: String? { target.label.text }
        var buttonTitleText: String? { target.button.titleLabel?.text }
        var viewControllerTitle: String? { target.title }
        
        var labelTopConstraint: NSLayoutYAxisAnchor { target.label.topAnchor }
        
        
    }

    var testHooks: TestHooks {
        TestHooks(target: self)
    }
}
#endif

