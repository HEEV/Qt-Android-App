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
    visibility: "FullScreen"
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

            Keys.onVolumeUpPressed:
            {
                randVal = 1;
            }

            Keys.onVolumeDownPressed:
            {
                randVal = 0;
            }

            /*
              The a gauge for the relative velocity of the wind to the car.
            */
            CircularGauge {
                id: windometer
                width: parent.width*3/10
                height: parent.width*3/10

                anchors.top: parent.top
                anchors.left: parent.left

                anchors.topMargin: 5
                anchors.leftMargin: 5
                anchors.rightMargin: 0

                tickmarksVisible: true
                maximumValue: 35
                minimumValue: -35
                value: UIRaceDataset.windSpeed | (parent.randVal * (maximumValue - minimumValue) + minimumValue)

                property real values: UIRaceDataset.windSpeed | (parent.randVal * (maximumValue - minimumValue) + minimumValue)
                property real lowValues: -20
                property real highValues: 20
                property real range : maximumValue - minimumValue
                property real valuesRatio : (values - minimumValue) / range
                property real startAngle : Math.PI * 0.691
                property real endAngle : Math.PI * 2.310
                property real wholeAngle : endAngle - startAngle
                property real needleAngleRad : startAngle + valuesRatio * wholeAngle
                property real needleAngle : needleAngleRad  * 180 / Math.PI

                Behavior on needleAngleRad {SpringAnimation {spring: 1.2; damping: 0.3;}}
                onNeedleAngleRadChanged: windometerValueGradient.requestPaint();

                style: NewDashboardGaugeStyle
                {
                    minValue: parent.minimumValue
                    maxValue: parent.maximumValue
                    lowValues: parent.lowValues
                    highValues: parent.highValues
                    label: "Ṽgw: mph"
                    values: UIRaceDataset.windSpeed | (parent.randVal * (maxValue - minValue) + minValue)
                }

                Canvas
                {
                    id: windometerValueGradient
                    anchors.fill: parent
                    antialiasing: true

                    property real startAngle : Math.PI * 0.691
                    property real endAngle : Math.PI * 2.310
                    property color lowValuesColor: "#0066FF"
                    property color highValuesColor: "#cc0000"
                    property real values: parent.values

                    function getArcGradientColor()
                    {
                        if (values <= parent.lowValues)
                            return Qt.rgba(lowValuesColor.r, lowValuesColor.g - ((values - parent.lowValues) / (parent.minimumValue - parent.lowValues)), lowValuesColor.b);
                        else if (values >= parent.highValues)
                            return Qt.rgba(highValuesColor.r, (1 - ((values - parent.highValues) / (parent.maximumValue - parent.highValues))) * 0.5, highValuesColor.b);
                        else
                        {
                            var colorRatio = (values - parent.lowValues) / (parent.highValues - parent.lowValues);
                            return Qt.rgba(colorRatio, 1, (1 - colorRatio) * 0.5);
                        }
                    }

                    property color targetColor : getArcGradientColor();
                    Behavior on targetColor {ColorAnimation {duration: 750}}

                    onPaint:
                    {
                        var ctx = getContext("2d");
                        targetColor = getArcGradientColor();
                        ctx.reset();
                        ctx.beginPath();
                        ctx.lineWidth = 12;
                        ctx.strokeStyle = targetColor;
                        ctx.arc(ctx.canvas.width/2, ctx.canvas.height/2, ctx.canvas.width/2 - 18, parent.startAngle, parent.needleAngleRad);
                        ctx.stroke();
                    }
                }


                //Every time the number changes this is the animation to play in response.
                Behavior on value
                {
                    SpringAnimation {spring: 1.2; damping: 0.3;}
                }
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
            CircularGauge {
                id: speedometer
                width: parent.width*4/10
                height: parent.width*4/10

                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter

                anchors.bottomMargin: 5
                anchors.leftMargin: 1
                anchors.rightMargin: 1

                tickmarksVisible: true
                maximumValue: 80
                minimumValue: 0
                value: UIRaceDataset.groundSpeed | (parent.randVal * (maximumValue - minimumValue) + minimumValue)

                property real values: UIRaceDataset.groundSpeed | (parent.randVal * (maximumValue - minimumValue) + minimumValue)
                property real lowValues: 10
                property real highValues: 50
                property real range : maximumValue - minimumValue
                property real valuesRatio : (values - minimumValue) / range
                property real startAngle : Math.PI * 0.691
                property real endAngle : Math.PI * 2.310
                property real wholeAngle : endAngle - startAngle
                property real needleAngleRad : startAngle + valuesRatio * wholeAngle
                property real needleAngle : needleAngleRad  * 180 / Math.PI

                Behavior on needleAngleRad {SpringAnimation {spring: 1.2; damping: 0.3;}}
                onNeedleAngleRadChanged: speedometerValueGradient.requestPaint();

                style: NewDashboardGaugeStyle
                {
                    minValue: parent.minimumValue
                    maxValue: parent.maximumValue
                    lowValues: parent.lowValues
                    highValues: parent.highValues
                    label: "Vg: mph"
                    values: UIRaceDataset.groundSpeed | (parent.randVal * (maxValue - minValue) + minValue)
                }

                Canvas
                {
                    id: speedometerValueGradient
                    anchors.fill: parent
                    antialiasing: true

                    property real startAngle : Math.PI * 0.691
                    property real endAngle : Math.PI * 2.310
                    property color lowValuesColor: "#0066FF"
                    property color highValuesColor: "#cc0000"
                    property real values: parent.values

                    function getArcGradientColor()
                    {
                        if (values <= parent.lowValues)
                            return Qt.rgba(lowValuesColor.r, lowValuesColor.g - ((values - parent.lowValues) / (parent.minimumValue - parent.lowValues)), lowValuesColor.b);
                        else if (values >= parent.highValues)
                            return Qt.rgba(highValuesColor.r, (1 - ((values - parent.highValues) / (parent.maximumValue - parent.highValues))) * 0.5, highValuesColor.b);
                        else
                        {
                            var colorRatio = (values - parent.lowValues) / (parent.highValues - parent.lowValues);
                            return Qt.rgba(colorRatio, 1, (1 - colorRatio) * 0.5);
                        }
                    }

                    property color targetColor : getArcGradientColor();
                    Behavior on targetColor {ColorAnimation {duration: 750}}

                    onPaint:
                    {
                        var ctx = getContext("2d");
                        targetColor = getArcGradientColor();
                        ctx.reset();
                        ctx.beginPath();
                        ctx.lineWidth = 12;
                        ctx.strokeStyle = targetColor;
                        ctx.arc(ctx.canvas.width/2, ctx.canvas.height/2, ctx.canvas.width/2 - 18, parent.startAngle, parent.needleAngleRad);
                        ctx.stroke();
                    }
                }

                //Every time the number changes this is the animation to play in response.
                Behavior on value
                {
                    SpringAnimation {spring: 1.2; damping: 0.3;}
                }
            }

            /*
              The guage for the temperature of the engine.
            */
            CircularGauge {
                id: thermometer
                width: windometer.width
                height: windometer.height

                anchors.top: parent.top
                anchors.right: parent.right

                anchors.bottomMargin: 5
                anchors.leftMargin: 0
                anchors.rightMargin: 5

                tickmarksVisible: true
                maximumValue: 180
                minimumValue: 0
                value: UIRaceDataset.thermometer | (parent.randVal * (maximumValue - minimumValue) + minimumValue)

                property real values: UIRaceDataset.thermometer | (parent.randVal * (maximumValue - minimumValue) + minimumValue)
                property real lowValues: 30
                property real highValues: 150
                property real range : maximumValue - minimumValue
                property real valuesRatio : (values - minimumValue) / range
                property real startAngle : Math.PI * 0.691
                property real endAngle : Math.PI * 2.310
                property real wholeAngle : endAngle - startAngle
                property real needleAngleRad : startAngle + valuesRatio * wholeAngle
                property real needleAngle : needleAngleRad  * 180 / Math.PI

                Behavior on needleAngleRad {SpringAnimation {spring: 1.2; damping: 0.3;}}
                onNeedleAngleRadChanged: thermometerValueGradient.requestPaint();

                style: NewDashboardGaugeStyle
                {
                    minValue: parent.minimumValue
                    maxValue: parent.maximumValue
                    lowValues: parent.lowValues
                    highValues: parent.highValues
                    label: "T: °F"
                    tickmarkLabelVisible: false
                    values: UIRaceDataset.thermometer | (parent.randVal * (maxValue - minValue) + minValue)

                }

                Canvas
                {
                    id: thermometerValueGradient
                    anchors.fill: parent
                    antialiasing: true

                    property real startAngle : Math.PI * 0.691
                    property real endAngle : Math.PI * 2.310
                    property color lowValuesColor: "#0066FF"
                    property color highValuesColor: "#cc0000"
                    property real values: parent.values

                    function getArcGradientColor()
                    {
                        if (values <= parent.lowValues)
                            return Qt.rgba(lowValuesColor.r, lowValuesColor.g - ((values - parent.lowValues) / (parent.minimumValue - parent.lowValues)), lowValuesColor.b);
                        else if (values >= parent.highValues)
                            return Qt.rgba(highValuesColor.r, (1 - ((values - parent.highValues) / (parent.maximumValue - parent.highValues))) * 0.5, highValuesColor.b);
                        else
                        {
                            var colorRatio = (values - parent.lowValues) / (parent.highValues - parent.lowValues);
                            return Qt.rgba(colorRatio, 1, (1 - colorRatio) * 0.5);
                        }
                    }

                    property color targetColor : getArcGradientColor();
                    Behavior on targetColor {ColorAnimation {duration: 750}}

                    onPaint:
                    {
                        var ctx = getContext("2d");
                        targetColor = getArcGradientColor();
                        ctx.reset();
                        ctx.beginPath();
                        ctx.lineWidth = 12;
                        ctx.strokeStyle = targetColor;
                        ctx.arc(ctx.canvas.width/2, ctx.canvas.height/2, ctx.canvas.width/2 - 18, parent.startAngle, parent.needleAngleRad);
                        ctx.stroke();
                    }
                }

                //Every time the number changes this is the animation to play in response.
                Behavior on value
                {
                    SpringAnimation {spring: 1.2; damping: 0.3;}
                }
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
                    checkable: false

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
                    checkable: false

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
                    active: UIRaceDataSet.networkStatus

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
