//
//  LanaguageViewController.swift
//  MazaadyPortal
//
//  Created by iOSAYed on 26/04/2025.
//

import UIKit
import RxSwift

final class LanaguageViewController: UIViewController, UIScrollViewDelegate {
    
    // MARK: - Outlets

    @IBOutlet private weak var subView: UIView!
    @IBOutlet private weak var languageLabel: UILabel!
    @IBOutlet private weak var cancelImageView: UIImageView!
    @IBOutlet private weak var languageTabelView: UITableView!
    
    // MARK: - Properties
    
    private var coordinator: HomeCoordinatorProtocol
    private let viewModel: LanguageViewModelType
    private let disposeBag = DisposeBag()
    
    // MARK: - Initializer
    
    init(coordinator: HomeCoordinatorProtocol, viewModel: LanguageViewModelType) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        subView.applyMaskCornersUp()
        setupTableView()
        bindLanguageToViewModel()
        bindSelectedModel()
        setupCancelImageTap()
        setTextLocalized()
    }
}

extension LanaguageViewController {
    private func setupTableView() {
        languageTabelView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        languageTabelView.isScrollEnabled = false
        languageTabelView.allowsMultipleSelection = false
    }
}

extension LanaguageViewController {
    private func bindLanguageToViewModel() {
        languageTabelView.register(LanaguageTableViewCell.nib(), forCellReuseIdentifier: LanaguageTableViewCell.identifier)
        
        viewModel.languageModel
            .bind(to: languageTabelView.rx.items(cellIdentifier: LanaguageTableViewCell.identifier, cellType: LanaguageTableViewCell.self)) { (row, model, cell) in
                cell.configurLanguageCell(model)
            }
            .disposed(by: disposeBag)
    }
}

extension LanaguageViewController {
    private func setupCancelImageTap() {
        cancelImageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cancelImageTapped))
        cancelImageView.addGestureRecognizer(tapGesture)
    }

    @objc private func cancelImageTapped() {
        dismiss(animated: true)
    }
}

extension LanaguageViewController {
    private func bindSelectedModel() {
        languageTabelView.rx
            .modelSelected(LanguageModel.self)
            .subscribe(onNext: { [weak self] selectedModel in
                guard let self else { return }

                for cell in self.languageTabelView.visibleCells {
                    if let customCell = cell as? LanaguageTableViewCell {
                        customCell.isSelectedStatus = false
                    }
                }
                
                if let indexPath = self.languageTabelView.indexPathForSelectedRow,
                                    let selectedCell = self.languageTabelView.cellForRow(at: indexPath) as? LanaguageTableViewCell {
                    selectedCell.isSelectedStatus = true
                }

                LocalizationManager.shared.setLanguage(language: selectedModel.typeLanguage)

                self.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }
}

//MARK: - localized -

extension LanaguageViewController {
    private func setTextLocalized() {
        languageLabel.text = AppLocalizedKeys.language.value
    }
}

extension LanaguageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
