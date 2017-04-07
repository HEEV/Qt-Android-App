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
                anchors.leftMargin: 240
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.topMargin: 202

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


            CircularGauge {
                id: windometer
                x: 0
                y: 0
                width: parent.width * 0.35
                height: parent.height * 0.45
                anchors.left: parent.left
                tickmarksVisible: true
                anchors.top: parent.top
                maximumValue: 50
                value: UIRaceDataset.windSpeed
                anchors.topMargin: 8
                style: DashboardGaugeStyle {
                }
                minimumValue: 0
                anchors.leftMargin: 0
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
                id: velocityCluster
                height: 104
                anchors.leftMargin: 5
                anchors.topMargin: -104
                anchors.rightMargin: 389
                anchors.left: parent.left
                anchors.right: speedometer.right
                anchors.top: speedometer.bottom
                anchors.bottom: progressBarCluster.top

                Text {
                    id: relativeSpeed
                    color: "#ffffff"
                    text: qsTr("Ṽgw: 14.2 mph")
                    font.pointSize: 32
                    fontSizeMode: Text.Fit
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                }

                Text {
                    id: averageSpeed
                    color: "#ffffff"
                    text: qsTr("Avg. V: 18.2 mph")
                    font.pointSize: 32
                    fontSizeMode: Text.Fit
                    Layout.fillWidth: true
                    Layout.fillHeight: true
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
                    text: qsTr("Current Lap Time: " + UIRaceDataset.currentLapTime)
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
                    text: qsTr("Total Time Elapsed: " + UIRaceDataset.totalTime)
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

                    RowLayout {
                        id: activateRow
                        anchors.fill: parent
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
                            onClicked:
                            {
                                RaceActionManager.startRace();
                            }
                        }

                        StatusIndicator {
                            id: statusIndicator
                            color: "#50f200"
                            active: UIRaceDataset.raceStatus
                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                            Layout.fillWidth: false
                        }


                        Button {
                            id: button1
                            text: qsTr("Stop Race")
                            Layout.fillWidth: false
                            checkable: false
                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                            Layout.fillHeight: false
                            onClicked:
                            {
                                RaceActionManager.stopRace();
                            }
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


                Rectangle {
                    id: logPane
                    width: 200
                    height: 200
                    color: "#303030"
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

                    TextArea {
                        anchors.fill: parent
                        flickableItem.flickableDirection: Flickable.VerticalFlick
                        horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOff
                        verticalScrollBarPolicy: Qt.ScrollBarAsNeeded
                        text: Logger.log;
                        font.capitalization: Font.MixedCase
                        font.family: "Times New Roman"
                        wrapMode: TextEdit.WrapAnywhere
                        readOnly: true

                    }

/*
                    ScrollView
                    {
                        anchors.fill: parent
                        verticalScrollBarPolicy: Qt.ScrollBarAsNeeded
                        horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOff
                        Flickable {
                            id: loggerFlickable
                            anchors.fill: parent

                            TextArea.loggerFlickable: TextArea {
                                id: textArea
                                //text: UIRaceDataset.
                                font.capitalization: Font.capitalization
                                textColor: "#000000"
                                anchors.fill: parent
                            }
                        }
                    }

*/



                }




            }
        }
    }

}
