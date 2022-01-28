import UIKit
import SPDiffable
import SparrowKit

class SettingsLanguageController: SPDiffableTableController {
    
    // MARK: - Init
    
    init() {
        super.init(style: .insetGrouped)
    }
    
    internal required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.title = "Languages"
        navigationItem.largeTitleDisplayMode = .never
        configureDiffable(sections: content, cellProviders: SPDiffableTableDataSource.CellProvider.default)
    }
    
    enum Section: String {
        
        case languages
        
        var id: String { rawValue }
    }
    
    internal var content: [SPDiffableSection] {
        [
            .init(
                id: Section.languages.id,
                header: SPDiffableTextHeaderFooter(text: "Languages"),
                footer: SPDiffableTextHeaderFooter(text: "You can set any supported language in settings."),
                items: LanguageService.supported.map({ locale in
                    return SPDiffableTableRowSubtitle(
                        id: locale.identifier,
                        text: locale.description(in: locale),
                        subtitle: locale.description(in: .current),
                        icon: Image.language(for: locale),
                        accessoryType: (locale.identifier == SPLocale.current.identifier) ? .checkmark : .none,
                        selectionStyle: .none
                    ) { item, indexPath in
                        UIApplication.shared.openSettings()
                    }
                })
            )
        ]
    }
}
