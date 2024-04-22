import UIKit

extension UIView {
    
    /// needs to be added to every screen contains a text field
    func hideKeyboard() {
        let tap: UIGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIView.endEditing))
        self.addGestureRecognizer(tap)
        tap.cancelsTouchesInView = false //иначе при тапе на ячейку задержка в несколько секунд
    }
    
  
    static func makeGreyView(cornerRadius: CGFloat?) -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.941, green: 0.949, blue: 0.945, alpha: 1)
        view.layer.cornerRadius = cornerRadius ?? 0
        view.translatesAutoresizingMaskIntoConstraints = false

      /// grey button
    static func makeView(textLabel: String, textColor: UIColor, nameMarker: String, colorMarker: UIColor) -> UIView {
        
        let view = UIView()
        
        view.layer.cornerRadius = 12
        view.backgroundColor = UIColor.lightViolet
        view.tintColor = UIColor.darkGray
        view.translatesAutoresizingMaskIntoConstraints = false
        
        // Создание и настройка надписи
        let label = UILabel.makeLabel(text: textLabel,
                                      font: UIFont.systemFont(ofSize: 16, weight: .semibold),
                                      textColor: textColor,
                                      numberOfLines: 1,
                                      alignment: .left)
        
        // Создание и настройка метки
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: nameMarker)
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = colorMarker
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(label)
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.centerXAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            
            view.heightAnchor.constraint(equalToConstant: 56)
        ])
        return view
    }

      /// grey button
    static func makeGreyButton(textLabel: String, 
                         textColor: UIColor,
                         nameMarker: String,
                         colorMarker: UIColor) -> UIView {

        let view = UIView()
        
        view.layer.cornerRadius = 12
        view.backgroundColor = UIColor.lightViolet
        view.tintColor = UIColor.darkGray
        view.translatesAutoresizingMaskIntoConstraints = false

        /// setup label
        let label = UILabel.makeLabel(text: textLabel,
                                      font: UIFont.systemFont(ofSize: 16, weight: .semibold),
                                      textColor: textColor,
                                      numberOfLines: 1,
                                      alignment: .left)
        
        /// setup button image
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: nameMarker)
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = colorMarker
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(label)
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.centerXAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            
            view.heightAnchor.constraint(equalToConstant: 56)
        ])
        return view
    }
}
