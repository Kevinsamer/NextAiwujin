import UIKit

extension UISearchBar {
    
    var textField: UITextField? {
        if #available(iOS 13.0, *){
            return self.searchTextField
        }else{
            return value(forKey: "searchField") as? UITextField
        }
    }
    
    func setSearchIcon(image: UIImage) {
        setImage(image, for: .search, state: .normal)
    }
    
    func setClearIcon(image: UIImage) {
        setImage(image, for: .clear, state: .normal)
    }
}
