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
    maximumWidth: 1920
    maximumHeight: 1200
    minimumWidth: 1920
    minimumHeight: 1200

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
            id: rpmometerBackground
            source: "RPMometer.png"
            height: parent.height*.52;
            fillMode: Image.PreserveAspectFit
            anchors.verticalCenter: speedometerBackground.verticalCenter
            anchors.horizontalCenter: speedometerBackground.left
        }


        Image {
            id: windometerBackground
            source: "Windometer.png"
            height: parent.height*.52;
            fillMode: Image.PreserveAspectFit
            anchors.verticalCenter: speedometerBackground.bottom
            anchors.horizontalCenter: speedometerBackground.horizontalCenter
        }

        Image {
            id: speedometerBackground
            source: "Speedometer.png"
            height: parent.height*3/5;
            fillMode: Image.PreserveAspectFit
            anchors.right: parent.horizontalCenter
            anchors.rightMargin: -90
        }


        CircularGauge {
            id: rpmometer
            parent: rpmometerBackground
            width: rpmometerBackground.width
            height: rpmometerBackground.height
            anchors.verticalCenter: rpmometerBackground.verticalCenter;
            anchors.horizontalCenter: rpmometerBackground.horizontalCenter;

            anchors.bottomMargin: 5
            anchors.leftMargin: 1
            anchors.rightMargin: 1

            tickmarksVisible: true
            maximumValue: 750
            minimumValue: 0

            value: UIRaceDataset.groundSpeed //| (parent.randVal * (maximumValue - minimumValue) + minimumValue)

            property real values: UIRaceDataset.groundSpeed //| (parent.randVal * (maximumValue - minimumValue) + minimumValue)

//                Behavior on needleAngleRad {SpringAnimation {spring: 1.2; damping: 0.3;}}
//                onNeedleAngleRadChanged: speedometerValueGradient.requestPaint();

            style: NewDashboardGaugeStyle
            {
                startingAngle: 180
                endingAngle: 360
                stepSize: 150
                minValue: parent.minimumValue
                maxValue: parent.maximumValue
                lowValues: 150
                highValues: 600
                label: "rpm"
                values: UIRaceDataset.groundSpeed //| (parent.randVal * (maxValue - minValue) + minValue)
            }

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

        CircularGauge {
            id: windometer
            parent: windometerBackground
            width: windometerBackground.width
            height: windometerBackground.height
            anchors.verticalCenter: windometerBackground.verticalCenter;
            anchors.horizontalCenter: windometerBackground.horizontalCenter;

            anchors.bottomMargin: 5
            anchors.leftMargin: 1
            anchors.rightMargin: 1

            tickmarksVisible: true
            maximumValue: 35
            minimumValue: -35

            value: UIRaceDataset.groundSpeed //| (parent.randVal * (maximumValue - minimumValue) + minimumValue)

            property real values: UIRaceDataset.groundSpeed //| (parent.randVal * (maximumValue - minimumValue) + minimumValue)

//                Behavior on needleAngleRad {SpringAnimation {spring: 1.2; damping: 0.3;}}
//                onNeedleAngleRadChanged: speedometerValueGradient.requestPaint();

            style: NewDashboardGaugeStyle
            {
                startingAngle: 90
                endingAngle: 270
                minValue: parent.minimumValue
                maxValue: parent.maximumValue
                lowValues: 15
                highValues: -15
                label: "mph"
                values: UIRaceDataset.groundSpeed //| (parent.randVal * (maxValue - minValue) + minValue)
            }

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

        CircularGauge {
            id: speedometer
            parent: speedometerBackground
            width: speedometerBackground.width
            height: speedometerBackground.height
            anchors.verticalCenter: speedometerBackground.verticalCenter;
            anchors.horizontalCenter: speedometerBackground.horizontalCenter;

            anchors.bottomMargin: 5
            anchors.leftMargin: 1
            anchors.rightMargin: 1

            tickmarksVisible: true
            maximumValue: 40
            minimumValue: 0

            value: UIRaceDataset.groundSpeed //| (parent.randVal * (maximumValue - minimumValue) + minimumValue)

            property real values: UIRaceDataset.groundSpeed //| (parent.randVal * (maximumValue - minimumValue) + minimumValue)

//                Behavior on needleAngleRad {SpringAnimation {spring: 1.2; damping: 0.3;}}
//                onNeedleAngleRadChanged: speedometerValueGradient.requestPaint();

            style: NewDashboardGaugeStyle
            {
                minValue: parent.minimumValue
                maxValue: parent.maximumValue
                lowValues: 10
                highValues: 30
                label: "mph"
                values: UIRaceDataset.groundSpeed //| (parent.randVal * (maxValue - minValue) + minValue)
            }

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
