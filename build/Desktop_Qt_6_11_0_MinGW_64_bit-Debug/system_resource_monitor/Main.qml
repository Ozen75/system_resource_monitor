import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ApplicationWindow {
    visible: true
    width: 400
    height: 500
    title: "System Monitoring"
    color: "#1e1e2e"

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 30
        spacing: 25

        Text {
            text: "System Statistics"
            color: "white"
            font.pixelSize: 24
            font.bold: true
            Layout.alignment: Qt.AlignHCenter
        }

        // CPU
        ColumnLayout {
            spacing: 10
            Layout.fillWidth: true

            RowLayout {
                Text { text: "CPU Usage"; color: "#fab387"; font.pixelSize: 16 }
                Item { Layout.fillWidth: true }
                Text {
                    text: cpuValue.toFixed(1) + "%"
                    color: "white"; font.pixelSize: 16
                }
            }

            ProgressBar {
                id: cpuBar
                value: cpuValue / 100
                Layout.fillWidth: true
                background: Rectangle {
                    implicitHeight: 12
                    color: "#313244"
                    radius: 6
                }
                contentItem: Item {
                    Rectangle {
                        width: cpuBar.visualPosition * parent.width
                        height: parent.height
                        radius: 6
                        color: "#fab387"
                    }
                }
            }
        }

        // RAM
        ColumnLayout {
            spacing: 10
            Layout.fillWidth: true

            RowLayout {
                Text { text: "RAM Usage"; color: "#89b4fa"; font.pixelSize: 16 }
                Item { Layout.fillWidth: true }
                Text {
                    text: backend.ramValue.toFixed(1) + "%"
                    color: "white"; font.pixelSize: 16
                }
            }

            ProgressBar {
                id: ramBar
                value: backend.ramValue / 100
                Layout.fillWidth: true
                background: Rectangle {
                    implicitHeight: 12
                    color: "#313244"
                    radius: 6
                }
                contentItem: Item {
                    Rectangle {
                        width: ramBar.visualPosition * parent.width
                        height: parent.height
                        radius: 6
                        color: "#89b4fa"
                    }
                }
            }
        }

        Item { Layout.fillHeight: true }
    }

    // Data Mock-up
    property double cpuValue: 45.5
    property double ramValue: 62.1
}