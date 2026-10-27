import QtQuick
import Quickshell
import Quickshell.Io
import qs.Ui

BarIndicator {
  id: root

  property string state: "idle"
  property string icon: ""

  active: state === "recording"
  activeText: icon
  inactiveText: "󰍬"
  activeTooltipText: state
  inactiveTooltipText: "Dictate"

  readonly property string voxtypeStateFile: Quickshell.env("XDG_RUNTIME_DIR") + "/voxtype/state"

  function applyState(raw) {
    var next = String(raw || "").trim()
    if (next !== "recording" && next !== "transcribing") next = "idle"
    state = next
    if (state === "recording") icon = "󰍬"
    else if (state === "transcribing") icon = "󰔟"
    else icon = ""
  }

  FileView {
    path: root.voxtypeStateFile
    watchChanges: true
    onFileChanged: reload()
    onLoaded: root.applyState(text())
    onLoadFailed: root.applyState("idle")
  }

  onPressed: function() {
    if (!root.bar) return
    root.bar.run("omarchy-voxtype-config")
  }
}
