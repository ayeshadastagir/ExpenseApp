import UIKit

class ExpenseUpdateViewController: ExpenseViewController {

    private let viewModel = ExpenseUpdateViewModel()
    private let recordId: UUID
    
    init(recordId: UUID) {
        self.recordId = recordId
        super.init(nibName: nil, bundle: nil)
        fetchExistingRecord()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addButton.setTitle("Update", for: .normal)
        bindViewModel()
    }
    
    private func fetchExistingRecord() {
        viewModel.fetchExistingRecord(recordId: recordId)
        DispatchQueue.main.async {
            self.populateFields()
        }
    }
    
    private func populateFields() {
        guard let expenseData = viewModel.existingExpenseData else { return }
        enterAmountTF.text = expenseData.amount
        explainationTF.text = expenseData.explanation
        selectCategoryView.didUpdateCategory(
            name: expenseData.category,
            img: UIImage(data: expenseData.image)
        )
        super.validateFields()
    }
    
    private func bindViewModel() {
        viewModel.onUpdateSuccess = { [weak self] in
            self?.showHomeScreen()
        }
        
        viewModel.onUpdateFailure = { [weak self] message in
            self?.showErrorAlert(message: message)
        }
    }
    
    override func dataSaved() {
        guard let selectedImageData = selectCategoryView.logo.image?.pngData(),
              let amount = enterAmountTF.text?.justifyNumber,
              let category = selectCategoryView.selectedCategoryLabel.text,
              let explanation = explainationTF.text else { return }
        
        if viewModel.validateFields(amount: amount, category: category, explanation: explanation) {
            viewModel.updateExpense(recordId: recordId, amount: amount, category: category, explanation: explanation, imageData: selectedImageData)
        }
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
            title: "Update Failed",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.showHomeScreen()
        }))
        present(alert, animated: true, completion: nil)
    }
}
