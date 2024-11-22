
import UIKit

class CustomTabBarController: UITabBarController {
    
    let vc1 = HomeViewController()
    let vc2 = TransactionViewController()
    let vc3 = ExpenseViewController()
    let vc4 = IncomeViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabs()
    }
    
    private func configureTabs() {
        vc1.tabBarItem.image = UIImage(systemName: "house.fill")
        vc2.tabBarItem.image = UIImage(systemName: "arrowshape.left.arrowshape.right.fill")
        vc3.tabBarItem.image = UIImage(systemName: "minus.circle.fill")
        vc4.tabBarItem.image = UIImage(systemName: "plus.circle.fill")
        vc1.title = "Home"
        vc2.title = "Transactions"
        vc3.title = "Expense"
        vc4.title = "Income"
        tabBar.backgroundColor = .systemGray6
        tabBar.tintColor = .customPurple

        setViewControllers([vc1, vc2, vc3, vc4], animated: true)
    }
}
