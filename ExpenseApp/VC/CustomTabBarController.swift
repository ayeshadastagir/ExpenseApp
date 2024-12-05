
import UIKit

class CustomTabBarController: UITabBarController {
    
    let vc1 = HomeViewController()
    let vc2 = TransactionViewController()
    let vc3 = IncomeViewController()
    let vc4 = ExpenseViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabs()
    }
    
    private func configureTabs() {
        vc1.tabBarItem.image = UIImage(systemName: "house.fill")
        vc2.tabBarItem.image = UIImage(systemName: "arrowshape.left.arrowshape.right.fill")
        vc3.tabBarItem.image = UIImage(systemName: "plus.circle.fill")
        vc4.tabBarItem.image = UIImage(systemName: "minus.circle.fill")
        
        vc1.title = "Home"
        vc2.title = "Transactions"
        vc3.title = "Income2"
        vc4.title = "Expense2"
        
        tabBar.backgroundColor = .systemGray6
        tabBar.tintColor = .customPurple

        setViewControllers([vc1, vc2, vc4, vc3], animated: true)
    }
}
