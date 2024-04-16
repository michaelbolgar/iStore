// экран для быстрых тестов разных фич, как например запросы по апи. Можно оставлять тут примеры для других участников команды

import UIKit
import SnapKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .customRed
        
        let testView = UIView()
        testView.backgroundColor = .black
        
        view.addSubview(testView)
        
        testView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(100)
        }
    }
    
    
}
