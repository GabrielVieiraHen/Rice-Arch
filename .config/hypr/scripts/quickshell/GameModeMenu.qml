import QtQuick
import QtQuick.Window
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Effects
import Quickshell
import Quickshell.Io


Item {
    id: window
    focus: true
    property var notifModel

    Scaler {
        id: scaler
        currentWidth: Screen.width
    }
    
    function s(val) { 
        return scaler.s(val); 
    }

    MatugenColors { id: _theme }
    
    readonly property color base: _theme.base
    readonly property color mantle: _theme.mantle
    readonly property color crust: _theme.crust
    readonly property color text: _theme.text
    readonly property color subtext0: _theme.subtext0
    readonly property color surface0: _theme.surface0
    readonly property color surface1: _theme.surface1
    readonly property color surface2: _theme.surface2
    readonly property color mauve: _theme.mauve || "#cba6f7"
    readonly property color green: _theme.green || "#a6e3a1"

    property var allApps: []

    Process {
        id: appFetcher
        running: true
        command: ["bash", "-c", "python3 " + Quickshell.env("HOME") + "/.config/hypr/scripts/quickshell/gamemode_fetcher.py"]
        
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    if (this.text && this.text.trim().length > 0) {
                        window.allApps = JSON.parse(this.text);
                        filterApps("");
                    }
                } catch(e) {
                    console.log("Error parsing gamemode apps list: ", e);
                }
            }
        }
    }

    ListModel {
        id: appModel
    }

    function filterApps(query) {
        appList.currentIndex = -1;
        appList.positionViewAtBeginning();

        let q = query.toLowerCase();
        let filtered = [];
        
        for (let i = 0; i < allApps.length; i++) {
            if (allApps[i].name.toLowerCase().includes(q) || allApps[i].desktop.toLowerCase().includes(q)) {
                filtered.push(allApps[i]);
            }
        }

        appModel.clear();
        for (let i = 0; i < filtered.length; i++) {
            appModel.append(filtered[i]);
        }
        
        if (appModel.count > 0) {
            appList.currentIndex = 0;
        }
    }

    function toggleGamemode(index) {
        let app = appModel.get(index);
        let newState = !app.gamemode;
        let actionStr = newState ? "on" : "off";
        
        // Update UI immediately for snappiness
        appModel.setProperty(index, "gamemode", newState);
        
        // Find in allApps and update there too
        for (let i = 0; i < allApps.length; i++) {
            if (allApps[i].desktop === app.desktop) {
                allApps[i].gamemode = newState;
                break;
            }
        }

        // Run the script
        Quickshell.execDetached([
            "bash",
            Quickshell.env("HOME") + "/.config/hypr/scripts/toggle_gamemode.sh",
            app.desktop,
            app.sys_path,
            actionStr,
            app.name
        ]);
    }

    Timer {
        id: focusTimer
        interval: 50
        running: true
        repeat: false
        onTriggered: searchInput.forceActiveFocus()
    }

    Connections {
        target: window
        function onVisibleChanged() {
            if (window.visible) {
                focusTimer.restart();
                introPhaseAnim.restart();
            }
        }
    }

    Keys.onEscapePressed: {
        Quickshell.execDetached(["bash", Quickshell.env("HOME") + "/.config/hypr/scripts/qs_manager.sh", "close"]);
        event.accepted = true;
    }

    property real introPhase: 0
    NumberAnimation on introPhase {
        id: introPhaseAnim
        from: 0; to: 1; duration: 600; easing.type: Easing.OutExpo; running: true
    }

    Rectangle {
        id: mainBg
        width: parent.width
        
        property real searchHeight: window.s(65)
        property real separatorHeight: 1
        property real itemHeight: window.s(60)
        property real listSpacing: window.s(4)
        property real maxListHeight: (7 * itemHeight) + (6 * listSpacing)
        
        property real targetListHeight: appModel.count === 0 ? 0 : Math.min((appModel.count * itemHeight) + ((appModel.count - 1) * listSpacing), maxListHeight)
        property real targetMargins: appModel.count > 0 ? window.s(20) : 0

        property real animatedListHeight: targetListHeight
        property real animatedMargins: targetMargins

        Behavior on animatedListHeight { NumberAnimation { duration: 500; easing.type: Easing.OutExpo } }
        Behavior on animatedMargins { NumberAnimation { duration: 500; easing.type: Easing.OutExpo } }
        
        height: searchHeight + separatorHeight + animatedMargins + animatedListHeight

        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter

        radius: window.s(20)
        // iOS Core Glassmorphism Base
        color: Qt.rgba(window.base.r, window.base.g, window.base.b, 0.50)
        border.color: Qt.rgba(window.text.r, window.text.g, window.text.b, 0.1)
        border.width: 1
        clip: true

        transform: Translate { y: (window.introPhase - 1) * window.s(40) }
        opacity: window.introPhase

        layer.enabled: true
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowBlur: 1.0
            shadowOpacity: 0.35
            shadowColor: "black"
            shadowVerticalOffset: window.s(12)
        }

        // Subtle gradient highlight for macOS glassy effect
        Rectangle {
            anchors.fill: parent
            radius: parent.radius
            gradient: Gradient {
                GradientStop { position: 0.0; color: Qt.rgba(1, 1, 1, 0.05) }
                GradientStop { position: 1.0; color: "transparent" }
            }
        }

        ColumnLayout {
            anchors.fill: parent
            spacing: 0

            // --- SEARCH BAR ---
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: mainBg.searchHeight
                color: "transparent"
                
                RowLayout {
                    anchors.fill: parent
                    anchors.margins: window.s(15)
                    anchors.leftMargin: window.s(20)
                    anchors.rightMargin: window.s(20)
                    spacing: window.s(15)

                    Text {
                        text: "󰊠 " // Controller icon
                        font.family: "Iosevka Nerd Font"
                        font.pixelSize: window.s(22)
                        color: searchInput.activeFocus ? window.mauve : window.subtext0
                        Behavior on color { ColorAnimation { duration: 150 } }
                    }

                    TextField {
                        id: searchInput
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        background: Item {} 
                        color: window.text
                        font.family: "JetBrains Mono"
                        font.pixelSize: window.s(16)
                        
                        placeholderText: "Search apps for GameMode..."
                        placeholderTextColor: window.subtext0 
                        
                        verticalAlignment: TextInput.AlignVCenter
                        focus: true

                        onTextChanged: filterApps(text)

                        Keys.onDownPressed: {
                            if (appList.currentIndex < appModel.count - 1) {
                                appList.currentIndex++;
                            }
                            event.accepted = true;
                        }
                        Keys.onUpPressed: {
                            if (appList.currentIndex > 0) {
                                appList.currentIndex--;
                            }
                            event.accepted = true;
                        }
                        Keys.onReturnPressed: {
                            if (appList.currentIndex >= 0 && appList.currentIndex < appModel.count) {
                                toggleGamemode(appList.currentIndex);
                            }
                            event.accepted = true;
                        }
                    }
                }
            }

            // --- SEPARATOR ---
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: mainBg.separatorHeight
                color: Qt.rgba(window.surface1.r, window.surface1.g, window.surface1.b, 0.5)
            }

            // --- APPLICATION LIST ---
            ListView {
                id: appList
                Layout.fillWidth: true
                
                Layout.preferredHeight: mainBg.animatedListHeight
                Layout.topMargin: mainBg.animatedMargins / 2
                Layout.bottomMargin: mainBg.animatedMargins / 2
                Layout.leftMargin: window.s(10)
                Layout.rightMargin: window.s(10)
                
                clip: true
                model: appModel
                spacing: mainBg.listSpacing
                currentIndex: 0
                boundsBehavior: Flickable.StopAtBounds
                highlightFollowsCurrentItem: true
                highlightMoveDuration: 250

                ScrollBar.vertical: ScrollBar {
                    active: true
                    policy: ScrollBar.AsNeeded
                    contentItem: Rectangle {
                        implicitWidth: window.s(4)
                        radius: window.s(2)
                        color: window.surface2
                        opacity: 0.5
                    }
                }

                highlight: Rectangle {
                    width: appList.width
                    height: mainBg.itemHeight
                    radius: window.s(8)
                    color: Qt.rgba(window.surface0.r, window.surface0.g, window.surface0.b, 0.6)
                    z: 0
                }

                delegate: Item {
                    width: ListView.view.width
                    height: mainBg.itemHeight
                    z: 1 
                    
                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: window.s(10)
                        anchors.leftMargin: window.s(12)
                        anchors.rightMargin: window.s(16)
                        spacing: window.s(15)

                        // --- ICON ---
                        Rectangle {
                            Layout.preferredWidth: window.s(40)
                            Layout.preferredHeight: window.s(40)
                            radius: window.s(10)
                            color: "transparent"
                            clip: true

                            Image {
                                anchors.centerIn: parent
                                width: window.s(32)
                                height: window.s(32)
                                source: model.icon.startsWith("/") ? "file://" + model.icon : "image://icon/" + model.icon
                                sourceSize: Qt.size(64, 64)
                                fillMode: Image.PreserveAspectFit
                                asynchronous: true
                            }
                        }

                        // --- TEXT ---
                        Text {
                            Layout.fillWidth: true
                            text: model.name
                            font.family: "JetBrains Mono"
                            font.pixelSize: window.s(14)
                            font.weight: Font.Medium
                            color: window.text
                            elide: Text.ElideRight
                            verticalAlignment: Text.AlignVCenter
                        }

                        // --- IOS CORE STYLE TOGGLE SWITCH ---
                        Rectangle {
                            id: toggleSwitch
                            Layout.preferredWidth: window.s(50)
                            Layout.preferredHeight: window.s(30)
                            radius: height / 2
                            color: model.gamemode ? window.green : Qt.rgba(window.surface2.r, window.surface2.g, window.surface2.b, 0.5)
                            border.color: model.gamemode ? "transparent" : Qt.rgba(window.text.r, window.text.g, window.text.b, 0.1)
                            border.width: 1
                            
                            Behavior on color { ColorAnimation { duration: 250; easing.type: Easing.InOutQuad } }

                            Rectangle {
                                width: parent.height - window.s(6)
                                height: parent.height - window.s(6)
                                radius: width / 2
                                color: "white"
                                anchors.verticalCenter: parent.verticalCenter
                                
                                property real targetX: model.gamemode ? parent.width - width - window.s(3) : window.s(3)
                                x: targetX
                                Behavior on x { NumberAnimation { duration: 250; easing.type: Easing.OutBack; easing.overshoot: 1.2 } }
                                
                                // Small drop shadow for the knob
                                Rectangle {
                                    anchors.fill: parent
                                    anchors.margins: -1
                                    radius: parent.radius
                                    color: "transparent"
                                    border.color: Qt.rgba(0,0,0,0.1)
                                }
                            }

                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    appList.currentIndex = index;
                                    toggleGamemode(index);
                                }
                            }
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: {
                            appList.currentIndex = index;
                            toggleGamemode(index);
                        }
                    }
                }
            }
        }
    }
}