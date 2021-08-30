
import ArgoKit
import MJRefresh
extension ArgoKit.ScrollView {
    
    /// Get MJRefreshHeader
    var mj_header: MJRefreshHeader? {
        if let view = self.node?.view as? UIScrollView{
            return view.header
        }
        return nil
    }
    
    /// Get MJRefreshFooter
    var mj_footer: MJRefreshFooter? {
        if let view = self.node?.view as? UIScrollView{
            return view.footer
        }
        return nil
    }
    
    /// Set MJRefreshHeader
    /// - Parameter header: MJRefreshHeader
    /// - Returns: Self
    @discardableResult
    func mj_header(_ header: MJRefreshHeader?) -> Self {
        if let view = self.node?.view as? UIScrollView {
            view.header = header
        } else {
            addAttribute(#selector(setter: UIScrollView.header), header)
        }
        return self
    }
    
    
    /// Set MJRefreshFooter
    /// - Parameter footer: MJRefreshFooter
    /// - Returns: Self
    @discardableResult
    func mj_footer(_ footer: MJRefreshFooter?) -> Self {
        if let view = self.node?.view as? UIScrollView {
            view.footer = footer
        } else {
            addAttribute(#selector(setter: UIScrollView.footer), footer)
        }
        return self
    }
}
