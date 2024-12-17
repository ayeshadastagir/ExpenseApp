//
//  ExpenseTestViewController.swift
//  ExpenseApp
//
//  Created by Ayesha Dastagir on 05/12/2024.
//

import UIKit

class ExpenseViewController: AmountBaseController {
    
    private let viewModel = ExpenseViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .customRed
        setupUI()
        bindViewModel()
    }
    
    private func setupUI() {
        incomeLabel.text = "Expense"
        addButton.backgroundColor = .customRed
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func bindViewModel() {
        viewModel.onSaveSuccess = { [weak self] in
            self?.showHomeScreen()
        }
        
        viewModel.onSaveFailure = { [weak self] message in
            self?.showErrorAlert(message: message)
        }
    }
    
    override func dataSaved() {
        guard let selectedImage = selectCategoryView.logo.image?.pngData() else { return }
        viewModel.saveExpense(
            amount: enterAmountTF.text?.justifyNumber ?? "",
            category: selectCategoryView.selectedCategoryLabel.text ?? "",
            explanation: explainationTF.text ?? "",
            image: selectedImage
        )
    }
    
    private func showHomeScreen() {
        super.setDefaultValue()
        let homeScreen = CustomTabBarController()
        homeScreen.modalTransitionStyle = .crossDissolve
        homeScreen.modalPresentationStyle = .fullScreen
        self.present(homeScreen, animated: true, completion: nil)
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(
            title: "Cannot Add Expense",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
        super.setDefaultValue()
    }
}

extension ExpenseViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.expenseCategories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell.reuseIdentifier, for: indexPath) as! CustomTableViewCell
        cell.selectCategoryType = { [weak self] selectedLabelText, img in
            self?.selectCategoryView.didUpdateCategory(
                name: selectedLabelText ?? "",
                img: img)
            self?.resetUI()
        }
        let category = viewModel.expenseCategories[indexPath.row]
        cell.configure(
            text: category.label,
            icon: UIImage(named: category.icon))
        return cell
    }
}
