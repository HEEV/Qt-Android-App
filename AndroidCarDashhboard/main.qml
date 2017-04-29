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
            duration: 200
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

//            property real randVal : 0;

//            /*
//              Desktop animations for gauges.
//            */
//            Keys.onSpacePressed:
//            {
//                randVal = Math.random();
//            }

//            Keys.onUpPressed:
//            {
//                randVal = 1;
//            }

//            Keys.onDownPressed:
//            {
//                randVal = 0;
//            }

//            Keys.onVolumeUpPressed:
//            {
//                randVal = 1;
//            }

//            Keys.onVolumeDownPressed:
//            {
//                randVal = 0;
//            }

//            Button
//            {
//                id: getMinValue
//                text: qsTr("")
//                visible: true

//                anchors.horizontalCenter: windometer.horizontalCenter
//                anchors.verticalCenter: windometer.verticalCenter

//                onClicked:
//                {
//                    parent.randVal = 0;
//                }
//            }

//            /*
//              The a gauge for the relative velocity of the wind to the car.
//            */
//            CircularGauge {
//                id: windometer
//                width: parent.width*3/10
//                height: parent.width*3/10

//                anchors.top: parent.top
//                anchors.left: parent.left

//                anchors.topMargin: 5
//                anchors.leftMargin: 5
//                anchors.rightMargin: 0

//                tickmarksVisible: true
//                maximumValue: 35
//                minimumValue: -35
//                value: 0//UIRaceDataset.windSpeed //| (parent.randVal * (maximumValue - minimumValue) + minimumValue)

//                property real values: 0//UIRaceDataset.windSpeed //| (parent.randVal * (maximumValue - minimumValue) + minimumValue)
//                property real lowValues: -20
//                property real highValues: 20
//                property real range : maximumValue - minimumValue
//                property real valuesRatio : (values - minimumValue) / range
//                property real startAngle : Math.PI * 0.691
//                property real endAngle : Math.PI * 2.310
//                property real wholeAngle : endAngle - startAngle
//                property real needleAngleRad : startAngle + valuesRatio * wholeAngle
//                property real needleAngle : needleAngleRad  * 180 / Math.PI

//                Behavior on needleAngleRad {SpringAnimation {spring: 1.2; damping: 0.3;}}
//                onNeedleAngleRadChanged: windometerValueGradient.requestPaint();

//                style: NewDashboardGaugeStyle
//                {
//                    minValue: parent.minimumValue
//                    maxValue: parent.maximumValue
//                    lowValues: parent.lowValues
//                    highValues: parent.highValues
//                    label: "Ṽgw: mph"
//                    values: 0//UIRaceDataset.windSpeed //| (parent.randVal * (maxValue - minValue) + minValue)
//                    outerCirclingColor: "#FF3D1F"
//                }

//                Canvas
//                {
//                    id: windometerValueGradient
//                    anchors.fill: parent
//                    antialiasing: true

//                    property real startAngle : Math.PI * 0.691
//                    property real endAngle : Math.PI * 2.310
//                    property color lowValuesColor: "#0066FF"
//                    property color highValuesColor: "#cc0000"
//                    property real values: parent.values

//                    function getArcGradientColor()
//                    {
//                        if (values <= parent.lowValues)
//                            return Qt.rgba(lowValuesColor.r, lowValuesColor.g - ((values - parent.lowValues) / (parent.minimumValue - parent.lowValues)), lowValuesColor.b);
//                        else if (values >= parent.highValues)
//                            return Qt.rgba(highValuesColor.r, (1 - ((values - parent.highValues) / (parent.maximumValue - parent.highValues))) * 0.5, highValuesColor.b);
//                        else
//                        {
//                            var colorRatio = (values - parent.lowValues) / (parent.highValues - parent.lowValues);
//                            return Qt.rgba(colorRatio, 1, (1 - colorRatio) * 0.5);
//                        }
//                    }

//                    property color targetColor : getArcGradientColor();
//                    Behavior on targetColor {ColorAnimation {duration: 750}}

//                    onPaint:
//                    {
//                        var ctx = getContext("2d");
//                        targetColor = getArcGradientColor();
//                        ctx.reset();
//                        ctx.beginPath();
//                        ctx.lineWidth = 18.5;
//                        ctx.strokeStyle = targetColor;
//                        ctx.arc(ctx.canvas.width/2, ctx.canvas.height/2, ctx.canvas.width/2 - 24, parent.startAngle, parent.needleAngleRad);
//                        ctx.stroke();
//                    }
//                }

//                //Every time the number changes this is the animation to play in response.
//                Behavior on value
//                {
//                    SpringAnimation {spring: 1.2; damping: 0.3;}
//                }
//            }

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
                anchors.left: parent.left

                anchors.bottomMargin: 5
                anchors.leftMargin: 5

                Text
                {
                    id: lap
                    color: "#ffffff"
                    text: qsTr("Lap")
                    fontSizeMode: Text.Fit
                    horizontalAlignment: Text.AlignHCenter
                    font.pointSize: 45
                    font.family: "Consolas"
                    font.bold: true

                    anchors.bottom: lapNumber.top
                    anchors.left: parent.left

                    anchors.leftMargin: 5
                }

                Text
                {
                    id: lapNumber
                    color: "#ffffff"
                    text: UIRaceDataset.currentLapNumber
                    fontSizeMode: Text.Fit
                    horizontalAlignment: Text.AlignHCenter
                    font.pointSize: 45
                    font.family: "Consolas"
                    font.bold: true

                    anchors.bottom: averageSpeed.top
                    anchors.horizontalCenter: lap.horizontalCenter
                }

                Text
                {
                    id: averageSpeed
                    color: "#ffffff"
                    text: qsTr("Avg. V: " + UIRaceDataset.averageSpeed)
                    font.pointSize: 45
                    fontSizeMode: Text.Fit
                    font.family: "Consolas"
                    font.bold: true

                    anchors.bottom: parent.bottom
                    anchors.left: parent.left

                    anchors.bottomMargin: 5
                    anchors.leftMargin: 5
                }
            }

            /*
              Another rectangle to align a second collection of race statistics.
            */
            Rectangle
            {
                id: raceStatistics2
                color: "#000000"
                width: totalTime.width
                height: totalTime.height

                anchors.top: parent.top
                anchors.left: parent.left

                anchors.topMargin: 5
                anchors.leftMargin: 5

                Text
                {
                    id: totalTime
                    color: "#ffffff"
                    font.pointSize: 45
                    fontSizeMode: Text.Fit
                    horizontalAlignment: Text.AlignRight
                    text: qsTr("Total Time: " + UIRaceDataset.totalTime)
                    font.family: "Consolas"
                    font.bold: true

                    anchors.top: parent.top
                    anchors.left: parent.left
                }
            }

            /*
              Another rectangle to align a second collection of race statistics.
            */
            Rectangle
            {
                id: raceStatistics3
                color: "#000000"
                width: lapTime.width
                height: lapTime.height + lastLapTime.height

                anchors.top: parent.top
                anchors.right: parent.right

                anchors.topMargin: 5
                anchors.rightMargin: 5

                Text
                {
                    id: lapTime
                    color: "#ffffff"
                    font.pointSize: 45
                    fontSizeMode: Text.Fit
                    horizontalAlignment: Text.AlignRight
                    text: qsTr("Current Lap: " + UIRaceDataset.currentLapTime)
                    font.family: "Consolas"
                    font.bold: true

                    anchors.top: parent.top
                    anchors.right: parent.right
                }

                Text
                {
                    id: lastLapTime
                    color: "#ffffff"
                    font.pointSize: 45
                    fontSizeMode: Text.Fit
                    horizontalAlignment: Text.AlignRight
                    text: qsTr("Last Lap: " + UIRaceDataset.lastLapTime)
                    font.family: "Consolas"
                    font.bold: true

                    anchors.top: lapTime.bottom
                    anchors.right: lapTime.right
                }
            }

//            Button
//            {
//                id: getRandomValue
//                text: qsTr("")
//                visible: true

//                anchors.horizontalCenter: speedometer.horizontalCenter
//                anchors.verticalCenter: speedometer.verticalCenter

//                onClicked:
//                {
//                    parent.randVal = Math.random();
//                }
//            }

            /*
              The gauge for the velocity of the car.
            */
            CircularGauge {
                id: speedometer
                width: parent.width*5/10
                height: parent.width*5/10

                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter

                anchors.bottomMargin: 5
                anchors.leftMargin: 1
                anchors.rightMargin: 1

                tickmarksVisible: true
                maximumValue: 60
                minimumValue: 0

                property real lowValues: 10
                property real highValues: 40

                value: UIRaceDataset.groundSpeed //| (parent.randVal * (maximumValue - minimumValue) + minimumValue)

                property real values: UIRaceDataset.groundSpeed //| (parent.randVal * (maximumValue - minimumValue) + minimumValue)

//                property real range : maximumValue - minimumValue
//                property real valuesRatio : (values - minimumValue) / range
//                property real startAngle : Math.PI * 0.691
//                property real endAngle : Math.PI * 2.310
//                property real wholeAngle : endAngle - startAngle
//                property real needleAngleRad : startAngle + valuesRatio * wholeAngle
//                property real needleAngle : needleAngleRad  * 180 / Math.PI

//                Behavior on needleAngleRad {SpringAnimation {spring: 1.2; damping: 0.3;}}
//                onNeedleAngleRadChanged: speedometerValueGradient.requestPaint();

                style: NewDashboardGaugeStyle
                {
                    minValue: parent.minimumValue
                    maxValue: parent.maximumValue
                    lowValues: parent.lowValues
                    highValues: parent.highValues
                    label: "Vg: mph"
                    values: UIRaceDataset.groundSpeed //| (parent.randVal * (maxValue - minValue) + minValue)
                }

//                Canvas
//                {
//                    id: speedometerValueGradient
//                    anchors.fill: parent
//                    antialiasing: true

//                    property real startAngle : Math.PI * 0.691
//                    property real endAngle : Math.PI * 2.310
//                    property color lowValuesColor: "#0066FF"
//                    property color highValuesColor: "#cc0000"
//                    property real values: parent.values

//                    function getArcGradientColor()
//                    {
//                        if (values <= parent.lowValues)
//                            return Qt.rgba(lowValuesColor.r, lowValuesColor.g - ((values - parent.lowValues) / (parent.minimumValue - parent.lowValues)), lowValuesColor.b);
//                        else if (values >= parent.highValues)
//                            return Qt.rgba(highValuesColor.r, (1 - ((values - parent.highValues) / (parent.maximumValue - parent.highValues))) * 0.5, highValuesColor.b);
//                        else
//                        {
//                            var colorRatio = (values - parent.lowValues) / (parent.highValues - parent.lowValues);
//                            return Qt.rgba(colorRatio, 1, (1 - colorRatio) * 0.5);
//                        }
//                    }

//                    property color targetColor : getArcGradientColor();
//                    Behavior on targetColor
//                    {
//                        ColorAnimation
//                        {
//                            duration: 300
//                            easing.type: Easing.InOutSine
//                        }
//                    }

//                    onPaint:
//                    {
//                        var ctx = getContext("2d");
//                        targetColor = getArcGradientColor();
//                        ctx.reset();
//                        ctx.beginPath();
//                        ctx.lineWidth = 18.5;
//                        ctx.strokeStyle = targetColor;
//                        ctx.arc(ctx.canvas.width/2, ctx.canvas.height/2, ctx.canvas.width/2 - 24, parent.startAngle, parent.needleAngleRad);
//                        ctx.stroke();
//                    }
//                }

                //Every time the number changes this is the animation to play in response.
                Behavior on value
                {
                    NumberAnimation
                    {
                        //How long the animation should take in milliseconds
                        duration: 300
                        //The style of animation to be played.
                        easing.type: Easing.InOutSine
                    }
                }
            }

//            Button
//            {
//                id: getMaxValue
//                text: qsTr("")
//                visible: true

//                anchors.horizontalCenter: thermometer.horizontalCenter
//                anchors.verticalCenter: thermometer.verticalCenter

//                onClicked:
//                {
//                    parent.randVal = 1;
//                }
//            }

//            /*
//              The guage for the temperature of the engine.
//            */
//            CircularGauge {
//                id: thermometer
//                width: windometer.width
//                height: windometer.height

//                anchors.top: parent.top
//                anchors.right: parent.right

//                anchors.bottomMargin: 5
//                anchors.leftMargin: 0
//                anchors.rightMargin: 5

//                tickmarksVisible: true
//                maximumValue: 180
//                minimumValue: 0
//                value: 0//UIRaceDataset.thermometer //| (parent.randVal * (maximumValue - minimumValue) + minimumValue)

//                property real values: 0//UIRaceDataset.thermometer //| (parent.randVal * (maximumValue - minimumValue) + minimumValue)
//                property real lowValues: 30
//                property real highValues: 150
//                property real range : maximumValue - minimumValue
//                property real valuesRatio : (values - minimumValue) / range
//                property real startAngle : Math.PI * 0.691
//                property real endAngle : Math.PI * 2.310
//                property real wholeAngle : endAngle - startAngle
//                property real needleAngleRad : startAngle + valuesRatio * wholeAngle
//                property real needleAngle : needleAngleRad  * 180 / Math.PI

//                Behavior on needleAngleRad {SpringAnimation {spring: 1.2; damping: 0.3;}}
//                onNeedleAngleRadChanged: thermometerValueGradient.requestPaint();

//                style: NewDashboardGaugeStyle
//                {
//                    minValue: parent.minimumValue
//                    maxValue: parent.maximumValue
//                    lowValues: parent.lowValues
//                    highValues: parent.highValues
//                    label: "T: °F"
//                    tickmarkLabelVisible: false
//                    values: 0//UIRaceDataset.thermometer //| (parent.randVal * (maxValue - minValue) + minValue)
//                    outerCirclingColor: "#FF3D1F"
//                }

//                Canvas
//                {
//                    id: thermometerValueGradient
//                    anchors.fill: parent
//                    antialiasing: true

//                    property real startAngle : Math.PI * 0.691
//                    property real endAngle : Math.PI * 2.310
//                    property color lowValuesColor: "#0066FF"
//                    property color highValuesColor: "#cc0000"
//                    property real values: parent.values

//                    function getArcGradientColor()
//                    {
//                        if (values <= parent.lowValues)
//                            return Qt.rgba(lowValuesColor.r, lowValuesColor.g - ((values - parent.lowValues) / (parent.minimumValue - parent.lowValues)), lowValuesColor.b);
//                        else if (values >= parent.highValues)
//                            return Qt.rgba(highValuesColor.r, (1 - ((values - parent.highValues) / (parent.maximumValue - parent.highValues))) * 0.5, highValuesColor.b);
//                        else
//                        {
//                            var colorRatio = (values - parent.lowValues) / (parent.highValues - parent.lowValues);
//                            return Qt.rgba(colorRatio, 1, (1 - colorRatio) * 0.5);
//                        }
//                    }

//                    property color targetColor : getArcGradientColor();
//                    Behavior on targetColor {ColorAnimation {duration: 750}}

//                    onPaint:
//                    {
//                        var ctx = getContext("2d");
//                        targetColor = getArcGradientColor();
//                        ctx.reset();
//                        ctx.beginPath();
//                        ctx.lineWidth = 18.5;
//                        ctx.strokeStyle = targetColor;
//                        ctx.arc(ctx.canvas.width/2, ctx.canvas.height/2, ctx.canvas.width/2 - 24, parent.startAngle, parent.needleAngleRad);
//                        ctx.stroke();
//                    }
//                }

//                //Every time the number changes this is the animation to play in response.
//                Behavior on value
//                {
//                    SpringAnimation {spring: 1.2; damping: 0.3;}
//                }
//            }

            /*
              A rectangle to align a collection of device statistics.
            */
            Rectangle {
                id: deviceStatus
                color: "#000000"
                width: batteryLevel.width
                height: batteryLevel.height

                anchors.bottom: parent.bottom
                anchors.right: parent.right

                anchors.bottomMargin: 5
                anchors.rightMargin: 5

                Text
                {
                    id: batteryLevel
                    color: "#ffffff"
                    font.pointSize: 45
                    fontSizeMode: Text.Fit
                    horizontalAlignment: Text.AlignRight
                    text: qsTr("Battery: " + "100" + "%")
                    font.family: "Consolas"
                    font.bold: true

                    anchors.bottom: parent.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
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
                        urbie.enabled = false;
                        sting.enabled = false;
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
                        urbie.enabled = true;
                        sting.enabled = true;
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

                Rectangle
                {
                    id: carSelection
                    width: carSelectionGroupBox.width
                    height: carSelectionGroupBox.height
                    color: "#ffffff"

                    anchors.left: raceActiveIndicator.right
                    anchors.verticalCenter: parent.verticalCenter

                    anchors.leftMargin: parent.width/4 - (startRaceButton.width*2)

                    GroupBox
                    {
                        id: carSelectionGroupBox
                        title: "Car Selection:"

                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter

                        RowLayout
                        {
                            ExclusiveGroup {id: carSeletionGroup }

                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter

                            anchors.leftMargin: 5
                            anchors.rightMargin: 5

                            RadioButton
                            {
                                id: urbie
                                text: "Urbie"
                                checked: true
                                exclusiveGroup: carSeletionGroup
                                onClicked:
                                {
                                    UIRaceDataset.carName = "Urbie";
                                }
                            }
                            RadioButton
                            {
                                id: sting
                                text: "Sting"
                                exclusiveGroup: carSeletionGroup
                                onClicked:
                                {
                                    UIRaceDataset.carName = "Sting";
                                }
                            }
                        }
                    }
                }

                Rectangle
                {
                    id: gpsSpeedToggleBackground
                    width: gpsSpeedToggle.width + 10
                    height: gpsSpeedToggle.height + 10

                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter

                    anchors.leftMargin: parent.width/5

                    Text
                    {
                        id: gpsSpeedToggleLabel
                        color: "#ffffff"
                        text: qsTr("Use GPS for Speed")

                        anchors.bottom: gpsSpeedToggle.top
                        anchors.left: gpsSpeedToggle.left

                        anchors.bottomMargin: 5

                    }

                    Switch
                    {
                        id: gpsSpeedToggle

                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter

                        onClicked:
                        {
                            UIRaceDataset.useGPSSpeed = gpsSpeedToggle.checked;
                        }

                    }
                }

                Label
                {
                    id: canStatusLabel
                    color: "#ffffff"
                    text: qsTr("Can Status")

                    anchors.bottom: canStatusIndicator.top
                    anchors.left: parent.horizontalCenter

                    anchors.topMargin: 5
                    anchors.bottomMargin: 5
                    anchors.leftMargin: parent.width/4 - canStatusLabel.width/2
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
