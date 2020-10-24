
import UIKit
import WebKit

protocol WKWebViewManagerDelegate: class {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!)
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error)
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView)
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void)
}
class WKWebViewManager: NSObject {
    weak var delegate: WKWebViewManagerDelegate?
    class func setupWebView(with frame: CGRect, urlString: String? = nil,
                            htmlString: String? = nil, baseURL: URL? = nil) -> WKWebView {
        let wkWebview = WKWebView.init(frame: frame, configuration: WKWebViewManager.getWebConfig())
        wkWebview.tag = 1001
        wkWebview.translatesAutoresizingMaskIntoConstraints = false
        wkWebview.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        if  urlString != nil {
            if let url = URL.init(string: urlString ?? "") {
            let urlRequest = URLRequest(url: url)
                wkWebview.load(urlRequest)
            }
        } else if htmlString != nil {
            wkWebview.loadHTMLString(htmlString ?? "", baseURL: baseURL)
        }
        return wkWebview
    }
    class func setupMapWebView(with frame: CGRect) -> WKWebView? {
        var wkWebview: WKWebView?
        if let url = URL.init(string: String.MAPURL) {
            wkWebview = USSRWS.shared.webviewPreloader.webview(for: url)
            wkWebview?.frame = frame
        }
        wkWebview?.tag = 1001
        wkWebview?.translatesAutoresizingMaskIntoConstraints = false
        wkWebview?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return wkWebview
    }
    class func getWebConfig() -> WKWebViewConfiguration {
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = true
        let configuration = WKWebViewConfiguration()
        configuration.preferences = preferences
        if #available(iOS 10.0, *) {
            configuration.dataDetectorTypes = [.link, .phoneNumber]
        } else {
            // Fallback on earlier versions
        }
        return configuration
    }
}
// MARK: - WKNavigationDelegate,WKUIDelegate
extension WKWebViewManager: WKNavigationDelegate, WKUIDelegate {
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        print("webViewWebContentProcessDidTerminate")
        delegate?.webViewWebContentProcessDidTerminate(webView)
    }
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print("didCommit")
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("didFinish")
        //webView.allowsBackForwardNavigationGestures = true/
        delegate?.webView(webView, didFinish: navigation)
    }
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("didStartProvisionalNavigation")
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("didFail")
        delegate?.webView(webView, didFail: navigation, withError: error)
    }
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        print("didReceiveServerRedirectForProvisionalNavigation")
    }
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print("didFailProvisionalNavigation")
    }
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge,
                 completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        print("didReceive challenge")
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
            let cred = URLCredential(trust: challenge.protectionSpace.serverTrust!)
            completionHandler(.useCredential, cred)
        } else {
            completionHandler(.performDefaultHandling, nil)
        }
    }
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        print("decidePolicyFor navigationAction")
        delegate?.webView(webView, decidePolicyFor: navigationAction, decisionHandler: decisionHandler)
        decisionHandler(.allow)
    }
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse,
                 decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        print("decidePolicyFor navigationResponse")
        decisionHandler(.allow)
    }
}
