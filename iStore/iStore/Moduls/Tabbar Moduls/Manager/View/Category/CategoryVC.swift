import UIKit

final class CategoryVC: UIViewController {
    
    // MARK: - UI Elements
    private var categories = ["Phone", "Monitor", "Mouse", "Earphone"]
    
    private let tableView = UITableView()
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        
    }
    
    //MARK: Private Methods
    private func setupViews() {
        
        view.backgroundColor = .white
        view.addSubview(tableView)
        
        setNavigationBar(title: "Category")
        navigationController?.isNavigationBarHidden = false
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.customDarkGray, NSAttributedString.Key.font: UIFont.InterBold(ofSize: 18)]
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"),
                                                            style: .plain, target: self,
                                                            action: #selector(addCategoryButtonTapped))
        navigationItem.leftBarButtonItem?.tintColor = .customDarkGray
        navigationController?.navigationBar.tintColor = UIColor.black
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        
    }
    
    // MARK: - Delete Category
    private func deleteCategory(at indexPath: IndexPath) {
        categories.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    private func addCategory(name: String, imageName: String) {
        categories.append(name)
        tableView.reloadData()
        let imageName = imageName
    }
    
    // MARK: - Actions
    @objc private func addCategoryButtonTapped() {
        // Функция для отображения UIAlertController
        func presentAlert() {
            let alert = UIAlertController(title: "New Category", message: "Enter the name of the new category", preferredStyle: .alert)
            
            // TextField for Category Name
            alert.addTextField { textField in
                textField.placeholder = "Category Name"
            }
            
            // TextField for Image URL
            alert.addTextField { textField in
                textField.placeholder = "Image URL"
            }
            
            let addAction = UIAlertAction(title: "Add", style: .default) { [weak self] _ in
                guard let categoryName = alert.textFields?.first?.text, !categoryName.isEmpty,
                      let imageName = alert.textFields?.last?.text, !imageName.isEmpty else {
                    // Одно или оба поля пустые, показываем пользователю предупреждение
                    let emptyFieldsAlert = UIAlertController(title: "Empty Fields", message: "Please fill in both fields", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                        // Повторно отображаем UIAlertController в случае пустых полей
                        presentAlert()
                    }
                    emptyFieldsAlert.addAction(okAction)
                    self?.present(emptyFieldsAlert, animated: true, completion: nil)
                    return
                }
                
                // Все поля заполнены, добавляем категорию
                self?.addCategory(name: categoryName, imageName: imageName)
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(addAction)
            alert.addAction(cancelAction)
            present(alert, animated: true, completion: nil)
        }
        
        // Отображаем UIAlertController
        presentAlert()
    }

}


// MARK: - Setup Constraints
private extension CategoryVC {
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
}

extension CategoryVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "CategoryCell")
        cell.textLabel?.text = categories[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alert = UIAlertController(title: "Category Options", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Edit", style: .default, handler: { _ in
            self.showEditAlert(for: indexPath)
        }))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
            self.deleteCategory(at: indexPath)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    // Метод для отображения алерт-контроллера для редактирования названия категории
    func showEditAlert(for indexPath: IndexPath) {
        let alert = UIAlertController(title: "Edit Category", message: nil, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.text = self.categories[indexPath.row]
            textField.placeholder = "Category Name"
        }
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            if let categoryName = alert.textFields?.first?.text, !categoryName.isEmpty {
                self.categories[indexPath.row] = categoryName
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
}
