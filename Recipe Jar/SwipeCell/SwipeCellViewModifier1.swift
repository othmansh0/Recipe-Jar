import Combine
import SwiftUI

public enum CellStatus: String {
    case showCell, showLeftSlot, showRightSlot
}

enum FeedStatus {
    case none, feedOnce, feedAgain
}

struct SwipeCellModifier: ViewModifier {
    @State var cellPosition: SwipeCellSlotPosition
    let leftSlot: SwipeCellSlot?
    let rightSlot: SwipeCellSlot?
    let swipeCellStyle: SwipeCellStyle
    let clip: Bool
    /// If the status should be reset
    @State var shouldResetStatusOnAppear = true
    /// The amount of time it should take to reset the status on appear
    let initialStatusResetDelay: TimeInterval

    @State var status: CellStatus = .showCell
    @State var showDalayButtonWith: CGFloat = 0

    @State var offset: CGFloat = 0.0

    @State var frameWidth: CGFloat = 99999
    @State var leftOffset: CGFloat = -10000
    @State var rightOffset: CGFloat = 10000
    @State var spaceWidth: CGFloat = 0

    let cellID = UUID()

    @State var currentCellID: UUID? = nil
    @State var resetNotice = NotificationCenter.default.publisher(for: .swipeCellReset)

    @State var feedStatus: FeedStatus = .none

    var leftSlotWidth: CGFloat {
        guard let ls = leftSlot else { return 0 }
        return CGFloat(ls.slots.count) * ls.buttonWidth
    }

    var rightSlotWidth: CGFloat {
        guard let rs = rightSlot else { return 0 }
        return CGFloat(rs.slots.count) * rs.buttonWidth
    }

    var leftdestructiveWidth: CGFloat {
        max(swipeCellStyle.destructiveWidth, leftSlotWidth + 70)
    }

    var rightdestructiveWidth: CGFloat {
        max(swipeCellStyle.destructiveWidth, rightSlotWidth + 70)
    }
    @Environment(\.editMode) var editMode

    @State var timer = Timer.publish(every: 1, on: .main, in: .common)
    @State var cancellables: Set<AnyCancellable> = []

    init(
        cellPosition: SwipeCellSlotPosition,
        leftSlot: SwipeCellSlot?,
        rightSlot: SwipeCellSlot?,
        swipeCellStyle: SwipeCellStyle,
        clip: Bool,
        initialStatusResetDelay: TimeInterval = 0.0,
        initialStatus: CellStatus = .showCell
    ) {
        switch initialStatus {
        case .showLeftSlot:
            precondition(cellPosition != .right, "Initial status not supported with a right cell position")
        case .showRightSlot:
            precondition(cellPosition != .left, "Initial status not support with a left cell position")
        default:
            break
        }
        _cellPosition = State(wrappedValue: cellPosition)
        self.clip = clip
        self.leftSlot = leftSlot
        self.rightSlot = rightSlot
        self.swipeCellStyle = swipeCellStyle
        self._status = State(initialValue: initialStatus)
        self.initialStatusResetDelay = initialStatusResetDelay
    }

    func emptyView(_ button: SwipeCellButton) -> some View {
        Text("nil").foregroundColor(button.titleColor)
    }

    @ViewBuilder func buttonView(_ slot: SwipeCellSlot, _ i: Int) -> some View {
        let button = slot.slots[i]
        let viewStyle = button.buttonStyle
        let emptyView = emptyView(button)

        switch viewStyle {
        case .image:
            if let image = button.systemImage {
                Image(systemName: image)
                    .font(.system(size: 23))
                    .foregroundColor(button.imageColor)
            } else {
                emptyView
            }
        case .title:
            if let title = button.title {
                Text(title)
                    .font(.callout)
                    .bold()
                    .foregroundColor(button.titleColor)
            } else {
                emptyView
            }
        case .titleAndImage:
            if let title = button.title, let image = button.systemImage {
                VStack(spacing: 5) {
                    Image(systemName: image)
                        .font(.system(size: 23))
                        .foregroundColor(button.imageColor)
                    Text(title)
                        .font(.callout)
                        .bold()
                        .foregroundColor(button.titleColor)
                }
            } else {
                emptyView
            }
        case .view:
            if let view = button.view {
                view()
            } else {
                emptyView
            }
        }
    }

    func slotView(slot: SwipeCellSlot, i: Int, position: SwipeCellSlotPosition) -> some View {
        let buttons = slot.slots

        return Rectangle()
            .fill(buttons[i].backgroundColor)
            .overlay(
                ZStack(alignment: position == .left ? .trailing : .leading) {
                    Color.clear
                    buttonView(slot, i)
                        .contentShape(Rectangle())
                        .frame(width: slot.buttonWidth)
                        .offset(x: spaceWidth)
                        .alignmentGuide(
                            .trailing,
                            computeValue: { d in
                                if slot.slotStyle == .destructive && slot.slots.count == 1
                                    && position == .left
                                {
                                    var result: CGFloat = 0
                                    if offset > slot.buttonWidth {
                                        result = d[.trailing] + offset - slot.buttonWidth
                                    }
                                    else {
                                        result = d[.trailing]
                                    }
                                    return result
                                }
                                else {
                                    return d[.trailing]
                                }
                            }
                        )
                        .alignmentGuide(
                            .leading,
                            computeValue: { d in
                                if slot.slotStyle == .destructive && slot.slots.count == 1
                                    && position == .right
                                {
                                    var result: CGFloat = 0
                                    if abs(offset) > slot.buttonWidth {
                                        result = d[.leading] + slot.buttonWidth - abs(offset)
                                    }
                                    else {
                                        result = d[.leading]
                                    }

                                    return result
                                }
                                else {
                                    return d[.leading]
                                }
                            }
                        )

                }
            )
            .contentShape(Rectangle())
            .onTapGesture {
                if slot.slotStyle == .destructiveDelay && i == slot.slots.count - 1 {
                    withAnimation(.easeInOut) {
                        if position == .left {
                            offset = frameWidth
                            showDalayButtonWith = 0.0001  //修改成iOS14的样式

                        }
                        else {
                            offset = -frameWidth
                            showDalayButtonWith = -0.0001

                        }
                    }
                    if buttons[i].feedback {
                        successFeedBack(swipeCellStyle.vibrationForDestructive)
                    }
                }
                else {
                    if buttons[i].feedback {
                        successFeedBack(swipeCellStyle.vibrationForButton)
                    }
                }

                if slot.slotStyle == .delay {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        buttons[i].action()
                    }
                }
                else {
                    buttons[i].action()
                }

                if !(slot.slotStyle == .destructiveDelay && i == slot.slots.count - 1) {
                    resetStatus()
                }
            }
    }

    @ViewBuilder func loadButtons(_ slot: SwipeCellSlot, position: SwipeCellSlotPosition, frame: CGRect)
    -> some View
    {
        let buttons = slot.slots

        if slot.slotStyle == .destructive && leftOffset == -10000 && position == .left {
            let _ = DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                leftOffset = cellOffset(
                    i: buttons.count - 1,
                    count: buttons.count,
                    position: position,
                    width: frame.width,
                    slot: slot
                )
            }
        }

        if slot.slotStyle == .destructive && rightOffset == 10000 && position == .right {
            let _ = DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                rightOffset = cellOffset(
                    i: buttons.count - 1,
                    count: buttons.count,
                    position: position,
                    width: frame.width,
                    slot: slot
                )
            }
        }

        if slot.slotStyle == .destructive {
            destructiveButtons(slot, position: position, frame: frame)
        }
        else {
            ZStack {
                ForEach(0..<buttons.count, id: \.self) { i in
                    if slot.slotStyle == .destructiveDelay && i == buttons.count - 1 {
                        slotView(slot: slot, i: i, position: position)
                            .offset(
                                x: showDalayButtonWith != 0
                                ? showDalayButtonWith
                                : cellOffset(
                                    i: i,
                                    count: buttons.count,
                                    position: position,
                                    width: frame.width,
                                    slot: slot
                                )
                            )
                            .zIndex(Double(i))
                    }
                    else {
                        slotView(slot: slot, i: i, position: position)
                            .offset(
                                x: cellOffset(
                                    i: i,
                                    count: buttons.count,
                                    position: position,
                                    width: frame.width,
                                    slot: slot
                                )
                            )
                            .zIndex(Double(i))
                    }
                }
            }
        }
    }

    @ViewBuilder private func destructiveButtons(_ slot: SwipeCellSlot, position: SwipeCellSlotPosition, frame: CGRect) -> some View {
        let buttons = slot.slots
        //单button的销毁按钮
        if buttons.count == 1 {
            slotView(slot: slot, i: 0, position: position)
                .offset(
                    x: cellOffset(
                        i: 0,
                        count: buttons.count,
                        position: position,
                        width: frame.width,
                        slot: slot
                    )
                )
        }
        else {
            ZStack {
                ForEach(0..<buttons.count - 1, id: \.self) { i in
                    slotView(slot: slot, i: i, position: position)
                        .offset(
                            x: cellOffset(
                                i: i,
                                count: buttons.count,
                                position: position,
                                width: frame.width,
                                slot: slot
                            )
                        )
                        .fixedSize(horizontal: false, vertical: true)

                        .zIndex(Double(i))
                }
                //销毁按钮
                if slot.slotStyle == .destructive && position == .left {
                    slotView(slot: slot, i: buttons.count - 1, position: .left)
                        .zIndex(10)
                        .offset(x: leftOffset)

                }

                if slot.slotStyle == .destructive && position == .right {
                    slotView(slot: slot, i: buttons.count - 1, position: .right)
                        .offset(x: rightOffset)
                        .zIndex(10)

                }
            }
        }
    }

    func offsetForSingleDestructiveButton(slot: SwipeCellSlot, position: SwipeCellSlotPosition) {
        if slot.slotStyle == .destructive && slot.slots.count == 1 {
            switch position {
            case .left:
                DispatchQueue.main.async {
                    spaceWidth = 0
                }
                if feedStatus == .feedOnce {
                    DispatchQueue.main.async {
                        withAnimation(.easeInOut) {
                            spaceWidth = offset - slot.buttonWidth
                        }
                    }
                }
                if feedStatus == .feedAgain {
                    DispatchQueue.main.async {
                        withAnimation(.easeInOut) {
                            spaceWidth = 0
                        }
                    }
                }

            case .right:
                DispatchQueue.main.async {
                    spaceWidth = 0
                }
                if feedStatus == .feedOnce {
                    DispatchQueue.main.async {
                        withAnimation(.easeInOut) {
                            spaceWidth = offset + slot.buttonWidth
                        }
                    }
                }
                if feedStatus == .feedAgain {
                    DispatchQueue.main.async {
                        withAnimation(.easeInOut) {
                            spaceWidth = 0
                        }
                    }
                }
            default:
                DispatchQueue.main.async {
                    withAnimation(.easeInOut) {
                        spaceWidth = 0
                    }
                }
            }
        }
        else {
            DispatchQueue.main.async {
                withAnimation(.easeInOut) {
                    spaceWidth = 0
                }
            }
        }
    }

    func cellOffset(
        i: Int,
        count: Int,
        position: SwipeCellSlotPosition,
        width: CGFloat,
        slot: SwipeCellSlot
    ) -> CGFloat {

        if frameWidth == 99999 {
            DispatchQueue.main.async {
                frameWidth = width
            }
        }
        var result: CGFloat = 0

        let cellOffset = offset * (CGFloat(count - i) / CGFloat(count))
        if position == .left {
            result = -width + cellOffset

        }
        else {
            result = width + cellOffset
        }

        return result
    }

    func lastButtonOffset(position: SwipeCellSlotPosition, slot: SwipeCellSlot?) {

        let animation = slot?.appearAnimation ?? Animation.easeOut(duration: 0.5)

        guard let slot = slot, slot.slotStyle == .destructive else {
            if position == .left {
                withAnimation(animation) {
                    leftOffset = -frameWidth
                }
            }
            else {
                withAnimation(animation) {
                    rightOffset = frameWidth
                }
            }
            return
        }

        let count = slot.slots.count

        var result: CGFloat = 0

        let cellOffset = offset * (CGFloat(1) / CGFloat(count))
        if position == .left {
            result = -frameWidth + cellOffset

        }
        else {
            result = frameWidth + cellOffset
        }

        if feedStatus == .feedOnce {
            if position == .left {
                result = -frameWidth + offset
                withAnimation(animation) {
                    leftOffset = result
                }
            }
            else {
                result = frameWidth + offset
                withAnimation(.easeInOut) {
                    rightOffset = result
                }
            }
        }
        else if feedStatus == .feedAgain {
            if position == .left {
                withAnimation(animation) {
                    leftOffset = result
                }
            }
            else {
                withAnimation(animation) {
                    rightOffset = result
                }
            }
        }
        else {

            if position == .left {
                withAnimation(animation) {
                    leftOffset = result
                }
            }
            else {
                withAnimation(animation) {
                    rightOffset = result
                }
            }
        }
    }
}
