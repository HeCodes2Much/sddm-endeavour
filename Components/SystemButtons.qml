//
// MIT License
//
// Copyright (c) 2021 Wayne Wesley
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//

import QtQuick 2.11
import QtQuick.Layouts 1.11
import QtQuick.Controls 2.4

RowLayout {

    spacing: root.font.pointSize

    property var suspend: ["Suspend", config.TranslateSuspend || textConstants.suspend, sddm.canSuspend]
    property var hibernate: ["Hibernate", config.TranslateHibernate || textConstants.hibernate, sddm.canHibernate]
    property var reboot: ["Reboot", config.TranslateReboot || textConstants.reboot, sddm.canReboot]
    property var shutdown: ["Shutdown", config.TranslateShutdown || textConstants.shutdown, sddm.canPowerOff]

    property Control exposedLogin

    Repeater {

        model: [suspend, hibernate, reboot, shutdown]

        RoundButton {
            id: icon
            text: modelData[1]
            font.pointSize: root.font.pointSize * 0.8
            Layout.alignment: Qt.AlignHCenter
            icon.source: modelData ? Qt.resolvedUrl("../Assets/" + modelData[0] + ".svgz") : ""
            icon.height: 2 * Math.round((root.font.pointSize * 3) / 2)
            icon.width: 2 * Math.round((root.font.pointSize * 3) / 2)
            display: AbstractButton.TextUnderIcon
            visible: modelData[2]
            hoverEnabled: true
            palette.buttonText: root.palette.text
            background: Rectangle {
                height: 2
                color: "transparent"
                width: parent.width
                border.width: parent.visualFocus ? 1 : 0
                border.color: "transparent"
                anchors.top: parent.bottom
            }
            Keys.onReturnPressed: clicked()
            onClicked: {
                parent.forceActiveFocus()
                index == 0 ? sddm.suspend() : index == 1 ? sddm.hibernate() : index == 2 ? sddm.reboot() : sddm.powerOff()
            }
            KeyNavigation.up: exposedLogin
            KeyNavigation.left: index == 0 ? exposedLogin : parent.children[index-1]

            states: [
                State {
                    name: "pressed"
                    when: parent.children[index].down
                    PropertyChanges {
                        target: parent.children[index]
                        palette.buttonText: Qt.darker(root.palette.highlight, 1.1)
                    }
                    PropertyChanges {
                        target: parent.children[index].background
                        border.color: Qt.darker(root.palette.highlight, 1.1)
                    }
                },
                State {
                    name: "hovered"
                    when: parent.children[index].hovered
                    PropertyChanges {
                        target: parent.children[index]
                        palette.buttonText: Qt.lighter(root.palette.highlight, 1.1)
                    }
                    PropertyChanges {
                        target: parent.children[index].background
                        border.color: Qt.lighter(root.palette.highlight, 1.1)
                    }
                },
                State {
                    name: "focused"
                    when: parent.children[index].visualFocus
                    PropertyChanges {
                        target: parent.children[index]
                        palette.buttonText: root.palette.highlight
                    }
                    PropertyChanges {
                        target: parent.children[index].background
                        border.color: root.palette.highlight
                    }
                }
            ]

            transitions: [
                Transition {
                    PropertyAnimation {
                        properties: "palette.buttonText, border.color"
                        duration: 150
                    }
                }
            ]

        }

    }

}
