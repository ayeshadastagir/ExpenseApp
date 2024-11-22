import UIKit

class SplashScreenController: UIViewController {
    
    private let logoImage = Image(image: "logo")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        navigateToHomeScreen()
    }
    
    private func setupUI() {
        view.addSubview(logoImage)
        
        NSLayoutConstraint.activate([
            logoImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            logoImage.widthAnchor.constraint(equalToConstant: 200.widthRatio),
            logoImage.heightAnchor.constraint(equalToConstant: 200.autoSized),
        ])
    }
    
    private func navigateToHomeScreen() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            let homeScreen = CustomTabBarController()
            homeScreen.modalTransitionStyle = .crossDissolve
            homeScreen.modalPresentationStyle = .fullScreen
           self?.present(homeScreen, animated: true, completion: nil)
        }
    }
}

