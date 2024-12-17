
import Foundation

class IncomeViewModel {
    
    private let dataHandler = DatabaseHandling()
    let incomeType: [IncomeCategory] = [
        IncomeCategory(icon: "other", label: "Other"),
        IncomeCategory(icon: "freelance", label: "Freelance"),
        IncomeCategory(icon: "salary", label: "Salary"),
    ]
    
    var onSaveSuccess: (() -> Void)?
    var onSaveFailure: ((String) -> Void)?
    
    func saveIncome(amount: String, category: String, explanation: String, image: Data) {
        let income = IncomeData(
            amount: amount,
            category: category,
            explanation: explanation,
            image: image,
            date: Date(),
            id: UUID()
        )
        
        if ((dataHandler?.saveIncome(incomeData: income)) != nil) == true {
            onSaveSuccess?()
        } else {
            onSaveFailure?("Expense amount exceeds wallet.")
        }
    }
}
