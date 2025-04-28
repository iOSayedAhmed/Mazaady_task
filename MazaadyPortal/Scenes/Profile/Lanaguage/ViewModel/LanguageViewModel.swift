//
//  LanguageViewModel.swift
//  MazaadyPortal
//
//  Created by iOSAYed on 26/04/2025.
//

import Foundation
import RxSwift
import RxCocoa

protocol LanguageViewModelType {
    var languageModel: BehaviorRelay<[LanguageModel]> { get }
    var selectLanguage: BehaviorRelay<LocalizationManager.Language> { get }
}

class LanguageViewModel: LanguageViewModelType {
    
    let languageModel: BehaviorRelay<[LanguageModel]> = BehaviorRelay(value: [])
    let selectLanguage: BehaviorRelay<LocalizationManager.Language> = BehaviorRelay(value: .Arabic)
    
    init() {
        setDataLanguage()
    }
}

extension LanguageViewModel {
    private func setDataLanguage() {
        let language = [
            LanguageModel(languageName: AppLocalizedKeys.english.value, typeLanguage: .English),
            LanguageModel(languageName: AppLocalizedKeys.arabic.value, typeLanguage: .Arabic),
        ]
        
        self.languageModel.accept(language)
    }
}
