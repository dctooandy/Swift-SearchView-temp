//
//  BasicExtension.swift
//  Swift-SearchGitHub
//
//  Created by AndyChen on 2021/3/17.
//

import Foundation
import WebKit
import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Toaster
import Kingfisher

extension UIResponder {
    
    func next<T: UIResponder>(_ type: T.Type) -> T? {
        return next as? T ?? next?.next(type)
    }
}
extension UITableView {
    func dequeueCell<T>(type: T.Type, indexPath: IndexPath) -> T {
        let cell = self.dequeueReusableCell(withIdentifier: NSStringFromClass(type as! AnyClass), for: indexPath) as! T
        return cell
    }
    
    func dequeueHeaderFooter<T>(type: T.Type) -> T {
        let headerFooter = self.dequeueReusableHeaderFooterView(withIdentifier: NSStringFromClass(type as! AnyClass)) as! T
        return headerFooter
    }
    
    func registerCell(type: AnyClass) {
        self.register(type, forCellReuseIdentifier: NSStringFromClass(type))
    }
    
    func registerHeaderFooter(type: AnyClass) {
        self.register(type, forHeaderFooterViewReuseIdentifier: NSStringFromClass(type))
    }
    
    func registerXibCell(type: AnyClass) {
        self.register(UINib(nibName: "\(type)", bundle: nil), forCellReuseIdentifier: NSStringFromClass(type))
    }
    
    func registerXibHeader(type: AnyClass) {
        self.register(UINib(nibName: "\(type)", bundle: nil), forHeaderFooterViewReuseIdentifier: NSStringFromClass(type))
    }
    
    func refrashControl(tintColor: UIColor) -> UIRefreshControl{
        let refrashControl = UIRefreshControl()
        //let attributes = [NSAttributedString.Key.foregroundColor: UIColor.yellow]
        //refrashController.attributedTitle = NSAttributedString(string: "正在更新", attributes: attributes)
        refrashControl.tintColor = tintColor
        refrashControl.backgroundColor = .clear
        self.addSubview(refrashControl)
        return refrashControl
    }
    func footerRefrashView() -> UIView{
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: pWidth(40)))
        view.backgroundColor = .clear
        let activity = UIActivityIndicatorView()
        activity.style = .medium
        activity.backgroundColor = .clear
        view.addSubview(activity)
        activity.snp.makeConstraints { (maker) in
            maker.width.equalTo(pWidth(40))
            maker.height.equalTo(pWidth(40))
            maker.center.equalToSuperview()
        }
        activity.startAnimating()
        return view
    }
    func scrollToBottom(){

        DispatchQueue.main.async {
            let indexPath = IndexPath(
                row: self.numberOfRows(inSection:  self.numberOfSections-1) - 1,
                section: self.numberOfSections - 1)
            if self.hasRowAtIndexPath(indexPath: indexPath) {
                self.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
        }
    }

    func scrollToTop() {

        DispatchQueue.main.async {
            let indexPath = IndexPath(row: 0, section: 0)
            if self.hasRowAtIndexPath(indexPath: indexPath) {
                self.scrollToRow(at: indexPath, at: .top, animated: false)
           }
        }
    }

    func hasRowAtIndexPath(indexPath: IndexPath) -> Bool {
        return indexPath.section < self.numberOfSections && indexPath.row < self.numberOfRows(inSection: indexPath.section)
    }
}

extension UITableViewCell {
    
    var tableView: UITableView? {
        return next(UITableView.self)
    }
    
    var indexPath: IndexPath? {
//        return tableView?.indexPath(for: self)
        return superTableView?.indexPath(for: self)
    }
    var superTableView : UITableView?{
        var view = self.superview
        while (view != nil) , (view?.isKind(of: UITableView.self) == false) {
            view = view?.superview
        }
        return (view as! UITableView)
    }
}
extension UICollectionView {
    func dequeueCell<T>(type:T.Type, indexPath:IndexPath) -> T {
        let cell = self.dequeueReusableCell(withReuseIdentifier:NSStringFromClass(type as! AnyClass),
                                            for:indexPath) as! T
        return cell
    }
    
    func dequeueHeader<T>(type:T.Type, indexPath:IndexPath) -> T {
        let header = self.dequeueReusableSupplementaryView(ofKind:UICollectionView.elementKindSectionHeader,
                                                           withReuseIdentifier:NSStringFromClass(type as! AnyClass), for:indexPath) as! T
        return header
    }
    
    func dequeueFooter<T>(type:T.Type, indexPath:IndexPath) -> T {
        let footer = self.dequeueReusableSupplementaryView(ofKind:UICollectionView.elementKindSectionFooter,
                                                           withReuseIdentifier:NSStringFromClass(type as! AnyClass), for:indexPath) as! T
        return footer
    }
    
    func registerCell(type:AnyClass) {
        self.register(type, forCellWithReuseIdentifier:NSStringFromClass(type))
    }
    
    func registerXibCell(type:AnyClass) {
        self.register(UINib(nibName: "\(type)", bundle: nil), forCellWithReuseIdentifier: NSStringFromClass(type))
    }
    
    func registerHeader(type:AnyClass) {
        self.register(type,
                      forSupplementaryViewOfKind:UICollectionView.elementKindSectionHeader,
                      withReuseIdentifier:NSStringFromClass(type))
    }
    func registerXibHeader(type:AnyClass) {
        self.register(UINib(nibName: "\(type)", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: NSStringFromClass(type))
    
    }
    
    func registerFooter(type:AnyClass) {
        self.register(type,
                      forSupplementaryViewOfKind:UICollectionView.elementKindSectionFooter,
                      withReuseIdentifier:NSStringFromClass(type))
    }
    func registerXibFooter(type:AnyClass) {
          self.register(UINib(nibName: "\(type)", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: NSStringFromClass(type))
    }
    
    
    func pagingInCenter(_ scrollView:UIScrollView,
                        targetContentOffset:UnsafeMutablePointer<CGPoint>,
                        cellWidth:CGFloat,
                        itemSpacing:CGFloat,
                        leftEdgeInset:CGFloat) {
        let pageWidth:Float = Float(cellWidth + itemSpacing)
        // width + space
        let currentOffset:Float = Float(scrollView.contentOffset.x)
        let targetOffset:Float = Float(targetContentOffset.pointee.x)
        var newTargetOffset:Float = 0
        if targetOffset > currentOffset {
            newTargetOffset = ceilf(targetOffset / pageWidth) * pageWidth
        } else if (targetOffset == currentOffset) {
            newTargetOffset = roundf(targetOffset / pageWidth) * pageWidth
        } else {
            newTargetOffset = floorf(targetOffset / pageWidth) * pageWidth
        }
        if newTargetOffset < 0 {
            newTargetOffset = 0
        } else if (newTargetOffset > Float(scrollView.contentSize.width)) {
            newTargetOffset = Float(Float(scrollView.contentSize.width))
        }
        
        let leftGap = Float((UIScreen.main.bounds.width - cellWidth) / 2 - leftEdgeInset)
        targetContentOffset.pointee.x = CGFloat(newTargetOffset - leftGap)
    }
    func scrollToBottom(){

        DispatchQueue.main.async {
            let indexPath = IndexPath(
                row: self.numberOfItems(inSection:  self.numberOfSections-1) - 1,
                section: self.numberOfSections - 1)
            if self.hasRowAtIndexPath(indexPath: indexPath) {
                self.scrollToItem(at: indexPath, at: .bottom, animated: true)
            }
        }
    }

    func scrollToTop() {

        DispatchQueue.main.async {
            let indexPath = IndexPath(row: 0, section: 0)
            if self.hasRowAtIndexPath(indexPath: indexPath) {
                self.scrollToItem(at: indexPath, at: .top, animated: false)
           }
        }
    }

    func hasRowAtIndexPath(indexPath: IndexPath) -> Bool {
        return indexPath.section < self.numberOfSections && indexPath.row < self.numberOfItems(inSection: indexPath.section)
    }
}

extension UICollectionViewCell {
    
    var collectionView: UICollectionView? {
        return next(UICollectionView.self)
    }
    
    var indexPath: IndexPath? {
//        return tableView?.indexPath(for: self)
        return superCollectionView?.indexPath(for: self)
    }
    var superCollectionView : UICollectionView?{
        var view = self.superview
        while (view != nil) , (view?.isKind(of: UICollectionView.self) == false) {
            view = view?.superview
        }
        return (view as! UICollectionView)
    }
}

protocol Nibloadable {

}

extension UIView: Nibloadable {
    
}

extension Nibloadable where Self : UIView
{
    /*
     static func loadNib(_ nibNmae :String = "") -> Self{
     let nib = nibNmae == "" ? "\(self)" : nibNmae
     return Bundle.main.loadNibNamed(nib, owner: nil, options: nil)?.first as! Self
     }
     */
    static func loadNib(_ nibNmae :String? = nil) -> Self{
        return Bundle.main.loadNibNamed(nibNmae ?? "\(self)", owner: nil, options: nil)?.first as! Self
    }
    
    func loadNibView(_ nibNmae :String? = nil) -> UIView {
        return Bundle.main.loadNibNamed(nibNmae ?? "\(self)", owner: nil, options: nil)?.first as! UIView
    }
}

extension Nibloadable where Self : UIViewController
{
    /*
     static func loadNib(_ nibNmae :String = "") -> Self{
     let nib = nibNmae == "" ? "\(self)" : nibNmae
     return Bundle.main.loadNibNamed(nib, owner: nil, options: nil)?.first as! Self
     }
     */
    static func loadNib(_ nibNmae :String? = nil) -> Self{
        return UINib(nibName: nibNmae ?? "\(self)", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! Self
    }
}

extension Array {
    func indexOfObject(object : AnyObject) -> NSInteger {
        return (self as NSArray).index(of: object)
    }
}

extension NSMutableAttributedString {
    
    /// 對同一串文字中的特定幾個字設定不同顏色
    ///
    /// - Parameters:
    ///   - textForAttribute: 要更改顏色的文字
    ///   - color: 要更改顏色
    func setColorForText(textForAttribute: String, withColor color: UIColor) {
        let range: NSRange = self.mutableString.range(of: textForAttribute, options: .caseInsensitive)
        self.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
    }
}

extension URL {
    var queryDictionary: [String: String]? {
        guard let query = self.query else { return nil}
        
        var queryStrings = [String: String]()
        for pair in query.components(separatedBy: "&") {
            
            let key = pair.components(separatedBy: "=")[0]
            
            let value = pair
                .components(separatedBy:"=")[1]
                .replacingOccurrences(of: "+", with: " ")
                .removingPercentEncoding ?? ""
            
            queryStrings[key] = value
        }
        return queryStrings
    }
}

extension UIScrollView {
    // 鍵盤彈出將輸入框向上移動
    func scrollToKeyboardTop(keyboardHeight: CGFloat) {
        var contentInset:UIEdgeInsets = self.contentInset
        contentInset.bottom = keyboardHeight
        self.contentInset = contentInset
    }
    func updateContentView() {
        contentSize.height = subviews.sorted(by: {($0.frame.maxY + $0.frame.size.height)  < ($1.frame.maxY + $1.frame.size.height) }).last?.subviews.sorted(by: {($0.frame.maxY + $0.frame.size.height)  < ($1.frame.maxY + $1.frame.size.height) }).last?.frame.maxY ?? contentSize.height
    }
    func handleKeyBoardHeight(point : CGPoint)
    {
        self.setContentOffset(point, animated: true)
    }
}
// 漸層
extension CAGradientLayer {
    
    enum Point {
        case topRight, topLeft
        case bottomRight, bottomLeft
        case custion(point: CGPoint)
        
        var point: CGPoint {
            switch self {
            case .topRight: return CGPoint(x: 1, y: 0)
            case .topLeft: return CGPoint(x: 0, y: 0)
            case .bottomRight: return CGPoint(x: 1, y: 1)
            case .bottomLeft: return CGPoint(x: 0, y: 1)
            case .custion(let point): return point
            }
        }
    }
    
    convenience init(frame: CGRect, colors: [UIColor], startPoint: CGPoint, endPoint: CGPoint) {
        self.init()
        self.frame = frame
        self.colors = colors.map { $0.cgColor }
        self.startPoint = startPoint
        self.endPoint = endPoint
    }
    
    convenience init(frame: CGRect, colors: [UIColor], startPoint: Point, endPoint: Point) {
        self.init(frame: frame, colors: colors, startPoint: startPoint.point, endPoint: endPoint.point)
    }
    
    func createGradientImage() -> UIImage? {
        defer { UIGraphicsEndImageContext() }
        UIGraphicsBeginImageContext(bounds.size)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        render(in: context)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
extension UINavigationBar {
    func setGradientBackground(colors: [UIColor], startPoint: CAGradientLayer.Point = .topLeft, endPoint: CAGradientLayer.Point = .topRight) {
        var updatedFrame = bounds
        updatedFrame.size.height += self.frame.origin.y
        let gradientLayer = CAGradientLayer(frame: updatedFrame, colors: colors, startPoint: startPoint, endPoint: endPoint)
        setBackgroundImage(gradientLayer.createGradientImage(), for: UIBarMetrics.default)
    }
}

extension UIApplication {
    class func topViewController(base: UIViewController? = (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
//        if let presented = base?.presentedViewController {
//            return presented
//        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        if (base as? UITabBarController) != nil {
//            if let selected = tab.selectedViewController {
//                return topViewController(base: selected)
//            }
            return base
        }
        if let alert = base as? UIAlertController {
            return alert
        }
        return base
    }
    var statusBarUIView: UIView? {
        if #available(iOS 13.0, *) {
            let tag = 38482
            let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first

            if let statusBar = keyWindow?.viewWithTag(tag) {
                return statusBar
            } else {
                guard let statusBarFrame = keyWindow?.windowScene?.statusBarManager?.statusBarFrame else { return nil }
                let statusBarView = UIView(frame: statusBarFrame)
                statusBarView.tag = tag
                keyWindow?.addSubview(statusBarView)
                return statusBarView
            }
        } else if responds(to: Selector(("statusBar"))) {
            return value(forKey: "statusBar") as? UIView
        } else {
            return nil
        }
      }
}

extension Encodable {
    /// Encode into JSON and return `Data`
    func jsonData() throws -> Data {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        encoder.dateEncodingStrategy = .iso8601
        return try encoder.encode(self)
    }
    
    func asDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw NSError()
        }
        return dictionary
    }
    var dictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
}
extension Decodable {
    static func map(JSONString:String) -> Self? {
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(Self.self, from: Data(JSONString.utf8))
        } catch let error {
            print(error)
            return nil
        }
    }
}

extension UISearchBar {
    var textField : UITextField? {
        if #available(iOS 13.0, *) {
            return self.searchTextField
        } else {
            for view : UIView in (self.subviews[0]).subviews {
                if let textField = view as? UITextField {
                    return textField
                }
            }
        }
        return nil
    }
}
extension Toast {
  static func show(msg:String) {
    let toast = Toast(text: msg)
    toast.show()
  }
  
    static func showSuccess(msg:String) {
        let toast = Toast(text: msg)
        toast.view.textColor = .lightGray
        toast.show()
    }
    
}
extension UIImageView{
    
    func setImage(
        with resource: Resource?,
        placeholder: Placeholder? = nil,
        errorPlaceholder: UIImage? = nil,
        completeBlock:(() -> ())? = nil) {
        
        kf.cancelDownloadTask()
        kf.setImage(with: resource,
                    placeholder: placeholder,
                    options: nil, completionHandler:  { [weak self] result in
                        guard let strongSelf = self else { return }
                        switch result {
                        
                        case .success(let value):
                            
                            switch value.cacheType {
                            case .none:
                                if (completeBlock != nil)
                                {
                                    completeBlock!()
                                }
                                return
                            case .memory, .disk:
                                strongSelf.kf.cancelDownloadTask()
                                if (completeBlock != nil)
                                {
                                    completeBlock!()
                                }
                            }
                            
                        case .failure:
                            if let errorPlaceholder = errorPlaceholder {
                                strongSelf.image = errorPlaceholder
                            }
                        }
                    })
    }
}
extension String
{
    func toInt() -> Int {
        return Int(self) ?? 0
    }
    
    func toDouble() -> Double {
        return Double(self) ?? 0.0
    }
    /// 數字格式轉換你要的單位
    ///
    /// - Parameters:
    ///   - style: 單位類型
    ///   - minimumFractionDigits: 最少到小數第幾位
    /// - Returns: String
    func numberFormatter(_ style: NumberFormatter.Style , _ minimumFractionDigits: Int, locale: Locale = Locale(identifier: "th_TH") , withLocale : Bool = true) -> String {
        let num: Double = Double(self) ?? 0
        let formatter = NumberFormatter()
        formatter.numberStyle = style
        if withLocale == true
        {
            formatter.locale = locale
        }
        formatter.minimumFractionDigits = minimumFractionDigits
        formatter.maximumFractionDigits = minimumFractionDigits
        let str = formatter.string(from: NSNumber(value: num)) ?? "0.00"
        return str
    }
}
