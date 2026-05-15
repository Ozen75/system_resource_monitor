import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtGraphs

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
                    text: backend.cpuValue.toFixed(1) + "%"
                    color: "white"; font.pixelSize: 16
                }
            }

            ProgressBar {
                id: cpuBar
                value: backend.cpuValue / 100
                Behavior on value {
                    NumberAnimation { duration: 500; easing.type: Easing.OutCubic }
                }
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
                Behavior on value {
                    NumberAnimation { duration: 500; easing.type: Easing.OutCubic }
                }
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

        // Network
        // ColumnLayout {
        //     spacing: 10
        //     Layout.fillWidth: true

        //     RowLayout {
        //         Text { text: "Network Usage"; color: "#fab387"; font.pixelSize: 16 }
        //         Item { Layout.fillWidth: true }
        //         Text {
        //             text: backend.netValue.toFixed(1) + "%"
        //             color: "white"; font.pixelSize: 16
        //         }
        //     }

        //     ProgressBar {
        //         id: netBar
        //         value: backend.netValue / 100
        //         Behavior on value {
        //             NumberAnimation { duration: 500; easing.type: Easing.OutCubic }
        //         }
        //         Layout.fillWidth: true
        //         background: Rectangle {
        //             implicitHeight: 12
        //             color: "#313244"
        //             radius: 6
        //         }
        //         contentItem: Item {
        //             Rectangle {
        //                 width: netBar.visualPosition * parent.width
        //                 height: parent.height
        //                 radius: 6
        //                 color: "#fab387"
        //             }
        //         }
        //     }
        // }

        ColumnLayout {
            // anchors.fill: parent
            Layout.alignment: Qt.AlignCenter
            spacing: 15

            Text {
                text: "Network Activity Monitor"
                color: "white"
                font.bold: true
                font.pixelSize: 16
                Layout.alignment: Qt.AlignHCenter
            }

            // Wadah utama untuk grafik
            GraphsView {
                id: networkGraph
                Layout.fillWidth: true
                Layout.fillHeight: true
                antialiasing: true

                // Sumbu X (Waktu)
                axisX: ValueAxis {
                    min: 0
                    max: 20 // Menampilkan 20 titik terakhir
                    labelFormat: "%.0f"
                }

                // Sumbu Y (Speed Mbps)
                axisY: ValueAxis {
                    min: 0
                    max: 100 // Bisa dibuat dinamis nantinya
                    labelFormat: "%.1f Mbps"
                }

                LineSeries {
                    id: downloadSeries
                    name: "Download"
                    color: "#89b4fa" // Warna biru pastel
                    width: 2

                    // Titik dummy awal
                    XYPoint { x: 0; y: 0 }
                    XYPoint { x: 5; y: 15 }
                    XYPoint { x: 10; y: 8 }
                    XYPoint { x: 20; y: 25 }
                }
            }
        }

        Item { Layout.fillHeight: true }
    }

    // Data Mock-up
    // property double cpuValue: 45.5
    // property double ramValue: 62.1
}