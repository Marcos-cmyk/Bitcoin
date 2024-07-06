//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import WebKit
extension Bitcoin_V1: WKNavigationDelegate {
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if self.showLog { print("didFinish") }
    }

    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        if self.showLog { print("error = \(error)") }
    }

    public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        if self.showLog { print("didStartProvisionalNavigation ") }
    }
}

public class Bitcoin_V1: NSObject {
    var webView: WKWebView!
    var bridge: BTCWebViewJavascriptBridge!
    public var isSuccess: Bool = false
    var onCompleted: ((Bool) -> Void)?
    var showLog: Bool = true
    override public init() {
        super.init()
        self.webView = WKWebView(frame: .zero, configuration: WKWebViewConfiguration())
        self.webView.navigationDelegate = self
        self.webView.configuration.preferences.setValue(true, forKey: "allowFileAccessFromFileURLs")
        self.bridge = BTCWebViewJavascriptBridge(webView: self.webView,isHookConsole: false)
    }

    deinit {
        print("\(type(of: self)) release")
    }

    public func setup(showLog: Bool = true,onCompleted: ((Bool) -> Void)? = nil) {
        self.onCompleted = onCompleted
        self.showLog = showLog
        #if !DEBUG
        self.showLog = false
        #endif
        self.bridge.register(handlerName: "generateBitcoin") { [weak self] _, _ in
            guard let self = self else { return }
            self.isSuccess = true
            self.onCompleted?(true)
        }
        let htmlSource = self.loadBundleResource(bundleName: "Bitcoin_alpha", sourceName: "/index.html")
        let url = URL(fileURLWithPath: htmlSource)
        self.webView.loadFileURL(url, allowingReadAccessTo: url)
    }

    func loadBundleResource(bundleName: String, sourceName: String) -> String {
        let bundleResourcePath = Bundle.module.path(forResource: bundleName, ofType: "bundle")
        return bundleResourcePath! + sourceName
    }

    // MARK: getBTCBalance
    public func getBTCBalance(address: String, onCompleted: ((Bool, String,String) -> Void)? = nil) {
        let params: [String: String] = ["address": address]
        self.bridge.call(handlerName: "getBTCBalance", data: params) { response in
            if self.showLog { print("response = \(String(describing: response))") }
            guard let temp = response as? [String: Any] else {
                onCompleted?(false, "",  "Invalid response format")
                return
            }
            if let state = temp["state"] as? Bool, state,
               let balance = temp["balance"] as? String
            {
                onCompleted?(state,  balance, "")
            } else if let error = temp["error"] as? String {
                onCompleted?(false, "",  error)
            } else {
                onCompleted?(false, "",  "Unknown response format")
            }
        }
    }
    
    // MARK: transfer
    public func transfer(privateKey: String,
                            outputs:[[String:String]],
                            fee: Double,
                            onCompleted: ((Bool, String,String) -> Void)? = nil)
    {
        let params: [String: Any] = ["privateKey": privateKey,
                                     "fee":fee,
                                     "outputs": outputs]
        self.bridge.call(handlerName: "BTCTransfer", data: params) { response in
            if self.showLog { print("response = \(String(describing: response))") }
            
            guard let temp = response as? [String: Any] else {
                onCompleted?(false, "", "Invalid response format")
                return
            }
            if let state = temp["state"] as? Bool, state,
               let hash = temp["hash"] as? String
            {
                onCompleted?(state, hash, "")
            } else if let error = temp["error"] as? String {
                onCompleted?(false,"", error)
            } else {
                onCompleted?(false, "","Unknown response format")
            }
        }
    }

    // MARK: estimateBtcTransferFee
    public func estimateBtcTransferFee(inputsCount:Int = 1,outputsCount:Int = 1,
                               onCompleted: ((Bool, Double,Double,Double,String) -> Void)? = nil)
    {
        let params: [String: Any] = ["inputsCount":inputsCount,
                                      "outputsCount": outputsCount]
        self.bridge.call(handlerName: "estimateFee", data: params) { response in
            if self.showLog { print("response = \(String(describing: response))") }
            guard let temp = response as? [String: Any] else {
                onCompleted?(false, 0.0,0.0,0.0, "Invalid response format")
                return
            }
            if let state = temp["state"] as? Bool, state,
               let high = temp["high"] as? Double,
               let medium = temp["medium"] as? Double,
               let low = temp["low"] as? Double
            {
                onCompleted?(state,high,medium,low,"")
            } else if let error = temp["error"] as? String {
                onCompleted?(false,0.0,0.0,0.0, error)
            }  else {
                onCompleted?(false,0.0,0.0,0.0, "Unknown response format")
            }
        }
    }
    
    // MARK: isValidBitcoinAddress
    public func isValidBitcoinAddress(address: String, onCompleted: ((Bool,String) -> Void)? = nil) {
        let params: [String: String] = ["address": address]
        self.bridge.call(handlerName: "isValidBitcoinAddress", data: params) { response in
            guard let temp = response as? [String: Any] else {
                onCompleted?(false,"Invalid response format")
                return
            }
            if let state = temp["state"] as? Bool, state{
                onCompleted?(state,"")
                return
            }
            else if let error = temp["error"] as? String {
                onCompleted?(false,error)
            } else {
                onCompleted?(false,"Unknown response format")
            }
        }
    }
    
    // MARK: createAccount
    public func createAccount(onCompleted: ((Bool, String, String, String, String) -> Void)? = nil) {
        let params = [String: String]()
        self.bridge.call(handlerName: "createAccount", data: params) { response in
            if self.showLog { print("response = \(String(describing: response))") }

            guard let temp = response as? [String: Any] else {
                onCompleted?(false, "", "", "", "Invalid response format")
                return
            }

            if let state = temp["state"] as? Bool, state,
               let privateKey = temp["privateKey"] as? String,
               let address = temp["address"] as? String,
               let mnemonic = temp["mnemonic"] as? String
            {
                onCompleted?(state, address, privateKey, mnemonic, "")
            } else if let error = temp["error"] as? String {
                onCompleted?(false, "", "", "", error)
            } else {
                onCompleted?(false, "", "", "", "Unknown response format")
            }
        }
    }
    
    // MARK: importAccountFromMnemonic
    public func importAccountFromMnemonic(mnemonic:String,onCompleted: ((Bool, String, String, String, String) -> Void)? = nil) {
        let params: [String: String] = ["mnemonic": mnemonic]

        self.bridge.call(handlerName: "importAccountFromMnemonic", data: params) { response in
            if self.showLog { print("response = \(String(describing: response))") }

            guard let temp = response as? [String: Any] else {
                onCompleted?(false, "", "", "", "Invalid response format")
                return
            }
            if let state = temp["state"] as? Bool, state,
               let privateKey = temp["privateKey"] as? String,
               let mnemonic = temp["mnemonic"] as? String,
               let address = temp["address"] as? String
            {
                onCompleted?(state, address, privateKey, mnemonic, "")
            } else if let error = temp["error"] as? String {
                onCompleted?(false, "", "", "", error)
            } else {
                onCompleted?(false, "", "", "", "Unknown response format")
            }
        }
    }
    
    // MARK: importAccountFromPrivateKey
    public func importAccountFromPrivateKey(privateKey:String,onCompleted: ((Bool, String, String, String) -> Void)? = nil) {
        
        let params: [String: String] = ["privateKey": privateKey]
        
        self.bridge.call(handlerName: "importAccountFromPrivateKey", data: params) { response in
            if self.showLog { print("response = \(String(describing: response))") }

            guard let temp = response as? [String: Any] else {
                onCompleted?(false, "", "","Invalid response format")
                return
            }
            if let state = temp["state"] as? Bool, state,
               let privateKey = temp["privateKey"] as? String,
               let address = temp["address"] as? String
            {
                onCompleted?(state, address, privateKey, "")
            } else if let error = temp["error"] as? String {
                onCompleted?(false, "", "",  error)
            } else {
                onCompleted?(false, "", "", "Unknown response format")
            }
        }
    }
}
