import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import qs.Common
import qs.Services
import qs.Modules.Plugins

// Port of minflair's KeybindsCheatSheet (t4lentles5/minflair, GPL-3.0).
// Structure, dimensions and layout carried over as-is; only the
// color and data sources are adapted to DMS.
PluginComponent {
    id: root

    property var popoutService: null

    // ── Equivalents of minflair's qs.Core.Constants ─────────────────────
    readonly property int size2Xs: 4
    readonly property int sizeXs: 8
    readonly property int sizeSm: 12
    readonly property int sizeMd: 14
    readonly property int sizeLg: 16
    readonly property int size4Xl: 40
    readonly property string fontFamily: Theme.fontFamily

    // ── Equivalents of minflair's qs.Core.Theme ─────────────────────────
    readonly property color cFg: Theme.surfaceText
    readonly property color cMuted: Theme.surfaceVariantText
    readonly property color cAccent: Theme.primary
    readonly property color cBg: Theme.surfaceContainer
    readonly property color cBgSecondary: Theme.surfaceContainerHigh
    readonly property color cBorder: Qt.rgba(Theme.outline.r, Theme.outline.g, Theme.outline.b, 0.4)

    property int selectedCategory: 0
    property string searchText: ""

    // ── Data: KeybindsService replaces parse_keybinds.py ────────────────
    // Rebuilding the same shape as its processKeybindData():
    //   [ { section, bindCount, binds: [ { desc, uiElements } ] } ]
    readonly property var keybindData: {
        const cats = KeybindsService._categories || [];
        const all = KeybindsService._allBinds || ({});
        let processed = [];
        for (const cat of cats) {
            const binds = all[cat] || [];
            let newBinds = [];
            for (const b of binds) {
                // Splits "SUPER + SHIFT + W" into badges + "+" separators,
                // exactly like its loop over keys[].
                const keys = (b.key || "").split("+").map(s => s.trim()).filter(s => s !== "");
                let result = [];
                for (let k = 0; k < keys.length; k++) {
                    if (k > 0)
                        result.push({
                            "text": "+",
                            "isKey": false
                        });
                    result.push({
                        "text": keys[k],
                        "isKey": true
                    });
                }
                newBinds.push({
                    "uiElements": result,
                    "desc": b.desc || b.action || ""
                });
            }
            processed.push({
                "section": cat,
                "binds": newBinds,
                "bindCount": newBinds.length
            });
        }
        return processed;
    }

    // Carried over from its computedBinds: global search, else category.
    readonly property var computedBinds: {
        const data = root.keybindData;
        if (data.length === 0)
            return [];

        if (root.searchText !== "") {
            let matches = [];
            const lowerSearch = root.searchText.toLowerCase();
            for (let i = 0; i < data.length; i++) {
                const cat = data[i];
                for (let j = 0; j < cat.binds.length; j++) {
                    const bind = cat.binds[j];
                    const matchDesc = bind.desc && bind.desc.toLowerCase().indexOf(lowerSearch) !== -1;
                    let matchKey = false;
                    for (let k = 0; k < bind.uiElements.length; k++) {
                        if (bind.uiElements[k].isKey && bind.uiElements[k].text.toLowerCase().indexOf(lowerSearch) !== -1) {
                            matchKey = true;
                            break;
                        }
                    }
                    if (matchDesc || matchKey)
                        matches.push(bind);
                }
            }
            return matches;
        }
        if (root.selectedCategory < 0 || root.selectedCategory >= data.length)
            return [];

        return data[root.selectedCategory].binds;
    }

    function openSheet() {
        KeybindsService.loadBinds(false);
        root.selectedCategory = 0;
        root.searchText = "";
        sheetLoader.active = true;
    }

    function closeSheet() {
        sheetLoader.active = false;
        root.searchText = "";
        root.selectedCategory = 0;
    }

    IpcHandler {
        target: "minflairKeybinds"

        function toggle(): string {
            if (sheetLoader.active)
                root.closeSheet();
            else
                root.openSheet();
            return "OK";
        }

        function open(): string {
            root.openSheet();
            return "OK";
        }

        function close(): string {
            root.closeSheet();
            return "OK";
        }
    }

    Loader {
        id: sheetLoader

        active: false

        sourceComponent: PanelWindow {
            WlrLayershell.layer: WlrLayer.Overlay
            WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
            WlrLayershell.namespace: "dms:minflair-keybinds"
            color: "transparent"

            anchors {
                top: true
                bottom: true
                left: true
                right: true
            }

            MouseArea {
                anchors.fill: parent
                onClicked: root.closeSheet()
            }

            // Its AppWindow: contentPadding 0, the sidebar touches the edge.
            Rectangle {
                id: appWindow

                width: Math.min(parent.width * 0.72, 1000)
                height: Math.min(parent.height * 0.7, 620)
                anchors.centerIn: parent
                radius: root.sizeLg
                color: Qt.rgba(root.cBg.r, root.cBg.g, root.cBg.b, 0.75)
                clip: true

                MouseArea {
                    anchors.fill: parent
                }

                Shortcut {
                    sequence: "Escape"
                    onActivated: root.closeSheet()
                }

                // Tab / Shift+Tab to change category, like the original
                Shortcut {
                    sequence: "Tab"
                    enabled: root.keybindData.length > 0
                    onActivated: root.selectedCategory = (root.selectedCategory + 1) % root.keybindData.length
                }

                Shortcut {
                    sequence: "Shift+Tab"
                    enabled: root.keybindData.length > 0
                    onActivated: root.selectedCategory = (root.selectedCategory - 1 + root.keybindData.length) % root.keybindData.length
                }

                RowLayout {
                    anchors.fill: parent
                    spacing: 0

                    // ══ SearchableSidebar ════════════════════════════════
                    Rectangle {
                        Layout.preferredWidth: 260
                        Layout.maximumWidth: 260
                        Layout.minimumWidth: 260
                        Layout.fillHeight: true
                        color: Qt.rgba(root.cBgSecondary.r, root.cBgSecondary.g, root.cBgSecondary.b, 0.75)
                        radius: root.sizeLg

                        Rectangle {
                            anchors.right: parent.right
                            anchors.top: parent.top
                            anchors.bottom: parent.bottom
                            width: parent.radius
                            color: parent.color
                        }
                        
                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: root.sizeLg
                            spacing: root.sizeLg

                            // ThemedSearchBar: pill shape, accent border on focus
                            FocusScope {
                                Layout.fillWidth: true
                                Layout.preferredHeight: root.size4Xl

                                Rectangle {
                                    anchors.fill: parent
                                    color: root.cBgSecondary
                                    radius: height / 2
                                    border.width: 1
                                    border.color: searchInput.activeFocus ? root.cAccent : root.cBorder
                                }

                                RowLayout {
                                    anchors.fill: parent
                                    anchors.leftMargin: root.sizeLg
                                    anchors.rightMargin: root.sizeLg

                                    TextField {
                                        id: searchInput

                                        focus: true
                                        Layout.fillWidth: true
                                        placeholderText: "Search keybinds..."
                                        placeholderTextColor: root.cMuted
                                        font.family: root.fontFamily
                                        font.pixelSize: root.sizeMd
                                        color: root.cFg
                                        selectByMouse: true
                                        background: null
                                        onTextChanged: root.searchText = text
                                    }
                                }
                            }

                            // One SidebarItem per category
                            Repeater {
                                model: root.keybindData

                                delegate: SidebarItem {
                                    required property int index
                                    required property var modelData

                                    Layout.fillWidth: true
                                    label: modelData.section
                                    subLabel: modelData.bindCount
                                    isActive: index === root.selectedCategory && root.searchText === ""
                                    onClicked: {
                                        root.selectedCategory = index;
                                        searchInput.text = "";
                                    }
                                }
                            }

                            Item {
                                Layout.fillHeight: true
                            }
                        }
                    }

                    // ══ KeybindsList ════════════════════════════════════
                    Flickable {
                        id: rightFlick

                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        contentHeight: Math.max(bindsCol.implicitHeight, rightFlick.height)
                        clip: true
                        flickableDirection: Flickable.VerticalFlick

                        ColumnLayout {
                            id: bindsCol

                            width: rightFlick.width - root.sizeLg * 2
                            x: root.sizeLg
                            y: root.sizeLg
                            spacing: root.sizeLg

                            // Single card containing all displayed binds
                            Rectangle {
                                Layout.fillWidth: true
                                implicitHeight: cardCol.implicitHeight + root.sizeLg * 2
                                color: root.cBgSecondary
                                radius: root.sizeLg

                                ColumnLayout {
                                    id: cardCol

                                    anchors.left: parent.left
                                    anchors.right: parent.right
                                    anchors.top: parent.top
                                    anchors.margins: root.sizeLg
                                    spacing: root.sizeLg

                                    // Section title, like its subheader
                                    Text {
                                        text: root.searchText !== "" ? "Results" : (root.keybindData[root.selectedCategory] ? root.keybindData[root.selectedCategory].section : "")
                                        font.family: root.fontFamily
                                        font.pixelSize: root.sizeSm
                                        color: root.cMuted
                                    }

                                    Repeater {
                                        model: root.computedBinds

                                        delegate: KeybindItem {
                                            required property var modelData

                                            Layout.fillWidth: true
                                            uiElements: modelData.uiElements || []
                                            desc: modelData.desc || ""
                                        }
                                    }
                                }
                            }

                            Item {
                                Layout.fillWidth: true
                                Layout.preferredHeight: 40
                                visible: root.computedBinds.length === 0

                                Text {
                                    anchors.centerIn: parent
                                    text: "No keybinds loaded"
                                    font.family: root.fontFamily
                                    font.pixelSize: root.sizeMd
                                    color: root.cMuted
                                }
                            }
                        }
                    }
                }
                Rectangle {
                    anchors.fill: parent
                    radius: parent.radius
                    color: "transparent"
                    border.width: 1
                    border.color: root.cAccent
                    z: 100
                }
            }
        }
    }

    // ══ SidebarItem, ported as-is ═══════════════════════════════════════
    component SidebarItem: Item {
        id: sidebarItem

        property string label: ""
        property string subLabel: ""
        property bool isActive: false
        property bool isHovered: hoverHandler.hovered
        property bool isPressed: tapHandler.pressed
        property color bgColor: sidebarItem.isActive ? Qt.rgba(root.cAccent.r, root.cAccent.g, root.cAccent.b, 0.15) : (sidebarItem.isHovered ? root.cBg : "transparent")

        signal clicked

        implicitHeight: 40
        scale: sidebarItem.isPressed ? 0.98 : 1

        Item {
            anchors.fill: parent
            clip: true

            Rectangle {
                anchors.fill: parent
                anchors.leftMargin: -root.sizeXs
                radius: root.sizeSm
                color: sidebarItem.bgColor
            }
        }

        Rectangle {
            width: 3
            height: parent.height * 0.6
            radius: 1.5
            color: root.cAccent
            visible: sidebarItem.isActive
            anchors.left: parent.left
            anchors.leftMargin: 2
            anchors.verticalCenter: parent.verticalCenter
        }

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: root.sizeLg
            anchors.rightMargin: root.sizeLg
            spacing: root.sizeXs

            Text {
                Layout.fillWidth: true
                text: sidebarItem.label
                color: sidebarItem.isActive || sidebarItem.isHovered ? root.cFg : root.cMuted
                font.family: root.fontFamily
                font.pixelSize: root.sizeMd
                font.weight: sidebarItem.isActive ? Font.Medium : Font.Normal
                elide: Text.ElideRight

                Behavior on color {
                    ColorAnimation {
                        duration: 150
                    }
                }
            }

            Text {
                text: sidebarItem.subLabel
                visible: sidebarItem.subLabel !== ""
                color: root.cMuted
                font.family: root.fontFamily
                font.pixelSize: root.sizeSm
            }
        }

        TapHandler {
            id: tapHandler

            onTapped: sidebarItem.clicked()
        }

        HoverHandler {
            id: hoverHandler

            cursorShape: Qt.PointingHandCursor
        }

        Behavior on bgColor {
            ColorAnimation {
                duration: 150
            }
        }

        Behavior on scale {
            NumberAnimation {
                duration: 150
                easing.type: Easing.OutBack
            }
        }
    }

    // ══ KeybindItem, ported as-is ═══════════════════════════════════════
    component KeybindItem: RowLayout {
        id: keybindItem

        property var uiElements: []
        property string desc: ""

        Text {
            text: keybindItem.desc
            font.family: root.fontFamily
            font.pixelSize: root.sizeMd
            color: root.cFg
            Layout.fillWidth: true
            elide: Text.ElideRight
        }

        Row {
            spacing: 4

            Repeater {
                model: keybindItem.uiElements

                delegate: Item {
                    id: elemRoot

                    required property var modelData

                    width: elemRoot.modelData.isKey ? keyRect.width : sepText.implicitWidth
                    height: 26

                    // Key: 28px tall, 32px min wide, bold text,
                    // with the bottom strip simulating a keycap's relief.
                    Rectangle {
                        id: keyRect

                        visible: elemRoot.modelData.isKey
                        width: Math.max(capText.implicitWidth + 16, 32)
                        height: 28
                        radius: 6
                        color: root.cBg
                        border.color: root.cBorder
                        border.width: 1
                        anchors.verticalCenter: parent.verticalCenter

                        Rectangle {
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.bottom: parent.bottom
                            height: 3
                            radius: 6
                            color: root.cBg
                        }

                        Text {
                            id: capText

                            anchors.centerIn: parent
                            anchors.verticalCenterOffset: -1
                            text: elemRoot.modelData.isKey ? elemRoot.modelData.text : ""
                            color: root.cFg
                            font.family: root.fontFamily
                            font.pixelSize: root.sizeSm
                            font.bold: true
                        }
                    }

                    Text {
                        id: sepText

                        visible: !elemRoot.modelData.isKey
                        text: !elemRoot.modelData.isKey ? elemRoot.modelData.text : ""
                        color: root.cMuted
                        font.family: root.fontFamily
                        font.pixelSize: root.sizeMd
                        font.bold: true
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
            }
        }
    }
}
