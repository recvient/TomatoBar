import AppKit
import SwiftUI

enum KeyboardShortcuts {
    enum Name { case startStopTimer }
    static func onKeyUp(for name: Name, action: @escaping () -> Void) {}
}
class TBPlayer {
    var ticking = false
    func playWindup() {}
    func playDing() {}
    func startTicking() { ticking = true }
    func stopTicking() { ticking = false }
}
enum TBNotification {
    enum Action { case skipRest }
    enum Category { case restStarted, restFinished }
}
class TBNotificationCenter {
    func setActionHandler(handler: @escaping (TBNotification.Action) -> Void) {}
    func send(title: String, body: String, category: TBNotification.Category) {}
}
class TBStatusItem {
    static var shared = TBStatusItem()
    var title: String?
    var icon: NSImage.Name?
    func setTitle(title: String?) { self.title = title }
    func setIcon(name: NSImage.Name) { icon = name }
}
extension NSImage.Name {
    static let idle = Self("idle")
    static let work = Self("work")
    static let shortRest = Self("shortRest")
    static let longRest = Self("longRest")
}
struct TBLogEventTransition { init(fromContext: TBStateMachine.Context) {} }
struct Logger { func append(event: TBLogEventTransition) {} }
let logger = Logger()

@main struct TimerTests {
    static func wait(_ seconds: Double) { RunLoop.main.run(until: Date().addingTimeInterval(seconds)) }
    static func main() {
        let suite = UserDefaults.standard
        let keys = ["workIntervalLength", "shortRestIntervalLength", "longRestIntervalLength", "workIntervalsInSet", "stopAfterBreak", "showTimerInMenuBar"]
        let original = keys.map { suite.object(forKey: $0) }
        defer { for (key, value) in zip(keys, original) { if let value { suite.set(value, forKey: key) } else { suite.removeObject(forKey: key) } } }
        let timer = TBTimer()
        timer.workIntervalLength = 1
        timer.shortRestIntervalLength = 1
        timer.longRestIntervalLength = 1
        timer.stopAfterBreak = false
        timer.showTimerInMenuBar = true
        timer.pauseResume()
        assert(!timer.isPaused && timer.timer == nil)
        timer.startStop()
        wait(1.2)
        timer.pauseResume()
        let frozen = timer.timeLeftString
        assert(timer.isPaused && !timer.player.ticking)
        assert(TBStatusItem.shared.title?.contains("Ⅱ") == true)
        wait(2.2)
        timer.updateTimeLeft()
        assert(timer.timeLeftString == frozen, "Pause must freeze time")
        timer.pauseResume()
        assert(!timer.isPaused && timer.player.ticking)
        assert(timer.timeLeftString == frozen, "Resume must retain remaining time")
        wait(2.2)
        assert(timer.timeLeftString != frozen, "Resumed timer must count down")
        for _ in 0..<10 { timer.pauseResume(); timer.pauseResume() }
        timer.pauseResume()
        timer.startStop()
        assert(timer.timer == nil && !timer.isPaused && !timer.player.ticking)
        timer.startStop()
        timer.finishForTest()
        wait(0.2)
        assert(TBStatusItem.shared.icon == .shortRest)
        timer.pauseResume()
        let restFrozen = timer.timeLeftString
        wait(1.2)
        assert(timer.isPaused && timer.timeLeftString == restFrozen && !timer.player.ticking)
        timer.pauseResume()
        assert(!timer.player.ticking, "Resuming break must not play work ticking")
        timer.pauseResume()
        timer.skipRest()
        assert(!timer.isPaused && timer.player.ticking)
        timer.stopAfterBreak = true
        timer.finishForTest()
        wait(0.2)
        timer.finishForTest()
        wait(0.2)
        assert(timer.timer == nil && !timer.isPaused)
        print("PASS: idle, work pause/resume, frozen countdown, repeated toggles, stop while paused, break pause/resume, skip paused break, stop after break")
    }
}
