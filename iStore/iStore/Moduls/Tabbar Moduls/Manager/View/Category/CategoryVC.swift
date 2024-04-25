import UIKit

final class CategoryVC: UIViewController {
    
    // MARK: - UI Elements
    private var categories = ["Phone", "Monitor", "Mouse", "Earphone"]
    
    private let addNewProductTitle = UILabel.makeLabel(text: "Category",
                                                 font: .InterBold(ofSize: 24),
                                                 textColor: .customDarkGray,
                                                 numberOfLines: nil,
                                                 alignment: .center)
    
    private lazy var addCategoryButton: UIButton = {
        let element = UIButton()
        element.setImage(UIImage(systemName: "plus"), for: .normal)
        element.translatesAutoresizingMaskIntoConstraints = false
        element.addTarget(self, action: #selector(addCategoryButtonTapped), for: .touchUpInside)
        return element
    }()
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
     
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
       
        [addNewProductTitle, addCategoryButton, tableView].forEach { view.addSubview($0) }
    }
    
    // MARK: - Delete Category
        private func deleteCategory(at indexPath: IndexPath) {
            categories.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    
    // MARK: - Delete Alert
       private func showAlert(for indexPath: IndexPath) {
           let alert = UIAlertController(title: "Delete Category", message: "Are you sure you want to delete this category?", preferredStyle: .alert)
           alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
           alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
               self.deleteCategory(at: indexPath)
           }))
           present(alert, animated: true, completion: nil)
       }
    
    private func addCategory(name: String) {
            categories.append(name)
            tableView.reloadData()
        }
        
        // MARK: - Actions
        @objc private func addCategoryButtonTapped() {
            let alert = UIAlertController(title: "New Category", message: "Enter the name of the new category", preferredStyle: .alert)
            alert.addTextField { textField in
                textField.placeholder = "Category Name"
            }
            let addAction = UIAlertAction(title: "Add", style: .default) { [weak self] _ in
                if let categoryName = alert.textFields?.first?.text, !categoryName.isEmpty {
                    self?.addCategory(name: categoryName)
                }
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(addAction)
            alert.addAction(cancelAction)
            present(alert, animated: true, completion: nil)
        }
    

    

}

// MARK: - Setup Constraints
private extension CategoryVC {
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            
            addNewProductTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            addNewProductTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addNewProductTitle.widthAnchor.constraint(equalToConstant: 200),
            
            addCategoryButton.centerYAnchor.constraint(equalTo: addNewProductTitle.centerYAnchor),
            addCategoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addCategoryButton.widthAnchor.constraint(equalToConstant: 20),
            addCategoryButton.heightAnchor.constraint(equalToConstant: 20),
            
            tableView.topAnchor.constraint(equalTo: addNewProductTitle.bottomAnchor, constant: 20),
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
            tableView.deselectRow(at: indexPath, animated: true)
            showAlert(for: indexPath)
        }
}

