//
//  ExpenseTestViewController.swift
//  ExpenseApp
//
//  Created by Ayesha Dastagir on 05/12/2024.
//

import UIKit

class ExpenseViewController: AmountBaseController {

    private let expenseType: [ExpenseCategory] = [
        ExpenseCategory(icon: "bill", label: "Bills"),
        ExpenseCategory(icon: "food", label: "Food"),
        ExpenseCategory(icon: "grocery", label: "Grocery"),
        ExpenseCategory(icon: "shop", label: "Shopping"),
        ExpenseCategory(icon: "transport", label: "Transportation"),
        ExpenseCategory(icon: "subs", label: "Subscriptions"),
        ExpenseCategory(icon: "edu", label: "Education"),
        ExpenseCategory(icon: "invest", label: "Investment"),
        ExpenseCategory(icon: "other", label: "Others"),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .customRed
        setDesiredUI()
    }
    private func setDesiredUI() {
        incomeLabel.text = "Expense"
        addButton.backgroundColor = .customRed
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func dataSaved() {
        let dataHandler = DatabaseHandling()
        guard let selectedImage = selectCategoryView.logo.image?.pngData() else { return }
        let expense = ExpenseData(
            amount: enterAmountTF.text?.justifyNumber ?? "",
            category: selectCategoryView.selectedCategoryLabel.text ?? "",
            explanation: explainationTF.text ?? "",
            image: selectedImage,
            date: Date(),
            id: UUID()
        )
        if dataHandler?.saveExpense(expenseData: expense) == true {
            super.setDefaultValue()
            let homeScreen = CustomTabBarController()
            homeScreen.modalTransitionStyle = .crossDissolve
            homeScreen.modalPresentationStyle = .fullScreen
            self.present(homeScreen, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(
                title: "Cannot Add Expense",
                message: "No Income or Expense amount exceeds wallet.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            super.setDefaultValue()
        }
    }
}

extension ExpenseViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return expenseType.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell.reuseIdentifier, for: indexPath) as! CustomTableViewCell
        cell.selectCategoryType = { [weak self] selectedLabelText, img in
            self?.selectCategoryView.didUpdateCategory(
                name: selectedLabelText ?? "",
                img: img)
            self?.resetUI()
        }
        let card = expenseType[indexPath.row]
        cell.configure(
            text: card.label,
            icon: UIImage(named: card.icon))
        return cell
    }
}
