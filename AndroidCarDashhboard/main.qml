import QtQuick 2.5
import QtQuick.Window 2.2
import QtQuick.Controls 1.4
import QtQuick.Extras 1.4
import QtQuick.Layouts 1.3
import QtQuick.Controls.Styles 1.4

/*
  The main application window.
*/
Window {
    id: applicationWindow
    visible: true
    width: Screen.width
    height: Screen.height
    title: qsTr("AndroidCANDashboard")

    /*
      The two screens within the main application widown including a horozontal
      scrolling feature to switch between them.
    */
    Flickable {
        id: flickable
        boundsBehavior: Flickable.StopAtBounds
        flickableDirection: Flickable.HorizontalFlick
        contentWidth: parent.width*2
        contentHeight: parent.height

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


        onHorizontalVelocityChanged: decideToSnap()
        // this is important in case the user keeps his finger on the screen
        // until the flickable has stopped moving.
        onDragEnded: decideToSnap()

        /*
          Decides whether or not to snap based on how fast the flickable pane is moving
        */
        function decideToSnap()
        {
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

        function snapToDashboard()
        {
            snapAnimation.to = 0;
            snapAnimation.start();
        }

        function snapToLogScreen()
        {
            snapAnimation.to = flickable.contentWidth / 2;
            snapAnimation.start();
        }

        NumberAnimation on contentX
        {
            id: snapAnimation
            duration: snapDuration
        }

        /*
          The left pane of the the two main application windows. Items within this
          pane are ordered top-bottom-left-right.
        */
        Rectangle
        {
            id : leftPane
            width: parent.width/2
            height: parent.height
            color : "#000000"
            Component.onCompleted: forceActiveFocus();

            property real randVal : 0;

            /*
              Desktop animations for gauges.
            */
            Keys.onSpacePressed:
            {
                randVal = Math.random();
            }

            Keys.onUpPressed:
            {
                randVal = 1;
            }

            Keys.onDownPressed:
            {
                randVal = 0;
            }

            /*
              The a gauge for the relative velocity of the wind to the car.
            */
            RoundGauge
            {
                id: windometer
                width: parent.width*3/10 - 5
                height: parent.width*3/10
                anchors.top: parent.top
                anchors.left: parent.left

                anchors.bottomMargin: 5
                anchors.leftMargin: 5
                anchors.rightMargin: 0

                outerCirclingColor: "#ff2200"
                textFont.family : "Consolas"
                textFont.bold : true
                textFont.italic : true
                digitalFont.family : "Consolas"
                digitalFont.bold : true
                digitalFont.italic : true

                unit: "Ṽgw: mph"
                unitFont.pointSize: 12
                unitFont.bold: true
                unitFont.italic: true
                unitFont.family: "Consolas"
                fullCircle: true
                subDivs: 13
                minValue: -35
                maxValue: 35
                lowValues: -20
                highValues: 20
                currentValue: (parent.randVal *  (maxValue - minValue) + minValue) | UIRaceDataset.windSpeed;
                digitalFont.pointSize: 15
            }

            /*
              A rectangle to align a collection of race statistics.
            */
            Rectangle
            {
                id: raceStatistics1
                color: "#000000"
                width: averageSpeed.width
                height: lap.height + lapNumber.height + averageSpeed.height

                anchors.bottom: parent.bottom
                anchors.horizontalCenter: windometer.horizontalCenter

                anchors.bottomMargin: 5

                Text
                {
                    id: lap
                    color: "#ffffff"
                    text: qsTr("Lap")
                    fontSizeMode: Text.Fit
                    horizontalAlignment: Text.AlignHCenter
                    font.pointSize: 32
                    font.family: "Consolas"
                    font.bold: true
                    font.italic: true

                    anchors.bottom: lapNumber.top
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Text
                {
                    id: lapNumber
                    color: "#ffffff"
                    text: qsTr("2")
                    fontSizeMode: Text.Fit
                    horizontalAlignment: Text.AlignHCenter
                    font.pointSize: 32
                    font.family: "Consolas"
                    font.bold: true
                    font.italic: true

                    anchors.bottom: averageSpeed.top
                    anchors.horizontalCenter: lap.horizontalCenter
                }

                Text
                {
                    id: averageSpeed
                    color: "#ffffff"
                    text: qsTr("Avg. V: 25.0 mph")
                    font.pointSize: 24
                    fontSizeMode: Text.Fit
                    font.family: "Consolas"
                    font.bold: true
                    font.italic: true

                    anchors.bottom: parent.bottom
                    anchors.horizontalCenter: parent.horizontalCenter

                    anchors.bottomMargin: 5
                }
            }

            /*
              Another rectangle to align a second collection of race statistics.
            */
            Rectangle
            {
                id: raceStatistics2
                color: "#000000"
                width: lapTime.width
                height: totalTime.height + lapTime.height + lastLapTime.height

                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter

                anchors.topMargin: 5

                Text
                {
                    id: totalTime
                    color: "#ffffff"
                    font.pointSize: 24
                    fontSizeMode: Text.Fit
                    horizontalAlignment: Text.AlignRight
                    text: qsTr("Total Time: " + UIRaceDataset.totalTime)
                    font.family: "Consolas"
                    font.bold: true
                    font.italic: true

                    anchors.top: parent.top
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Text
                {
                    id: lapTime
                    color: "#ffffff"
                    font.pointSize: 24
                    fontSizeMode: Text.Fit
                    horizontalAlignment: Text.AlignRight
                    text: qsTr("Current Lap: " + UIRaceDataset.currentLapTime)
                    font.family: "Consolas"
                    font.bold: true
                    font.italic: true

                    anchors.top: totalTime.bottom
                    anchors.right: totalTime.right
                }

                Text
                {
                    id: lastLapTime
                    color: "#ffffff"
                    font.pointSize: 24
                    fontSizeMode: Text.Fit
                    horizontalAlignment: Text.AlignRight
                    text: qsTr("Last Lap: 7:77:777")
                    font.family: "Consolas"
                    font.bold: true
                    font.italic: true

                    anchors.top: lapTime.bottom
                    anchors.right: totalTime.right
                }
            }

            /*
              The gauge for the velocity of the car.
            */
            RoundGauge
            {
                id: speedometer
                width: parent.width*4/10
                height: parent.width*4/10
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter

                anchors.bottomMargin: 5
                anchors.leftMargin: 1
                anchors.rightMargin: 1

                outerCirclingColor: "#ff2200"
                textFont.family : "Consolas"
                textFont.bold : true
                textFont.italic : true
                digitalFont.family : "Consolas"
                digitalFont.bold : true
                digitalFont.italic : true

                unit: "Vg: mph"
                unitFont.pointSize: 12
                unitFont.bold: true
                unitFont.italic: true
                unitFont.family: "Consolas"
                fullCircle: true
                subDivs: 14
                minValue: 0
                maxValue: 75
                lowValues: 10
                highValues: 50
                currentValue: (parent.randVal *  (maxValue - minValue) + minValue) | UIRaceDataset.groundSpeed;
                digitalFont.pointSize: 15
            }

            /*
              The guage for the temperature of the engine.
            */
            RoundGauge
            {
                id: thermometer
                width: windometer.width
                height: windometer.height
                anchors.top: parent.top
                anchors.right: parent.right

                anchors.bottomMargin: 5
                anchors.leftMargin: 0
                anchors.rightMargin: 5

                outerCirclingColor: "#ff2200"
                textFont.family : "Consolas"
                textFont.bold : true
                textFont.italic : true
                digitalFont.family : "Consolas"
                digitalFont.bold : true
                digitalFont.italic : true

                unit: "T: °F"
                unitFont.pointSize: 12
                unitFont.bold: true
                unitFont.italic: true
                unitFont.family: "Consolas"
                fullCircle: true
                subDivs: 17
                minValue: 0
                maxValue: 180
                lowValues: 30
                highValues: 150
                currentValue: (parent.randVal *  (maxValue - minValue) + minValue) | UIRaceDataset.thermometer;
                digitalFont.pointSize: 15
            }

            /*
              A rectangle to align a collection of device statistics.
            */
            Rectangle {
                id: deviceStatus
                color: "#000000"
                width: batteryLevel.width
                height: batteryLevel.height

                anchors.bottom: parent.bottom
                anchors.horizontalCenter: thermometer.horizontalCenter

                anchors.bottomMargin: 5

                Text
                {
                    id: batteryLevel
                    color: "#ffffff"
                    font.pointSize: 24
                    fontSizeMode: Text.Fit
                    horizontalAlignment: Text.AlignRight
                    text: qsTr("Battery: " + "100" + "%")
                    font.family: "Consolas"
                    font.bold: true
                    font.italic: true

                    anchors.bottom: parent.bottom
                    anchors.horizontalCenter: thermometer.horizontalCenter
                }
            }
        }

        /*
          The right pane of the two main application windows. Items in within this
          pane are listed left-right-top-bottom.
        */
        Rectangle
        {
            id: rightPane
            color: "#000000"
            width: parent.width/2
            height: parent.height

            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.right: parent.right

            /*
              A rectangle to align a collection of race buttons and indicators for
              AndroidCarDashboard signals.
            */
            Rectangle
            {
                id: raceControlBar
                color: "#222222"
                width: parent.width
                height: startRaceButton.height + stopRaceButton.height + 15

                anchors.top: parent.top


                Button
                {
                    id: startRaceButton
                    text: qsTr("Start Race")
                    enabled: !UIRaceDataset.raceStatus
                    style: ButtonStyle
                    {
                        background: Rectangle
                        {
                            implicitWidth: 100
                            implicitHeight: canStatusIndicator.height
                            border.width: control.activeFocus ? 2 : 1
                            border.color: "#888"
                            radius: 4
                            gradient: Gradient
                            {
                                GradientStop { position: 0 ; color: control.pressed ? "#ccc" : "#eee" }
                                GradientStop { position: 1 ; color: control.pressed ? "#aaa" : "#ccc" }
                            }
                        }
                    }

                    anchors.top: parent.top
                    anchors.left: parent.left

                    anchors.topMargin: 5
                    anchors.bottomMargin: 5
                    anchors.leftMargin: 5
                    anchors.rightMargin: 5

                    onClicked:
                    {
                        RaceActionManager.startRace();
                    }
                }

                Button
                {
                    id: stopRaceButton
                    text: qsTr("Stop Race")
                    enabled: UIRaceDataset.raceStatus

                    style: ButtonStyle
                    {
                        background: Rectangle
                        {
                            implicitWidth: startRaceButton.width
                            implicitHeight: canStatusIndicator.height
                            border.width: control.activeFocus ? 2 : 1
                            border.color: "#888"
                            radius: 4
                            gradient: Gradient
                            {
                                GradientStop { position: 0 ; color: control.pressed ? "#ccc" : "#eee" }
                                GradientStop { position: 1 ; color: control.pressed ? "#aaa" : "#ccc" }
                            }
                        }
                    }

                    anchors.bottom: parent.bottom
                    anchors.horizontalCenter: startRaceButton.horizontalCenter

                    anchors.bottomMargin: 5

                    onClicked:
                    {
                        RaceActionManager.stopRace();
                    }
                }

                StatusIndicator
                {
                    id: raceActiveIndicator
                    color: "#50f200"
                    active: UIRaceDataset.raceStatus

                    anchors.left: startRaceButton.right
                    anchors.verticalCenter: parent.verticalCenter

                    anchors.leftMargin: 5
                }


                Label
                {
                    id: canStatusLabel
                    color: "#ffffff"
                    text: qsTr("Can Status")

                    anchors.bottom: canStatusIndicator.top
                    anchors.horizontalCenter: parent.horizontalCenter

                    anchors.topMargin: 5
                    anchors.bottomMargin: 5
                }

                StatusIndicator
                {
                    id: canStatusIndicator
                    color: "#50f200"
                    active: UIRaceDataset.canStatus

                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: canStatusLabel.horizontalCenter

                    anchors.topMargin: 5
                }

                Label
                {
                    id: networkStatusLabel
                    color: "#ffffff"
                    text: qsTr("Network Status")

                    anchors.bottom: networkStatusIndicator.top
                    anchors.right: parent.right

                    anchors.topMargin: 5
                    anchors.bottomMargin: 5
                    anchors.rightMargin: 10
                }

                StatusIndicator
                {
                    id: networkStatusIndicator
                    color: "#50f200"
                    active: UIRaceDataset.networkStatus

                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: networkStatusLabel.horizontalCenter

                    anchors.topMargin: 5
                }

            }

            /*
              A rectangle to align the log window for the AndroidCarDashboard.
            */
            Rectangle
            {
                id: logPane
                color: "#303030"
                width: parent.width
                Layout.fillHeight: true

                anchors.top: raceControlBar.bottom
                anchors.bottom: parent.bottom

                TextArea
                {
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
