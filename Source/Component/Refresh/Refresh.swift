
import ArgoKit
import MJRefresh
extension ArgoKit.ScrollView {
    
    @discardableResult
    func mj_header(_ header: MJRefreshHeader?) -> Self {
        addAttribute(#selector(setter: UIScrollView.header), header)
        return self
    }
    
    @discardableResult
    func mj_footer(_ footer: MJRefreshFooter?) -> Self {
        addAttribute(#selector(setter: UIScrollView.footer), footer)
        return self
    }
}
