import QtQuick 2.5
import QtQuick.Window 2.2
import QtQuick.Controls 1.4
import QtQuick.Extras 1.4
import QtQuick.Layouts 1.3
import QtQuick.Controls.Styles 1.4

Window {
    id: window1
    visible: true
    width: 960
    height: 600
    title: qsTr("GUI Practice")

    Rectangle {
        id: mainPane
        anchors.fill: parent
        color: "black"

        CircularGauge {
            id: speedometer
            width: parent.width * 0.5
            height: parent.height * 0.65
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.topMargin: 5

            tickmarksVisible: true
            maximumValue: 50
            minimumValue: 0
            value: 22.5          
            style: CircularGaugeStyle {
                tickmarkStepSize: 5
            }
        }

        ColumnLayout {
            id: windRpmCluster
            anchors.left: parent.left
            anchors.right: speedometer.right
            anchors.top: speedometer.bottom
            anchors.bottom: progressBarCluster.top

            Text {
                id: relativeSpeed
                color: "#ffffff"
                text: qsTr("Relative Speed: 14.2 mph")
                font.pointSize: 32
                fontSizeMode: Text.Fit
                Layout.fillWidth: true
                Layout.fillHeight: true
            }

            Text {
                id: averageSpeed
                color: "#ffffff"
                text: qsTr("Average Speed: 18.2 mph")
                font.pointSize: 32
                fontSizeMode: Text.Fit
                Layout.fillWidth: true
                Layout.fillHeight: true
            }

            Text {
                id: rpm
                color: "#ffffff"
                text: qsTr("RPM: 1200")
                font.pointSize: 32
                fontSizeMode: Text.Fit
                Layout.fillWidth: true
                Layout.fillHeight: true
            }


        }

        Column {
            id: progressBarCluster
            width: parent.width
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom

            Text {
                id: actualProgressTitle
                color: "#ffffff"
                text: qsTr("Actual Progress")
                font.pointSize: 20
                fontSizeMode: Text.Fit
                anchors.left: parent.left
            }

            ProgressBar {
                id: actualProgressBar
                value: 0.5
                width: parent.width
                height: 15
                style: ProgressBarStyle {
                    background: Rectangle {
                        radius: 2
                        color: "darkGray"
                        border.color: "gray"
                        border.width: 1
                    }
                    progress: Rectangle {
                        color: "blue"
                        border.color: "Blue"
                    }
                }
            }

            ProgressBar {
                id: projectedProgressBar
                value: UIRaceDataSet.projectedProgress
                width: parent.width
                height: 15
                style: ProgressBarStyle {
                    background: Rectangle {
                        radius: 2
                        color: "darkGray"
                        border.color: "gray"
                        border.width: 1
                    }
                    progress: Rectangle {
                        color: "red"
                        border.color: "red"
                    }
                }
            }

            Text {
                id: desiredProgressTitle
                color: "#ffffff"
                text: qsTr("Desired Progress")
                font.pointSize: 20
                fontSizeMode: Text.Fit
                anchors.left: parent.left
            }
        }

        ColumnLayout {
            id: timeStats
            anchors.topMargin: 0
            anchors.leftMargin: 0
            anchors.bottomMargin: 0
            anchors.rightMargin: 0
            anchors.left: speedometer.right
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.bottom: progressBarCluster.top
            spacing: 0

            Text {
                id: currentTime
                color: "#ffffff"
                text: qsTr("Current Lap Time: 2:21:332")
                fontSizeMode: Text.Fit
                horizontalAlignment: Text.AlignRight
                font.pointSize: 32
                Layout.fillWidth: true
                Layout.fillHeight: true

            }

            Text {
                id: lastLapTime
                color: "#ffffff"
                text: qsTr("Last Lap Time: 3:02:245")
                fontSizeMode: Text.Fit
                horizontalAlignment: Text.AlignRight
                font.pointSize: 32
                Layout.fillWidth: true
                Layout.fillHeight: true
            }

            Text {
                id: totalElapsedTime
                color: "#ffffff"
                text: qsTr("Total Time Elapsed: 5:23:577")
                fontSizeMode: Text.Fit
                horizontalAlignment: Text.AlignRight
                font.pointSize: 32
                Layout.fillWidth: true
                Layout.fillHeight: true
            }

            Text {
                id: batteryLevel
                color: "#ffffff"
                text: qsTr("Battery 73%")
                fontSizeMode: Text.Fit
                horizontalAlignment: Text.AlignRight
                font.pointSize: 32
                Layout.fillWidth: true
                Layout.fillHeight: true
            }

            Text {
                id: currentLap
                color: "#ffffff"
                text: qsTr("Lap 2")
                fontSizeMode: Text.Fit
                horizontalAlignment: Text.AlignRight
                font.pointSize: 32
                Layout.fillWidth: true
                Layout.fillHeight: true
            }
        }
    }
}
