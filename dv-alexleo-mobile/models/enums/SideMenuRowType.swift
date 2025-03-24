enum SideMenuRowType: Int, CaseIterable{
    case catalog = 0
    case gestion
    case admin
    
    var title: String{
        switch self {
        case .catalog:
            return "Catalog"
        case .gestion:
            return "Gestion"
        case .admin:
            return "Admin"
        }
    }
    
    var iconName: String{
        switch self {
        case .catalog:
            return "catalog"
        case .gestion:
            return "gestion"
        case .admin:
            return "admin"
        }
    }
}
