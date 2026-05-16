import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtGraphs

ApplicationWindow {
    visible: true
    width: 600
    height: 700
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

        // CPU Section
        ColumnLayout {
            spacing: 10
            Layout.fillWidth: true

            RowLayout {
                Text { text: "CPU Usage"; color: "#ffa56e"; font.pixelSize: 16; font.bold: true }
                Item { Layout.fillWidth: true }
                Text {
                    text: backend.cpuValue.toFixed(1) + "%"
                    color: "white"; font.pixelSize: 16
                    font.bold: true
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
                        color: "#ffa56e"
                    }
                }
            }
        }

        // RAM Section
        ColumnLayout {
            spacing: 10
            Layout.fillWidth: true

            RowLayout {
                Text { text: "RAM Usage"; color: "#ffa56e"; font.pixelSize: 16; font.bold: true }
                Item { Layout.fillWidth: true }
                Text {
                    text: backend.ramValue.toFixed(1) + "%"
                    color: "white"; font.pixelSize: 16
                    font.bold: true
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
                        color: "#ffa56e"
                    }
                }
            }
        }

        // ==================== FIX NETWORK SECTION ====================
        Item {
            id: networkSection // FIX 1: Beri ID agar properti di bawah bisa diakses tanpa ReferenceError
            property int timeTicks: 0

            // FIX 2: Beri instruksi Layout agar Item ini mengambil sisa ruang kosong dan tidak gepeng
            Layout.fillWidth: true
            Layout.fillHeight: true

            ColumnLayout {
                anchors.fill: parent
                spacing: 10

                Text {
                    text: "Download Speed: " + backend.netValue.toFixed(2) + " Mbps"
                    color: "#ffa56e"
                    font.pixelSize: 18
                    font.bold: true
                }

                GraphsView {
                    id: graphView
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    theme: GraphsTheme {
                        gridVisible: true
                        grid.mainWidth: 1.0
                        grid.mainColor: "#404040"
                    }

                    axisX: ValueAxis {
                        id: xAxis
                        min: 0
                        max: 20
                    }

                    axisY: ValueAxis {
                        id: yAxis
                        min: 0
                        max: 50
                    }

                    LineSeries {
                        id: downloadSeries
                        name: "Network Traffic"
                        color: "#ffa56e"
                        width: 3
                    }
                }
            }

            Connections {
                target: backend

                function onNetValueChanged() {
                    // FIX 3: Gunakan 'networkSection.timeTicks' agar jalurnya absolut dan jelas
                    downloadSeries.append(networkSection.timeTicks, backend.netValue)
                    networkSection.timeTicks++

                    if (networkSection.timeTicks > 20) {
                        xAxis.min = networkSection.timeTicks - 20
                        xAxis.max = networkSection.timeTicks

                        downloadSeries.remove(0)
                    }

                    if (backend.netValue > yAxis.max) {
                        yAxis.max = backend.netValue + 10
                    }
                }
            }
        }
    }
}