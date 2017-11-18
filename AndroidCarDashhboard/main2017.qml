import QtQuick 2.5
import QtQuick.Window 2.2
import QtQuick.Controls 1.4
import QtQuick.Extras 1.4
import QtQuick.Layouts 1.3
import QtQuick.Controls.Styles 1.4

/*
  The main application window.

  TODO: make Rectangle to hold images & CircularGauge
*/
Window {
    id: applicationWindow
    visible: true
    //visibility: "FullScreen"
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
    }

    Rectangle {
        id: mainRectangle
        color: "black"
        width: parent.width
        height: parent.height


        Image {
            id: rpmometer
            source: "RPMometer.png"
            height: parent.height*.52;
            fillMode: Image.PreserveAspectFit
            anchors.verticalCenter: speedthingy.verticalCenter
            anchors.horizontalCenter: speedthingy.left
        }


        Image {
            id: windometer
            source: "Windometer.png"
            height: parent.height*.52;
            fillMode: Image.PreserveAspectFit
            anchors.verticalCenter: speedthingy.bottom
            anchors.horizontalCenter: speedthingy.horizontalCenter
        }

        Image {
            id: speedthingy
            source: "Speedometer.png"
            height: parent.height*3/5;
            fillMode: Image.PreserveAspectFit
            anchors.right: parent.horizontalCenter
        }


        CircularGauge {
            id: speedometer
            parent: speedthingy
            width: parent.height
            height: parent.height
            anchors.verticalCenter: parent.verticalCenter;



            //anchors.verticalCenter: parent.verticalCenter *.4
            //anchors.horizontalCenter: parent.horizontalCenter

            anchors.bottomMargin: 5
            anchors.leftMargin: 1
            anchors.rightMargin: 1

            tickmarksVisible: true
            maximumValue: 40
            minimumValue: 0

            property real lowValues: 10
            property real highValues: 30

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
                label: "mph"
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
    }
}
