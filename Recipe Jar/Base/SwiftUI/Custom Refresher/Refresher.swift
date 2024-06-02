import Foundation
import SwiftUI
import SwiftUIIntrospect

public typealias RefreshAction = (_ completion: @escaping () -> ()) -> ()
public typealias AsyncRefreshAction = () async -> ()

public struct RefreshConfig {
    /// Drag distance needed to trigger a refresh
    public var refreshAt: CGFloat
    
    /// Max height of the spacer for the refresh spinner to sit while refreshing
    public var headerShimMaxHeight: CGFloat
    
    /// Offset where the spinner stops moving after draging
    public var defaultSpinnerSpinnerStopPoint: CGFloat
    
    /// Off screen start point for the spinner (relative to the top of the screen)
    /// TIP: set this to the max height of your spinner view if using a custom spinner.
    public var defaultSpinnerOffScreenPoint: CGFloat
    
    /// How far you have to pull (from 0 - 1) for the spinner to start moving
    public var defaultSpinnerPullClipPoint: CGFloat
    
    /// How far you have to pull (from 0 - 1) for the spinner to start becoming visible
    public var systemSpinnerOpacityClipPoint: CGFloat
    
    /// How long to hold the spinner before dismissing (a small delay is a nice UX if the refresh is VERY fast)
    public var holdTime: DispatchTimeInterval
    
    /// How long to wait before allowing the next refresh
    public var cooldown: DispatchTimeInterval
    
    /// How close to resting position the scrollview has to move in order to allow the next refresh (finger must also be released from screen)
    public var resetPoint: CGFloat
    
    public init(
        refreshAt: CGFloat = 30,
         headerShimMaxHeight: CGFloat = 60, // Decreased from 170 to 120
         defaultSpinnerSpinnerStopPoint: CGFloat = 0, // Decreased from -10 to 0
         defaultSpinnerOffScreenPoint: CGFloat = -15,
         defaultSpinnerPullClipPoint: CGFloat = 0.1,
         systemSpinnerOpacityClipPoint: CGFloat = 0.2,
         holdTime: DispatchTimeInterval = .milliseconds(300), // Added some delay for UX
         cooldown: DispatchTimeInterval = .milliseconds(500),
         resetPoint: CGFloat = 5
    ) {
        self.refreshAt = refreshAt
        self.defaultSpinnerSpinnerStopPoint = defaultSpinnerSpinnerStopPoint
        self.headerShimMaxHeight = headerShimMaxHeight
        self.defaultSpinnerOffScreenPoint = defaultSpinnerOffScreenPoint
        self.defaultSpinnerPullClipPoint = defaultSpinnerPullClipPoint
        self.systemSpinnerOpacityClipPoint = systemSpinnerOpacityClipPoint
        self.holdTime = holdTime
        self.cooldown = cooldown
        self.resetPoint = resetPoint
    }
}

public enum Style {
    
    /// Spinner pulls down and centers on a padding view above the scrollview
    case `default`
    
    /// Mimic the system refresh controller as close as possible
    case system
    case system2
    
    /// Overlay the spinner onto the cotained view - good for static images
    case overlay
}

public enum RefreshMode {
    case notRefreshing
    case pulling
    case refreshing
}

public struct RefresherState {
    
    /// Updated without animation - NOTE: Both modes are always updated in sequence (this one is first)
    public var mode: RefreshMode = .notRefreshing
    
    /// Updated with animation (this one is second)
    public var modeAnimated: RefreshMode = .notRefreshing
    
    /// Value from 0 - 1. 0 is resting state, 1 is refresh trigger point - use this value for custom translations
    public var dragPosition: CGFloat = 0
    
    /// the configuration style - useful if you want your custom spinner to change behavior based on the style
    public var style: Style = .default
}


public struct RefreshableScrollView<Content: View, RefreshView: View>: View {
    let axes: Axis.Set
    let showsIndicators: Bool
    let content: Content
    let refreshAction: RefreshAction
    var refreshView: (Binding<RefresherState>) -> RefreshView
    @Binding var isRefreshing: Bool

    @State private var headerInset: CGFloat = 1000000 // Somewhere far off screen
    @State var state = RefresherState()
    @State var distance: CGFloat = 0
    @State var rawDistance: CGFloat = 0
    private var style: Style
    private var config: RefreshConfig
    
    @State private var uiScrollView: UIScrollView?
    @State private var isRefresherVisible = true
    @State private var isFingerDown = false
    @State private var canRefresh = true
    
    public func setRefreshing(_ refreshing: Bool) {
        isRefreshing = refreshing
        if refreshing {
            set(mode: .refreshing)
        } else {
            set(mode: .notRefreshing)
        }
    }
    
    init(
        axes: Axis.Set = .vertical,
        showsIndicators: Bool = true,
        isRefreshing: Binding<Bool>,
        refreshAction: @escaping RefreshAction,
        style: Style,
        config: RefreshConfig,
        refreshView: @escaping (Binding<RefresherState>) -> RefreshView,
        content: Content
    ){
        self.axes = axes
        self.showsIndicators = showsIndicators
        self.refreshAction = refreshAction
        self.refreshView = refreshView
        self.content = content
        self.style = style
        self.config = config
        self._isRefreshing = isRefreshing

    }
    
    private var refreshHeaderOffset: CGFloat {
        switch state.style {
        case .default, .system:
            if case .refreshing = state.modeAnimated {
                return config.headerShimMaxHeight * (1 - state.dragPosition)
            }
        case .system2:
            switch state.modeAnimated {
            case .pulling:
                return config.headerShimMaxHeight * (state.dragPosition)
            case .refreshing:
                return config.headerShimMaxHeight
            default: break
            }
        default: break
        }
        
        return 0
    }
    
    private var isTracking: Bool {
        guard let scrollView = uiScrollView else { return false }
        return scrollView.isTracking
    }
    
    private var showRefreshControls: Bool {
        return isFingerDown || isRefresherVisible || isRefreshing
    }
    
    @ViewBuilder
    private var refershSpinner: some View {
        if showRefreshControls && (state.style == .default || state.style == .overlay) {
            RefreshSpinnerView(offScreenPoint: config.defaultSpinnerOffScreenPoint,
                                pullClipPoint: config.defaultSpinnerPullClipPoint,
                                mode: state.modeAnimated,
                                stopPoint: config.defaultSpinnerSpinnerStopPoint,
                                refreshHoldPoint: config.headerShimMaxHeight / 2,
                                refreshView: refreshView($state),
                                headerInset: $headerInset,
                                refreshAt: config.refreshAt)
        }
    }
    
    @ViewBuilder
    private var systemStylerefreshSpinner: some View {
        if showRefreshControls && state.style == .system {
            SystemStyleRefreshSpinner(opacityClipPoint: config.systemSpinnerOpacityClipPoint,
                                      state: state,
                                      position: distance,
                                      refreshHoldPoint: config.headerShimMaxHeight / 2,
                                      refreshView: refreshView($state))
        }
    }
    
    @ViewBuilder
    private var system2StylerefreshSpinner: some View {
        if showRefreshControls && state.style == .system2 {
            System2StyleRefreshSpinner(opacityClipPoint: config.systemSpinnerOpacityClipPoint,
                                       state: state,
                                       refreshHoldPoint: config.headerShimMaxHeight / 2,
                                       refreshView: refreshView($state))
        }
    }
    
    public var body: some View {
        // The ordering of views and operations here is very important - things break
        // in very strange ways between iOS 14 and iOS 15.
        GeometryReader { globalGeometry in
            ScrollView(axes, showsIndicators: showsIndicators) {
                ZStack(alignment: .top) {
                    OffsetReader { val in
                        offsetChanged(val)
                    }
                    systemStylerefreshSpinner
                    system2StylerefreshSpinner
                    
                    // Content wrapper with refresh banner
                    VStack(spacing: 0) {
                        content
                            .offset(y: refreshHeaderOffset)
                    }
                    // renders over content
                    refershSpinner
                }
            }
            .introspect(.scrollView, on: .iOS(.v14, .v15, .v16, .v17)) { scrollView in
                DispatchQueue.main.async {
                    uiScrollView = scrollView
                }
            }
            .onChange(of: globalGeometry.frame(in: .global)) { val in
                headerInset = val.minY
            }
            .onAppear {
                state.style = style
                DispatchQueue.main.async {
                    headerInset = globalGeometry.frame(in: .global).minY
                }
            }
            .onChange(of: isRefreshing) { _ in
                setRefreshing(isRefreshing)
                isRefresherVisible = true
            }
        }
    }
    
    private func offsetChanged(_ val: CGFloat) {
        isFingerDown = isTracking
        distance = val - headerInset
        state.dragPosition = normalize(from: 0, to: config.refreshAt, by: distance)
        
        guard canRefresh else {
            canRefresh = (distance <= config.resetPoint && !isFingerDown) && (state.mode == .notRefreshing && !isFingerDown)
            return
        }
        guard distance > 0, showRefreshControls else {
            state.mode = .notRefreshing
            isRefresherVisible = false
            return
        }
        
        isRefresherVisible = true



             if distance >= config.refreshAt || isRefreshing {
                 UIImpactFeedbackGenerator(style: .medium).impactOccurred()

                 set(mode: .refreshing)
                 canRefresh = false

                 refreshAction {
                     // The ordering here is important - calling `set` on the main queue after `refreshAction` prevents
                     // strange animaton behaviors on some complex views
//                     DispatchQueue.main.asyncAfter(deadline: .now() + config.holdTime) {
//                         set(mode: .notRefreshing)
//                         DispatchQueue.main.asyncAfter(deadline: .now() + config.cooldown) {
//                             self.canRefresh = true
//                             self.isRefresherVisible = false
//                         }
//                     }
                 }
                 
             } else if distance > 0 {
                 set(mode: .notRefreshing)
             }
         
    }
    
    func set(mode: RefreshMode) {
        state.mode = mode
        withAnimation {
            state.modeAnimated = mode
        }
    }
}
