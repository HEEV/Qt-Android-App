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
    title: qsTr("AndroidCANDashboard")

    Flickable {
        id: flickable
        boundsBehavior: Flickable.StopAtBounds
        contentWidth: window1.width*2
        contentHeight: window1.height
        flickableDirection: Flickable.HorizontalFlick
        anchors.fill: parent

        Rectangle {
            id: uiPane
            width: parent.width/2
            height: parent.height
            color: "black"
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 0
            anchors.top: parent.top
            anchors.topMargin: 0
            anchors.left: parent.left
            anchors.leftMargin: 0

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
                value: UIRaceDataset.groundSpeed
                style: DashboardGaugeStyle {}
                //Every time the number changes this is the animation to play in response.
                Behavior on value
                {
                    NumberAnimation
                    {
                        //How long the animation should take
                        duration: 300
                        //The style of animation to be played.
                        easing.type: Easing.InOutSine
                    }
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
                    value: UIRaceDataset.projectedProgress
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

        Rectangle {
            id: switchPane
            x: 0
            width: parent.width/2
            height: parent.height
            color: "#000000"
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 0
            anchors.top: parent.top
            anchors.topMargin: 0
            anchors.right: parent.right
            anchors.rightMargin: 0

            ColumnLayout {
                id: columnLayout
                anchors.fill: parent

                Rectangle {
                    id: rectangle
                    width: 200
                    height: 200
                    color: "#222222"
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignTop

                    ColumnLayout {
                        id: columnLayout2
                        anchors.fill: parent

                        RowLayout {
                            id: activateRow
                            width: 100
                            height: 100
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.verticalCenter: parent.verticalCenter
                            spacing: 5
                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

                            Button {
                                id: button
                                text: qsTr("Start Race")
                                Layout.fillWidth: false
                                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                Layout.fillHeight: false
                                checkable: false
                            }

                            StatusIndicator {
                                id: statusIndicator
                                color: "#50f200"
                                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                Layout.fillWidth: false
                                active: UIRaceDataset.canStatus
                            }

                            Rectangle {
                                id: rectangle2
                                width: 200
                                height: 200
                                color: "#222222"
                            }


                            Button {
                                id: button1
                                text: qsTr("Stop Race")
                                Layout.fillWidth: false
                                checkable: false
                                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                Layout.fillHeight: false
                            }


                            StatusIndicator {
                                id: statusIndicator5
                                color: "#50f200"
                                Layout.fillWidth: false
                                active: UIRaceDataset.canStatus
                                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                            }
                        }
                    }

                }


                Rectangle {
                    id: rectangle1
                    width: 200
                    height: 200
                    color: "#303030"
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

                    ColumnLayout {
                        id: columnLayout1
                        anchors.topMargin: 30
                        anchors.fill: parent

                        RowLayout {
                            id: rowLayout3
                            width: 100
                            height: 100
                            anchors.top: parent.top
                            anchors.topMargin: 0
                            anchors.horizontalCenter: parent.horizontalCenter
                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                            Layout.fillWidth: true

                            Text {
                                id: text4
                                color: "#ffffff"
                                text: qsTr("Pressure Sensors")
                                font.pixelSize: 46
                                horizontalAlignment: Text.AlignLeft
                            }

                            StatusIndicator {
                                id: statusIndicator4
                                color: "#50f200"
                                active: false
                            }
                        }

                        RowLayout {
                            id: rowLayout2
                            width: 100
                            height: 100
                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                            Layout.fillWidth: true

                            Text {
                                id: text3
                                color: "#ffffff"
                                text: qsTr("MegaSquirt")
                                font.pixelSize: 46
                                horizontalAlignment: Text.AlignLeft
                            }

                            StatusIndicator {
                                id: statusIndicator3
                                color: "#50f200"
                                active: false
                            }
                        }

                        RowLayout {
                            id: rowLayout1
                            width: 100
                            height: 100
                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                            Layout.fillWidth: true

                            Text {
                                id: text2
                                color: "#ffffff"
                                text: qsTr("Pitot Tube")
                                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                font.pixelSize: 46
                                horizontalAlignment: Text.AlignLeft
                            }

                            StatusIndicator {
                                id: statusIndicator2
                                color: "#50f200"
                                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                active: false
                            }
                        }

                        RowLayout {
                            id: rowLayout
                            width: 100
                            height: 100
                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                            Layout.fillWidth: true

                            Text {
                                id: text1
                                color: "#ffffff"
                                text: qsTr("Speed Sensor")
                                renderType: Text.NativeRendering
                                horizontalAlignment: Text.AlignLeft
                                font.pixelSize: 46
                            }

                            StatusIndicator {
                                id: statusIndicator1
                                color: "#50f200"
                                active: UIRaceDataset.speedSensorStatus
                            }
                        }



                    }



                }




            }
        }
    }

}
