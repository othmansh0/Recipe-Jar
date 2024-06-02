import Foundation
import SwiftUI
extension ScrollView {
    public func refresher<RefreshView>(
        isRefreshing: Binding<Bool>,
        style: Style = .default,
        config: RefreshConfig = RefreshConfig(),
        refreshView: @escaping (Binding<RefresherState>) -> RefreshView,
        action: @escaping AsyncRefreshAction
    ) -> RefreshableScrollView<Content, RefreshView> {
        RefreshableScrollView(
            axes: axes,
            showsIndicators: showsIndicators,
            isRefreshing: isRefreshing,
            refreshAction: { done in
                Task { @MainActor in
                    await action()
                    done()
                }
            },
            style: style,
            config: config,
            refreshView: refreshView,
            content: content
        )
    }
}
