
import Foundation
import UIKit

class SplashViewController: UIViewController {

    private let loadingLabel: UILabel = {
        let label = UILabel()
        label.text = "Загрузка..."
        label.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        // Добавляем надпись на экран
        view.addSubview(loadingLabel)

        // Позиционируем надпись по центру
        NSLayoutConstraint.activate([
            loadingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Имитация "загрузки"
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            // Переход на основной экран
            let mainVC = PostListViewController()
            // Обернём в UINavigationController (удобно, если нужен header, кнопка назад и т.п.)
            let navController = UINavigationController(rootViewController: mainVC)
            navController.modalPresentationStyle = .fullScreen

            // Меняем rootViewController через present (либо через window, в зависимости от дизайна)
            self.present(navController, animated: true, completion: nil)
        }
    }
}
