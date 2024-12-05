//
//  Test2ViewController.swift
//  ExpenseApp
//
//  Created by Ayesha Dastagir on 05/12/2024.
//

import UIKit

class IncomeViewController: AmountBaseController {
    
    private let incomeType: [IncomeCategory] = [
        IncomeCategory(icon: "other", label: "Other"),
        IncomeCategory(icon: "freelance", label: "Freelance"),
        IncomeCategory(icon: "salary", label: "Salary"),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDesiredUI()
    }
    
    private func setDesiredUI() {
        incomeLabel.text = "Income"
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func dataSaved() {
        super.dataSaved()
        let dataHandler = DatabaseHandling()
        guard let selectedImage = selectCategoryView.logo.image?.pngData() else { return }
        let income = IncomeData(
            amount: enterAmountTF.text?.justifyNumber ?? "",
            category: selectCategoryView.selectedCategoryLabel.text ?? "",
            explanation: explainationTF.text ?? "",
            image: selectedImage,
            date: Date(),
            id: UUID()
        )
        dataHandler?.saveIncome(incomeData: income)
        super.setDefaultValue()
        let homeScreen = CustomTabBarController()
        homeScreen.modalTransitionStyle = .crossDissolve
        homeScreen.modalPresentationStyle = .fullScreen
        self.present(homeScreen, animated: true, completion: nil)
    }
    
}

extension IncomeViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return incomeType.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell.reuseIdentifier, for: indexPath) as! CustomTableViewCell
        cell.selectCategoryType = { [weak self] selectedLabelText, img in
            self?.selectCategoryView.didUpdateCategory(
                name: selectedLabelText ?? "",
                img: img)
            self?.resetUI()
        }
        let card = incomeType[indexPath.row]
        cell.configure(
            text: card.label,
            icon: UIImage(named: card.icon))
        return cell
    }
}
