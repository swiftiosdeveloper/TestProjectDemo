

struct APIResponseKey {
    static let kData = "data"
    static let kMessgae = "message"
    static let kStatusCode = "statusCode"
}

struct APIHeaderFeild
{
    static var TokenBearer = "Bearer"
    static var Authorization = "Authorization"
    static var Content = "Content-Type"
    static var ContentType = "application/json"  //"application/x-www-form-urlencoded"
    static var ContentType_formdata = "multipart/form-data"
    static var ImageMimeType:ImageMimeType = .JPEG
}

struct ErrorMessages {
    struct Msg
    {
        static let kRequestTimeMsg = "The Request Timed out."
        static let kPlzTryAgainMsg = "Please try again after sometime."
        static let kInternetNotConnectedMsg = "No Internet! Please connect to active internet connection."
        static let kBadRequestMsg = "Bad Request"
        static let kSomethingWentWrongMsg = "Please try again after sometime."
        static let kInternetConnectionLostMsg = "The network connection was lost."

        static let k_ERR_401 = 401
        static let k_ERR_500 = 500
        static let k_ERR_404 = 404
        
        static let k_ERR_401_MSG = "Unauthorized User."
        static let k_ERR_500_MSG = "Server Internal Error."
        static let k_ERR_404_MSG = "Requested URL not found."
    }
}
