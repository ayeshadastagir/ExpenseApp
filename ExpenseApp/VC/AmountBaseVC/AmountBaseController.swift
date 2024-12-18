//
//  TestViewController.swift
//  ExpenseApp
//
//  Created by Ayesha Dastagir on 05/12/2024.
//

import UIKit

class AmountBaseController: UIViewController {
    
    private let incomeLabelView: View = {
        let v = View(backgroundColor: .customPurple, cornerRadius: 25.autoSized)
        v.layer.borderWidth = 2.autoSized
        v.layer.borderColor = UIColor.white.cgColor
        return v
    }()
    let incomeLabel = Label(text: "Income", textColor: .white, font: .systemFont(ofSize: 25.autoSized, weight: .bold))
    private let howMuchLabel = Label(text: "How much?", textColor: .white.withAlphaComponent(0.5), font: .systemFont(ofSize: 20.autoSized, weight: .semibold))
    lazy var enterAmountTF: TextField = {
        let tf = TextField(textColor: .white, font: .systemFont(ofSize: 50.autoSized, weight: .bold), placeholder: "Enter Amount")
        tf.layer.borderWidth = 0
        tf.isEnabled = true
        tf.textAlignment = .left
        tf.keyboardType = .numberPad
        tf.addTarget(self, action: #selector(validateFields), for: .editingChanged)
        return tf
    }()
    private let incomeDetailView = View(cornerRadius: 30.autoSized)
    lazy var selectCategoryView: CategoryView = {
        let view = CategoryView()
        view.layer.borderColor = UIColor.systemGray4.cgColor
        view.layer.borderWidth = 1.autoSized
        let tap = UITapGestureRecognizer(target: self, action: #selector(selectIncome(_:)))
        view.addGestureRecognizer(tap)
        return view
    }()
    private let tableBackgroundView: View = {
        let view = View(backgroundColor: .white)
        view.isHidden = true
        return view
    }()
    lazy var tableView: UITableView = {
        var tv = UITableView()
        tv.separatorStyle = .none
        tv.allowsSelection = false
        tv.clipsToBounds = true
        tv.showsVerticalScrollIndicator = false
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.register(CustomTableViewCell.self, forCellReuseIdentifier: CustomTableViewCell.reuseIdentifier)
        return tv
    }()
    lazy var explainationTF: TextField = {
        let tf = TextField(font: .systemFont(ofSize: 15.autoSized), placeholder: "Description", cornerRadius: 25.autoSized)
        tf.addTarget(self, action: #selector(validateFields), for: .editingChanged)
        return tf
    }()
    lazy var addButton: Button = {
        let btn = Button(title: "ADD", backgroundColor: .customGreen, cornerRadius: 25.autoSized)
        btn.isEnabled = false
        btn.alpha = 0.5
        btn.addTarget(self, action: #selector(dataSaved), for: .touchUpInside)
        return btn
    }()
    private var categoryViewHeight: NSLayoutConstraint!
    private var tableBackgroundViewTop: NSLayoutConstraint!
    private var tableViewTop: NSLayoutConstraint!
    private let viewModel = AmountBaseViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .customGreen
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setDefaultValue()
    }
    
    private func setupUI() {
        view.addSubview(incomeLabelView)
        view.addSubview(incomeLabel)
        view.addSubview(howMuchLabel)
        view.addSubview(enterAmountTF)
        view.addSubview(incomeDetailView)
        incomeDetailView.addSubview(selectCategoryView)
        selectCategoryView.addSubview(tableBackgroundView)
        tableBackgroundView.addSubview(tableView)
        incomeDetailView.addSubview(explainationTF)
        incomeDetailView.addSubview(addButton)
        
        NSLayoutConstraint.activate([
            incomeLabelView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0.autoSized),
            incomeLabelView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            incomeLabelView.heightAnchor.constraint(equalToConstant: 50.autoSized),
            incomeLabelView.widthAnchor.constraint(equalToConstant: 150.widthRatio),
            
            incomeLabel.centerXAnchor.constraint(equalTo: incomeLabelView.centerXAnchor),
            incomeLabel.centerYAnchor.constraint(equalTo: incomeLabelView.centerYAnchor),
            
            howMuchLabel.topAnchor.constraint(equalTo: incomeLabel.bottomAnchor, constant: 50.autoSized),
            howMuchLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20.widthRatio),
            howMuchLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20.widthRatio),
            howMuchLabel.heightAnchor.constraint(equalToConstant: 25.autoSized),
            
            enterAmountTF.topAnchor.constraint(equalTo: howMuchLabel.bottomAnchor, constant: 20.autoSized),
            enterAmountTF.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25.widthRatio),
            enterAmountTF.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25.widthRatio),
            enterAmountTF.heightAnchor.constraint(equalToConstant: 70.autoSized),
            
            incomeDetailView.topAnchor.constraint(equalTo: enterAmountTF.bottomAnchor, constant: 100.autoSized),
            incomeDetailView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            incomeDetailView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            incomeDetailView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 30.autoSized),
            
            selectCategoryView.topAnchor.constraint(equalTo: incomeDetailView.topAnchor, constant: 40.autoSized),
            selectCategoryView.leadingAnchor.constraint(equalTo: incomeDetailView.leadingAnchor, constant: 25.widthRatio),
            selectCategoryView.trailingAnchor.constraint(equalTo: incomeDetailView.trailingAnchor, constant: -25.widthRatio),
            
            tableBackgroundView.leadingAnchor.constraint(equalTo: selectCategoryView.leadingAnchor),
            tableBackgroundView.trailingAnchor.constraint(equalTo: selectCategoryView.trailingAnchor),
            tableBackgroundView.bottomAnchor.constraint(equalTo: selectCategoryView.bottomAnchor),
            
            tableView.leadingAnchor.constraint(equalTo: tableBackgroundView.leadingAnchor, constant: 10.widthRatio),
            tableView.trailingAnchor.constraint(equalTo: tableBackgroundView.trailingAnchor, constant: -10.widthRatio),
            tableView.bottomAnchor.constraint(equalTo: tableBackgroundView.bottomAnchor, constant: -10.autoSized),
            
            explainationTF.topAnchor.constraint(equalTo: selectCategoryView.bottomAnchor, constant: 15.autoSized),
            explainationTF.leadingAnchor.constraint(equalTo: incomeDetailView.leadingAnchor, constant: 25.widthRatio),
            explainationTF.trailingAnchor.constraint(equalTo: incomeDetailView.trailingAnchor, constant: -25.widthRatio),
            explainationTF.heightAnchor.constraint(equalToConstant: 60.autoSized),
            
            addButton.heightAnchor.constraint(equalToConstant: 60.autoSized),
            addButton.leadingAnchor.constraint(equalTo: incomeDetailView.leadingAnchor, constant: 25.widthRatio),
            addButton.trailingAnchor.constraint(equalTo: incomeDetailView.trailingAnchor, constant: -25.widthRatio),
            addButton.bottomAnchor.constraint(equalTo: incomeDetailView.bottomAnchor, constant: -150.autoSized),
        ])
        categoryViewHeight = selectCategoryView.heightAnchor.constraint(equalToConstant: 60.autoSized)
        categoryViewHeight.isActive = true
        tableBackgroundViewTop = tableBackgroundView.topAnchor.constraint(equalTo: selectCategoryView.logo.bottomAnchor, constant: 5.autoSized)
        tableViewTop = tableView.topAnchor.constraint(equalTo: tableBackgroundView.topAnchor, constant: 10.autoSized)
    }
 
    func resetUI() {
        categoryViewHeight.isActive = false
        tableViewTop.isActive = false
        tableBackgroundViewTop.isActive = false
        categoryViewHeight = selectCategoryView.heightAnchor.constraint(equalToConstant: 60.autoSized)
        categoryViewHeight.isActive = true
        selectCategoryView.selectedCategoryLabel.textColor = .black
        addButton.isHidden = false
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    func setDefaultValue() {
        enterAmountTF.text = ""
        explainationTF.text = ""
        selectCategoryView.selectedCategoryLabel.text = "Category"
        selectCategoryView.logo.image = UIImage(named: "category")
        selectCategoryView.selectedCategoryLabel.textColor = .systemGray3
    }
        
    @objc func dataSaved() {
//     override and implement when needed in child class 
    }
    
    @objc func selectIncome(_ sender: UITapGestureRecognizer? = nil) {
        categoryViewHeight.isActive = false
        categoryViewHeight = selectCategoryView.heightAnchor.constraint(equalToConstant: 250.autoSized)
        categoryViewHeight.isActive = true
        
        tableBackgroundView.isHidden = false
        tableBackgroundViewTop.isActive = true
        tableViewTop.isActive = true
        addButton.isHidden = true
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        validateFields()
    }
    
    @objc func validateFields() {
       let result = viewModel.checkFields(amount: enterAmountTF.text ?? "", category: selectCategoryView.selectedCategoryLabel.text ?? "", description: explainationTF.text ?? "")
        if result == true {
            addButton.isEnabled = true
            addButton.alpha = 1.0
        } else {
            addButton.isEnabled = false
            addButton.alpha = 0.5
        }
        let text = enterAmountTF.text?.toCurrencyFormat
        enterAmountTF.text = text
    }
}

