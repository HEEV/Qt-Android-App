import QtQuick 2.5
import QtQuick.Window 2.2
import QtQuick.Controls 1.4
import QtQuick.Extras 1.4
import QtQuick.Layouts 1.3
import QtQuick.Controls.Styles 1.4

Window {
    id: applicationWindow
    visible: true
    width: Screen.width
    height: Screen.height
    title: qsTr("AndroidCANDashboard")

    Flickable {
        id: flickable
        boundsBehavior: Flickable.StopAtBounds
        flickableDirection: Flickable.HorizontalFlick
        contentWidth: applicationWindow.width*2
        contentHeight: applicationWindow.height

        anchors.fill: parent

        /*
          flickSlowThreshold: The slowest flick speed to tolerate before snapping
          to either the dashboard or the logging screen.

          Note: Multiplying flickDeceleration by a number between 0 and 1
          allows us to choose a cutoff based on how long it would have taken the
          flick to finish on its own. (e.g. flickDeceleration * 0.5 means snap when the
          flick has 1/2 second of movement left.)
        */
        property int flickSlowThreshold: flickDeceleration * 0.4
        property bool aboutToStop: Math.abs(horizontalVelocity) < flickSlowThreshold

        /*
          flickFastThreshold: The fastest flick speed tolerate before snapping
          to either the dashboard or the logging screen.
        */
        property int flickFastThreshold: flickDeceleration * 2
        property bool fastEnoughToAutoSnap: Math.abs(horizontalVelocity) > flickFastThreshold

        // The number of milliseconds a snap animation should take
        property int snapDuration: 200

        /*
          Decides whether or not to snap based on how fast the flickable pane is moving
        */
        onHorizontalVelocityChanged: {
            // Only consider snapping if the user is not currently dragging the screen
            if (!draggingHorizontally) {
                if (aboutToStop) {
                    if (flickable.contentX < flickable.contentWidth / 4) {
                        // Snap to dashboard
                        snapToDashboard();
                    } else {
                        // Snap to logging screen
                        snapToLogScreen();
                    }
                } else if (fastEnoughToAutoSnap) {
                    // If moving to the right
                    if (horizontalVelocity < 0) {
                        // Snap to dashboard
                        snapToDashboard();
                    // if moving to the left
                    } else {
                        // Snap to logging screen
                        snapToLogScreen();
                    }
                }
            }
        }

        function snapToDashboard() {
            snapAnimation.to = 0;
            snapAnimation.start();
        }

        function snapToLogScreen() {
            snapAnimation.to = flickable.contentWidth / 2;
            snapAnimation.start();
        }

        NumberAnimation on contentX {
            id: snapAnimation
            duration: snapDuration
        }

        Rectangle {
            id: leftPane1
            color: "#000000"
            width: parent.width*3/20
            height: parent.height

            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.left: parent.left

            RoundGauge {
                id: windometer
                width: parent.width - 5
                height: parent.width
                anchors.top: parent.top
                anchors.left: parent.left

                anchors.bottomMargin: 5
                anchors.leftMargin: 5
                anchors.rightMargin: 0

                outerCirclingColor: "#ff2200"
                textFont.family : "Helvetica"
                textFont.bold : true
                textFont.italic : true
                digitalFont.family : "Helvetica"
                digitalFont.bold : true
                digitalFont.italic : true

                //            textFont.pointSize : 12

                unit: "mph"
                unitFont.pointSize: 12
                unitFont.bold: true
                unitFont.italic: true
                unitFont.family: "Helvetica"
                fullCircle: true
                subDivs: 35
                minValue: -35
                maxValue: 35
                lowValues: -20
                highValues: 20
                currentValue: UIRaceDataset.windSpeed
                digitalFont.pointSize: 15
            }

//            CircularGauge {
//                id: windometer
//                width: parent.width - 5
//                height: parent.width

//                anchors.top: parent.top
//                anchors.left: parent.left

//                anchors.topMargin: 5
//                anchors.leftMargin: 5
//                anchors.rightMargin: 0

//                tickmarksVisible: true
//                maximumValue: 25
//                minimumValue: -25
//                value: UIRaceDataset.windSpeed
//                style: DashboardGaugeStyle {}

//                //Every time the number changes this is the animation to play in response.
//                Behavior on value
//                {
//                    NumberAnimation
//                    {
//                        //How long the animation should take in milliseconds
//                        duration: 300
//                        //The style of animation to be played.
//                        easing.type: Easing.InOutSine
//                    }
//                }
//            }

            Rectangle {
                id: windLabel
                color: "#000000"
                width: parent.width
                height: parent.height*1/14

                anchors.top: windometer.bottom
                anchors.left: parent.left
                anchors.right: parent.right

                Text {
                    id: windSpeedLabel
                    color: "#ffffff"
                    text: qsTr("Ṽgw")
                    fontSizeMode: Text.Fit
                    horizontalAlignment: Text.AlignHCenter
                    font.pointSize: 32

                    anchors.bottom: parent.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }

            ColumnLayout {
                id: velocityCluster
                width: parent.width
                height: parent.height * .15

                anchors.left: parent.left
                anchors.bottom: parent.bottom

                anchors.leftMargin: 2
                anchors.bottomMargin: 2

//                Text {
//                    id: relativeSpeed
//                    color: "#ffffff"
//                    text: qsTr("Ṽgw: 25.0 mph")
//                    font.pointSize: 24
//                    fontSizeMode: Text.Fit

//                    anchors.bottom: averageSpeed.top
//                }

                Text {
                    id: averageSpeed
                    color: "#ffffff"
                    text: qsTr("Avg. V: 25.0 mph")
                    font.pointSize: 24
                    fontSizeMode: Text.Fit

                    anchors.bottom: parent.bottom
                }


            }

        }

        Rectangle {
            id: middlePane1
            color: "#000000"
            width: parent.width*4/20
            height: parent.height

            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.left: leftPane1.right

            Rectangle {
                id: lapCount
                color: "#000000"
                width: parent.width

                anchors.top: parent.top
                anchors.bottom: speedometer.top
                anchors.left: parent.left
                anchors.right: parent.right

                anchors.topMargin: 2
                anchors.bottomMargin: 2
                anchors.leftMargin: 2
                anchors.rightMargin: 2

                Text {
                    id: lap
                    color: "#ffffff"
                    text: qsTr("Lap")
                    fontSizeMode: Text.Fit
                    horizontalAlignment: Text.AlignHCenter
                    font.pointSize: 32

                    anchors.bottom: lapNumber.top
                    anchors.horizontalCenter: parent.horizontalCenter
                }
                Text {
                    id: lapNumber
                    color: "#ffffff"
                    text: qsTr("2")
                    fontSizeMode: Text.Fit
                    horizontalAlignment: Text.AlignHCenter
                    font.pointSize: 32

                    anchors.bottom: parent.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }

            RoundGauge {
                id: speedometer
                width: parent.width
                height: parent.width
                anchors.bottom: groundLabel.top
                anchors.left: parent.left

                anchors.bottomMargin: 5
                anchors.leftMargin: 1
                anchors.rightMargin: 1

                outerCirclingColor: "#ff2200"
                textFont.family : "Helvetica"
                textFont.bold : true
                textFont.italic : true
                digitalFont.family : "Helvetica"
                digitalFont.bold : true
                digitalFont.italic : true

                //            textFont.pointSize : 12

                unit: "mph"
                unitFont.pointSize: 12
                unitFont.bold: true
                unitFont.italic: true
                unitFont.family: "Helvetica"
                fullCircle: true
                subDivs: 33
                minValue: 0
                maxValue: 75
                lowValues: 10
                highValues: 50
                currentValue: UIRaceDataset.groundSpeed
                digitalFont.pointSize: 15
            }

//            CircularGauge {
//                id: speedometer
//                width: parent.width
//                height: parent.width

//                anchors.bottom: groundLabel.top
//                anchors.left: parent.left

//                anchors.bottomMargin: 5
//                anchors.leftMargin: 1
//                anchors.rightMargin: 1


//                tickmarksVisible: true
//                maximumValue: 50
//                minimumValue: 0
//                value: UIRaceDataset.groundSpeed
//                style: DashboardGaugeStyle {}
//                //Every time the number changes this is the animation to play in response.
//                Behavior on value
//                {
//                    NumberAnimation
//                    {
//                        //How long the animation should take
//                        duration: 300
//                        //The style of animation to be played.
//                        easing.type: Easing.InOutSine
//                    }
//                }
//            }

            Rectangle {
                id: groundLabel
                color: "#000000"
                width: parent.width
                height: parent.height*1/14

                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right

                Text {
                    id: grooundSpeedLabel
                    color: "#ffffff"
                    text: qsTr("Vg")
                    fontSizeMode: Text.Fit
                    horizontalAlignment: Text.AlignHCenter
                    font.pointSize: 32

                    anchors.bottom: parent.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
        }

        Rectangle {
            id: rightPane1
            color: "#000000"
            width: parent.width*3/20
            height: parent.height

            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.left: middlePane1.right

            Column {
                id: timeStats
                width: parent.width

                anchors.top: parent.top
                anchors.right: parent.right

                Text {
                    id: currentTime
                    color: "#ffffff"
                    Layout.fillWidth: true
                    font.pointSize: 24
                    horizontalAlignment: Text.AlignRight
                    text: qsTr("Current Lap Time: " + UIRaceDataset.currentLapTime)

//                    anchors.top: parent.top
                    anchors.right: parent.right
                }

                Text {
                    id: lastLapTime
                    color: "#ffffff"
                    Layout.fillWidth: true
                    font.pointSize: 24
                    horizontalAlignment: Text.AlignRight
                    text: qsTr("Last Lap Time: 7:77:777")

//                    anchors.top: currentTime.bottom
                    anchors.right: parent.right
                }

                Text {
                    id: totalElapsedTime
                    color: "#ffffff"
                    Layout.fillWidth: true
                    font.pointSize: 24
                    horizontalAlignment: Text.AlignRight
                    text: qsTr("Total Time Elapsed: " + UIRaceDataset.totalTime)

//                    anchors.top: lastLapTime.bottom
                    anchors.right: parent.right
                }

                Text {
                    id: batteryLevel
                    color: "#ffffff"
                    Layout.fillWidth: true
                    font.pointSize: 24
                    horizontalAlignment: Text.AlignRight
                    text: qsTr("Battery 73%")

//                    anchors.top: totalElapsedTime.bottom
                    anchors.right: parent.right
                }
            }
        }

        Rectangle {
            id: pane2
            color: "#000000"
            width: parent.width/2
            height: parent.height

            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.right: parent.right

                Rectangle {
                    id: raceControlBar
                    color: "#222222"
                    width: parent.width
                    height: parent.height/5

                    anchors.top: parent.top

                    Rectangle {
                        id: startStopBar
                        color: "#222222"
                        width: parent.width/3
                        height: parent.height

                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter

                        Button {
                            id: startRaceButton
                            text: qsTr("Start Race")
                            checkable: false

                            anchors.right: stopRaceButton.left

                            anchors.rightMargin: 5

                            onClicked:
                            {
                                RaceActionManager.startRace();
                            }
                        }

                        Button {
                            id: stopRaceButton
                            text: qsTr("Stop Race")
                            checkable: false

                            anchors.right: parent.right

//                            onClicked:
//                            {
//                                RaceActionManager.stopRace();
//                            }
                        }

                        StatusIndicator {
                            id: raceActiveIndicator
                            color: "#50f200"
                            active: UIRaceDataset.raceStatus

                            anchors.top: startRaceButton.bottom
                            anchors.horizontalCenter: startRaceButton.horizontalCenter
                        }
                    }

                    Rectangle {
                        id: canControlBar
                        color: "#222222"
                        width: parent.width/3
                        height: parent.height

                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter

                        Button {
                            id: connectCanButton
                            text: qsTr("Connect Can")
                            checkable: false

                            anchors.left: parent.left

                            anchors.rightMargin: 5

//                            onClicked:
//                            {
//                                RaceActionManager.connectCan();
//                            }
                        }

                        Button {
                            id: disconnectCanButton
                            text: qsTr("Disconnect Can")
                            checkable: false

                            anchors.left: connectCanButton.right

//                            onClicked:
//                            {
//                                RaceActionManager.disconnectCan();
//                            }
                        }

                        StatusIndicator {
                            id: canStatusIndicator
                            color: "#50f200"
                            active: UIRaceDataset.canStatus

                            anchors.top: connectCanButton.bottom
                            anchors.horizontalCenter: connectCanButton.horizontalCenter
                        }
                    }
                }


                Rectangle {
                    id: logPane
                    color: "#303030"
                    width: parent.width
                    Layout.fillHeight: true

                    anchors.top: raceControlBar.bottom
                    anchors.bottom: parent.bottom

                    TextArea {
                        flickableItem.flickableDirection: Flickable.VerticalFlick
                        horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOff
                        verticalScrollBarPolicy: Qt.ScrollBarAsNeeded
                        readOnly: true

                        text: Logger.log;
                        font.capitalization: Font.MixedCase
                        font.family: "Times New Roman"
                        wrapMode: TextEdit.WrapAnywhere

                        anchors.fill: parent
                    }
                }

        }
    }
}
