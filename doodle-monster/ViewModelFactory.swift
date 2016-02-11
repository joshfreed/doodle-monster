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
        return LoginByEmailPresenter(view: view, session: appDelegate!.session)
    }

    func newMonsterViewModel(vc: NewMonsterViewController) -> NewMonsterViewModel {
        return NewMonsterViewModel(currentPlayer: appDelegate!.session.currentPlayer!,
            gameService: appDelegate!.gameService,
            router: NewMonsterRouterImpl(vc: vc, vmFactory: self)
        )
    }

    func mainMenuViewModel(vc: MainMenuViewController) -> MainMenuViewModel {
        return MainMenuViewModel(view: vc,
            gameService: appDelegate!.gameService,
            session: appDelegate!.session,
            router: MainMenuRouterImpl(vc: vc, vmFactory: self),
            listener: MainMenuViewModelListener()
        )
    }

    func drawingViewModel(game: Game) -> DrawingViewModel {
        return DrawingViewModel(game: game, gameService: appDelegate!.gameService)
    }

    func inviteByEmailViewModel() -> InviteByEmailViewModel {
        return InviteByEmailViewModel(playerService: appDelegate!.playerService, session: appDelegate!.session)
    }
}
