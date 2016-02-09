//
// Created by Josh Freed on 2/5/16.
// Copyright (c) 2016 BleepSmazz. All rights reserved.
//

import Foundation

class ViewModelFactory {
    weak private(set) var appDelegate: AppDelegate?

    init(appDelegate: AppDelegate) {
        self.appDelegate = appDelegate
    }

    func loginByEmailPresenter(view: LoginByEmailView) -> LoginByEmailPresenter {
        return LoginByEmailPresenter(view: view, playerService: appDelegate!.playerService)
    }

    func newMonsterViewModel(currentPlayer: Player, gameService: GameService, router: NewMonsterRouter) -> NewMonsterViewModel {
        return NewMonsterViewModel(currentPlayer: currentPlayer, gameService: gameService, router: router)
    }

    func mainMenuViewModel(vc: MainMenuViewController) -> MainMenuViewModel {
        return MainMenuViewModel(gameService: appDelegate!.gameService,
            currentPlayer: appDelegate!.session.currentPlayer()!,
            session: appDelegate!.session,
            router: MainMenuRouterImpl(vc: vc)
        )
    }
}
