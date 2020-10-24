

import Foundation

// MARK: - Enums
enum AppMode {
    case live, test, uat, uat1, uat2
    
    var hostURL: String {
        switch(self) {
        case .live:
            return ""
        case .test:
            return ""
        case .uat:
            return ""
        case .uat1:
            return ""
        case .uat2:
            return "" 
        }
    }
    
    var server: String {
        switch(self) {
        case .live: return "Prod"
        default: return "UAT"
        }
    }
}

enum OAuthType: String {
    case login
    case refreshToken = "refresh_token"
    case alreadyLogin
}

enum NetworkError: Error {
    case error(message: String)
    
    static var noInternet = NetworkError.error(message: InfoMessage.kConnectInternet)
    
    var message: String {
        switch self {
        case .error(let message):
            return message
        }
    }
}

enum PCInquiry: String {
    case lotNumber = "inquirybylotnumber"
    case modelNumber = "inquirybysuppliermodel"
    case itemNumber = "inquirybyitemnumber"
}

enum StockAPIReport: String {
    case barcode, stock, product, tray, interest
}

enum OptionType {
    case key, value, japValue
}

enum ContactInputMode: String {
    case email = "Email"
    case mail = "Mail"
    case phone = "Phone"
    case sms = "SMS"
    case social = "Social"
    
    init?(value: String) {
        self.init(rawValue: value == "Text" ? "SMS" : value)
    }
}

enum ContactInputModeProspect: String {
    case email = "Email"
    case phone = "Phone"
    case sms = "SMS"
    case mail = "Mail"
    
    init?(value: String) {
        self.init(rawValue: value == "Text" ? "SMS" : value)
    }
}

enum PhoneCountry: String {
    
    case my = "+60 Malaysia"
    case au = "+61 Australia"
    case nz = "+64 New Zealand"
    case sg = "+65 Singapore"
    case th = "+66 Thailand"
    case jp = "+81 Japan"
    case hk = "+852 Hong Kong"
    
    static let countries = [PhoneCountry.my, .au, .nz, .sg, .th, .jp, .hk]
    
    init?(value: String) {
        self.init(rawValue: PhoneCountry.countries.first(where: { $0.rawValue.hasPrefix(value) })?.rawValue ?? "")
    }
    
    /* Example:
        - MY: +60 00 000 0000 xxx
        - AU: +61 000 000 000 xxx
        - NZ: +64 000 0000 xxx
        - SG: +65 0000 0000 xxx
        - TH: +66 00 000 0000 xxx
        - JP: +81 0 0000 0000 xxx
        - HK: +852 0000 0000 xxx
    */
    var numberFormatter: String {
        switch self {
        case .my, .th: return "XX XXX XXXX"
        case .au: return "XXX XXX XXX"
        case .nz: return "XXX XXXX"
        case .sg, .hk: return "XXXX XXXX"
        case .jp: return "X XXXX XXXX"
        }
    }
    
    var minDigitsCount: Int {
        return self.numberFormatter.replacingOccurrences(of: " ", with: "").count
    }
    
    func isValidNumber(_ number: String) -> Bool {
        return number.count >= self.numberFormatter.count
    }
}

enum ChartType: String {    
    case barChart = "bar chart"
    case stackBarChart = "group by chart"
    case horizontalBarChart = "horizontal bar chart"
    case horizontalStackBarChart = "horizontal group by chart"
    case pieChart = "pie chart"
    case lineChart = "line chart"
    case funnelChart = "funnel chart"
    case none = "none"
}

enum ReportOperator: String {
    case `is`, is_not, one_of, not_one_of, empty, not_empty, equals, not_equals_str, contains, does_not_contain, starts_with, ends_with, tp_yesterday, tp_today, tp_tomorrow, tp_last_7_days, tp_next_7_days, tp_last_month, tp_this_month, tp_next_month, tp_last_30_days, tp_next_30_days, tp_last_quarter, tp_this_quarter, tp_next_quarter, tp_last_year, tp_this_year, tp_next_year
    
    var label: String {
        switch self {
        case .is: return "Is"
        case .is_not: return "Is Not"
        case .one_of: return "Is One Of"
        case .not_one_of: return "Is Not One Of"
        case .empty: return "Is Empty"
        case .not_empty: return "Is Not Empty"
        case .equals: return "Equals"
        case .not_equals_str: return "Does Not Equal"
        case .contains: return "Contains"
        case .does_not_contain: return "Does Not Contain"
        case .starts_with: return "Starts With"
        case .ends_with: return "Ends With"
        case .tp_yesterday: return "Yesterday"
        case .tp_today: return "Today"
        case .tp_tomorrow: return "Tomorrow"
        case .tp_last_7_days: return "Last 7 Days"
        case .tp_next_7_days: return "Next 7 Days"
        case .tp_last_month: return "Last Month"
        case .tp_this_month: return "This Month"
        case .tp_next_month: return "Next Month"
        case .tp_last_30_days: return "Last 30 Days"
        case .tp_next_30_days: return "Next 30 Days"
        case .tp_last_quarter: return "Last Quarter"
        case .tp_this_quarter: return "This Quarter"
        case .tp_next_quarter: return "Next Quarter"
        case .tp_last_year: return "Last Year"
        case .tp_this_year: return "This Year"
        case .tp_next_year: return "Next Year"
        }
    }
    
    var showValue: Bool {
        switch self {
        case .is, .is_not, .one_of, .not_one_of, .equals, .not_equals_str, .contains, .does_not_contain, .starts_with, .ends_with:
            return true
        default: return false
        }
    }
}

enum FieldType {
    case text
    case phone
    case fixNumber
    case number
    case textContains
    case boolean
    case selection
    case multi
    case containsMulti
    case date
}

enum AuditFieldType: String {
    case text
    case int
    case decimal
    case currency
    case bool
    case date
    case datetime
    case `enum`
    case multienum
    case image
    case file
    
    init?(value: String) {
        if let type = AuditFieldType(rawValue: value) {
            self = type
        }
        else if ["id", "name", "varchar", "phone", "email", "relate"].contains(value) {
            self = .text
        }
        else if value == "datetimecombo" {
            self = .datetime
        }
        else {            
            return nil
        }
    }
}

enum FilterOperator: String {
    case equals = "exactly matches"
    case starts = "starts with"
    case containsText = "starts with "
    case equalTo = "is equal to"
    case notEqualTo = "is not equal to"
    case gt = "is greater than"
    case lt = "is less than"
    case gte = "is greater than or equal to"
    case lte = "is less than or equal to"
    case `is` = "is"
    case `in` = "is any of"
    case notIn = "is not any of"
    case contains = "is any of "
    case notContains = "is not any of "
    case empty = "is empty"
    case notEmpty = "is not empty"
    case before = "before"
    case after = "after"
    case yesterday = "yesterday"
    case today = "today"
    case tomorrow = "tomorrow"
    case last7Days = "last 7 days"
    case next7Days = "next 7 days"
    case last30Days = "last 30 days"
    case next30Days = "next 30 days"
    case lastMonth = "last month"
    case thisMonth = "this month"
    case nextMonth = "next month"
    case lastYear = "last year"
    case thisYear = "this year"
    case nextYear = "next year"
    case none = "none"
}

enum ProspectFormStep {
    case search, internalUse, personal, address, communication, pdpa
}

enum ClientFormStep {
    case search, internalUse, personal, address, communication, others, pdpa
}

enum RepairFormStep {
    case serviceInformation, articleDesc, condition, observations, serviceRequested, termsAndConditions, clientConfirmation, boutiqueConfirmation, repairInfo, inProcess, completion, transaction
}

enum RepairWizardStep {
    case client, po, repair
}

enum AddInterestWizardStep {
    case profile, interests
}

enum RepairTimelineType: String {
    case movement = "repair_movement"
    case ack = "acknowledgement"
    case none
}

enum RepairAckFormStep {
    case repairDetail, releasedBy, receivedBy
}

enum EnquireFormStep {
    case contact, enquiry, followUp
}

enum SpecialSaleFormStep {
    case client, model, details, document
}

enum GuestFormStep {
    case contact, event
}

enum ProductOwnershipFormStep {
    case search, product, transaction, warranty
}

enum ModuleDetail {
    case normal, more, other
}

enum PCStockDetail {
    case normal, authentication, totalStock(stock: BoutiqueStock), boutique(stock: Stock)
}

enum DocumentDetail {
    case normal, document1, document2, other
}

enum EventDetail {
    case normal, eventGuest, accompanyingGuest
}

enum EventGuestType {
    case eventGuest, accompanyingGuest
}

enum EventGuestDetails {
    case topInfo, sectionTitle, bottomInfo
    case guests(accompanyingGuest: AccompanyingGuest)
}

indirect enum RepairDetail {
    case info, productOwnership, articleDesc, warrantyCardImage, condition, articleImage, observations, serviceRequested, repairInProgress, repairCompletion, savStatus, repairAssessment, transactionDetails, onCredit, ackStatus
    case sectionHeader(header: String)
    case section(ecSection: RepairECSection)
    case acknowledgement(ack: RepairAck)
    case repairMovement(sav: RepairMovement)
}

enum SwipeActionDescriptor {
    case attended, notAttended
    
    var properties: (title: String, image: UIImage?, color: UIColor) {
        switch self {
        case .attended: return (title: "Attended", image: UIImage(named: "attend"), color: UIColor.AppColor.attended)
        case .notAttended: return (title: "Did Not Attend", image: UIImage(named: "not_attend"), color: UIColor.AppColor.notAttended)
        }
    }
}

enum MoreItem: String {
    case edit = "Edit"
    case viewChangeLog = "View Change Log"
    case m3Address = "M3 Addresses"
    case linkExistingRecord = "Link Existing Record"
    case updateRelationship = "Update Relationship"
    case nomosClub = "NOMOS Club Membership"
    case registerToM3 = "Register to M3"
    case createRelatedRecord = "Create Related Record"
    case prospectForm = "Prospect Form"
    case clientForm = "Client Form"
    case convertToClient = "Convert To Client"
    case serviceRepairForm = "Service Repair Form"
    case addNewRepair = "Add New Repair"
    case updateStatus = "Update Status"
    case addAccompanyingGuest = "Add Accompanying Guest"
    case approveRequest = "Approve Request"
    case rejectRequest = "Reject Request"
    case withdrawRequest = "Withdraw Request"
    case delete = "Delete"
    case print = "Print"
        
    var imageName: String {
        switch self {
        case .edit, .updateRelationship, .updateStatus:
            return "edit"
        case .m3Address:
            return "ic_m3_address"
        case .viewChangeLog:
            return "recent"
        case .linkExistingRecord:
            return "link_existing_record"
        case .nomosClub:
            return "ic_nomos_club"
        case .registerToM3:
            return "register_to_m3"
        case .createRelatedRecord:
            return "create_related_record"
        case .prospectForm:
            return "prospect_form"
        case .clientForm:
            return "client_form"
        case .convertToClient:
            return "convert_to_client"
        case .serviceRepairForm, .addNewRepair:
            return "service_repair_form"
        case .addAccompanyingGuest:
            return "add_accompanying_guest"
        case .approveRequest:
            return "attend"
        case .rejectRequest:
            return "not_attend"
        case .withdrawRequest:
            return "ic_withdraw"
        case .delete:
            return "delete"
        case .print:
            return "print"
        }
    }
}

enum RelatedView: String{
    case info, prospect, interest, note, document, task, call, transaction, enquiry, repair, meeting, clients, boutique, ack, image, quotation
    case specialSale = "special_sale_request"
    case eventGuest = "event_guest"
    case productOwnership = "product_ownership"
    case repairHistory = "repair_history"
    case statusTracking = "status_tracking"
    case repairDetails = "repair_details"
    case pcStock = "pc_stock"
    case users = ""

    var title: String {
        switch self {
        case .prospect:
            return "Prospects"
        case .clients:
            return "Clients"
        case .users:
            return "Users"
        default:
            return ""
        }
    }
}

enum Module: String {
    case boutique = "thg_Shops"
    case employee = "Employees"
    case dailyWalkIn = "thg_DWI"
    case repairCentres = "thg_Repair_Centres"
    case brand = "thg_Brand_Managements"
    case prospect = "Leads"
    case client = "Contacts"
    case m3Register = "thg_M3_Customer_Mapping"
    case address = "thg_Address"
    case repair = "Cases"
    case quotation = "thg_Quotations"
    case enquiry = "thg_Enquiries"
    case interest = "thg_Interaction_History"
    case specialSale = "thg_Special_Sales_Requests"
    case productCatalog = "ProductTemplates"
    case event = "SIN_Postings"
    case eventChecklist = "thg_Events_Checklists"
    case eventGuest = "SIN_Applied_Sub_Posting"
    case accompanyingGuest = "thg_Guests"
    case call = "Calls"
    case meeting = "Meetings"
    case task = "Tasks"
    case document = "Documents"
    case note = "Notes"
    case transaction = "Opportunities"
    case productOwnership = "thg_Product_Ownerships"
    case none = "None"
    
    static let allCases: [Module] = [.boutique, .prospect, .client, .repair, .enquiry,
                                     .interest, .specialSale, .productCatalog, .event,
                                     .eventChecklist, .eventGuest, .accompanyingGuest,
                                     .call, .meeting, .task, .document, .note,
                                     .transaction, .productOwnership]
    
    static let mainModules: [Module] = [.prospect, .client, .repair, .enquiry,
                                      .interest, .specialSale, .productCatalog, .event,
                                      .eventGuest, .accompanyingGuest, .call, .meeting,
                                      .task, .document, .note, .transaction, .productOwnership]
    
    static let mainModulesList = Module.mainModules.map({$0.rawValue}).joined(separator: ",")
    
    static let allFields = "id, my_favorite, title, email, phone_mobile, assigned_user_id, assigned_user_name, full_name, salutation, first_name, last_name, name, english_name, m3_customer_number, m3_no_readonly, profit_center_id, residential_status, email1, phone_mobile_ccode, phone_mobile, phone_mobile_with_ccode, persona_type, prospect_id, status, lead_source, repair_number, contact_id, contact_name, brand, brand_name, model, enquiry_number, email_sla_display, enquiry_type, enquiry_status, enquiry_source, primary_brand_interested, date_entered, interaction_channel, producttemplates_thg_interaction_history_1producttemplates_ida, models_enquired, producttemplates_thg_interaction_history_1_name, producttemplates_thg_interaction_history_2_name, producttemplates_thg_interaction_history_3_name, producttemplates_thg_interaction_history_4_name, producttemplates_thg_interaction_history_5_name, shops, special_sales_number, request_type, copy_brand_name, collection, size, color, item_type, strap_type, serial_no, material, movement, discount_price, product_image, posting_type, date_start, thg_boutique_location, student_response_status, is_attended, rsvp_status, attendee_name, guest_email, event_name, direction, duration_hours, duration_minutes, date_due, category_id, subcategory_id, description, invoice_date, invoice_number, type, warranty_end_date, brand_others, collection_others, model_others, thg_product_ownerships_producttemplates_name"
    
    var relatedLinkName: String {
        switch self {
        case .eventGuest:
            return "Applied_Sub_Posting"
        case .accompanyingGuest:
            return "guests_event"
        default:
            return self.rawValue
        }
    }
    
    var displayName : String{
        switch self {
        case .boutique:
            return "Boutique"
        case .employee:
            return "Employee"
        case .dailyWalkIn:
            return "DailyWalkIn"
        case .repairCentres:
            return "Repair Center"
        case .brand:
            return "Brand"
        case .prospect:
            return "Prospect"
        case .client:
            return "Client"
        case .m3Register:
            return "M3Register"
        case .repair:
            return  "Repair"
        case .quotation:
            return "Quotation"
        case .enquiry:
            return "Enquiry"
        case .interest:
            return "Interaction"
        case .specialSale:
            return "Special Sales"
        case .productCatalog:
            return "Product Catalog"
        case .event:
            return "Event"
        case .eventChecklist:
            return "Events Checklist"
        case .eventGuest:
            return "Event Guest"
        case .accompanyingGuest:
            return "Accompanying Guest"
        case .call:
            return "Call"
        case .meeting:
            return "Meeting"
        case .task:
            return "Task"
        case .document:
            return "Document"
        case .note:
            return "Note"
        case .transaction:
            return "Opportunitie"
        case .productOwnership:
            return "Product Ownership"
        default:
            return ""
        }
    }
}
enum Permission: String {
    case access = "access"
    case create = "create"
    case list = "list"
    case view = "view"
    case edit = "edit"
    case write = "write"
    case read = "read"
}

enum UserType: String {
    case admin
    case user
}

enum UserRole: String {
    case management = "Management"
}

enum THGCompany: Int {
    case sg = 746
    case au = 781
    case my = 770
    case jp = 798
    case hk = 760
    case th = 755
    case nz = 782
    case none = 0
    
    static let allCompanies = [THGCompany.sg, .au, .my, .jp, .hk, .th, .nz]
    
    static let boutiquePrefixDic: [THGCompany: String] = [.sg: "SG_", .au: "AU_", .my: "MY_", .jp: "JP_", .hk: "HK_", .th: "TH_", .nz: "NZ_"]
    
    var boutiquePrefix: String {
        return THGCompany.boutiquePrefixDic[self] ?? ""
    }
    
    static let countryDic: [THGCompany: String] = [.sg: "SINGAPORE", .au: "AUSTRALIA", .my: "MALAYSIA", .jp: "JAPAN", .hk: "HONG KONG", .th: "THAILAND", .nz: "NEW ZEALAND"]
    
    var country: String {
        return THGCompany.countryDic[self] ?? ""
    }
    
    static let currencyDic: [THGCompany: String] = [.sg: "S$", .au: "A$", .my: "RM", .jp: "J¥", .hk: "HK$", .th: "THB ", .nz: "A$"]
    
    var currencySymbol: String {
        return THGCompany.currencyDic[self] ?? ""
    }
    
    var companyName: String {
        if self == .th {
            return "PMT The Hour Glass"
        }
        return "The Hour Glass"
    }
    
    var privacyPolicyURL: String {
        switch self {
        case .au: return Constant.API.auPrivacyPolicyURL
        case .my: return Constant.API.myPrivacyPolicyURL
        case .th: return Constant.API.thPrivacyPolicyURL
        case .jp: return Constant.API.jpPrivacyPolicyURL
        default: return Constant.API.sgPrivacyPolicyURL
        }
    }
}

enum SocialAccount : Int {
    case wechat,line,telegram,insta,facebook,linkedin
    
    var image: String {
        switch self {
        case .wechat:
            return "ic_wechat"
        case .line:
            return "ic_line"
        case .telegram:
            return "ic_telegram"
        case .insta:
            return "ic_insta"
        case .facebook:
            return "ic_fb"
        case .linkedin:
            return "ic_linkedin"
        }
    }
}


public enum Model : String {
    
    //Simulator
    case simulator     = "simulator/sandbox",
    
    //iPod
    iPod1              = "iPod 1",
    iPod2              = "iPod 2",
    iPod3              = "iPod 3",
    iPod4              = "iPod 4",
    iPod5              = "iPod 5",
    
    //iPad
    iPad2              = "iPad 2",
    iPad3              = "iPad 3",
    iPad4              = "iPad 4",
    iPadAir            = "iPad Air ",
    iPadAir2           = "iPad Air 2",
    iPadAir3           = "iPad Air 3",
    iPad5              = "iPad 5", //iPad 2017
    iPad6              = "iPad 6", //iPad 2018
    iPad7              = "iPad 7", //iPad 2019
    
    //iPad Mini
    iPadMini           = "iPad Mini",
    iPadMini2          = "iPad Mini 2",
    iPadMini3          = "iPad Mini 3",
    iPadMini4          = "iPad Mini 4",
    iPadMini5          = "iPad Mini 5",
    
    //iPad Pro
    iPadPro9_7         = "iPad Pro 9.7\"",
    iPadPro10_5        = "iPad Pro 10.5\"",
    iPadPro11          = "iPad Pro 11\"",
    iPadPro12_9        = "iPad Pro 12.9\"",
    iPadPro2_12_9      = "iPad Pro 2 12.9\"",
    iPadPro3_12_9      = "iPad Pro 3 12.9\"",
    
    //iPhone
    iPhone4            = "iPhone 4",
    iPhone4S           = "iPhone 4S",
    iPhone5            = "iPhone 5",
    iPhone5S           = "iPhone 5S",
    iPhone5C           = "iPhone 5C",
    iPhone6            = "iPhone 6",
    iPhone6Plus        = "iPhone 6 Plus",
    iPhone6S           = "iPhone 6S",
    iPhone6SPlus       = "iPhone 6S Plus",
    iPhoneSE           = "iPhone SE",
    iPhone7            = "iPhone 7",
    iPhone7Plus        = "iPhone 7 Plus",
    iPhone8            = "iPhone 8",
    iPhone8Plus        = "iPhone 8 Plus",
    iPhoneX            = "iPhone X",
    iPhoneXS           = "iPhone XS",
    iPhoneXSMax        = "iPhone XS Max",
    iPhoneXR           = "iPhone XR",
    iPhone11           = "iPhone 11",
    iPhone11Pro        = "iPhone 11 Pro",
    iPhone11ProMax     = "iPhone 11 Pro Max",
    
    //Apple TV
    AppleTV            = "Apple TV",
    AppleTV_4K         = "Apple TV 4K",
    unrecognized       = "?unrecognized?"
}


