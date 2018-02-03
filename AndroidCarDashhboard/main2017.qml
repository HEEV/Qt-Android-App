import QtQuick 2.5
import QtQuick.Window 2.2
import QtQuick.Controls 1.4
import QtQuick.Extras 1.4
import QtQuick.Layouts 1.3
import QtQuick.Controls.Styles 1.4
import QtLocation 5.6
import QtPositioning 5.6
import QtQuick.Particles 2.0

/*
  The main application window.

  TODO: make Rectangle to hold images & CircularGauge
*/

Window {
    property real scale: 1

    id: applicationWindow
    visible: true
    //visibility: "FullScreen"

    maximumWidth: 1920/scale
    maximumHeight: 1200/scale
    minimumWidth: 1920/scale
    minimumHeight: 1200/scale

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

        Rectangle {
            id:speedometerPositioner
            color: "black"
            x: 903.2/applicationWindow.scale
            y: 411.8/applicationWindow.scale
        }

        Rectangle {
            id:rpmPositioner
            color: "black"
            width: (speedometerBackground.width / 2) - 2
            height: parent.height
            anchors.right: speedometerPositioner.right
        }

        Rectangle {
            id:iconPositioner
            color: "black"
            x: 500/applicationWindow.scale
            y: 750/applicationWindow.scale
        }

        Button {
            id: menuBtn
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.margins: 50
            text: "MENU"
        }

        Image {
            id: windometerBackground
            source: "Windometer.png"
            height: parent.height * 0.52
            fillMode: Image.PreserveAspectFit
            anchors.horizontalCenter: speedometerPositioner.horizontalCenter
            anchors.verticalCenter: speedometerBackground.bottom
        }

        StatusIndicator
        {
            id: windometerCenter
            color: "#5e5e5e"
            anchors.verticalCenter: windometerBackground.verticalCenter
            anchors.horizontalCenter: windometerBackground.horizontalCenter
        }

        Image {
            id: rpmometerBackground
            source: "RPMometer.png"
            height: parent.height * 0.52
            fillMode: Image.PreserveAspectFit
            anchors.top:  speedometerBackground.top
            anchors.horizontalCenter: rpmPositioner.left
        }

        StatusIndicator
        {
            id: rpmometerCenter
            color: "#5e5e5e"
            anchors.verticalCenter: rpmometerBackground.verticalCenter
            anchors.horizontalCenter: rpmometerBackground.horizontalCenter
        }

        Image {
            id: speedometerBackground
            source: "Speedometer.png"
            height: parent.height * 0.6
            fillMode: Image.PreserveAspectFit
            anchors.horizontalCenter: speedometerPositioner.horizontalCenter
            anchors.horizontalCenterOffset: -1
            anchors.verticalCenter: speedometerPositioner.verticalCenter
        }

        StatusIndicator
        {
            id: speedometerCenter
            color: "#5e5e5e"
            anchors.verticalCenter: speedometerBackground.verticalCenter
            anchors.horizontalCenter: speedometerBackground.horizontalCenter
        }

        Image {
            id: batteryImage
            source: UIRaceDataset.batteryState
            height: parent.height * .07
            fillMode: Image.PreserveAspectFit
            anchors.horizontalCenter: iconPositioner.horizontalCenter
            anchors.verticalCenter: iconPositioner.verticalCenter
        }

        Image {
            id: engineImage
            source: "EngineBad.png"
            height: parent.height * .07
            fillMode: Image.PreserveAspectFit
            anchors.horizontalCenter: iconPositioner.horizontalCenter
            anchors.top: batteryImage.bottom
            anchors.topMargin: 25
        }


        CircularGauge {
            visible: false

            id: rpmometer
            parent: rpmometerBackground
            width: rpmometerBackground.width * 0.9
            height: rpmometerBackground.height * 0.9
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
                centerLabelVisible: false
                vertHalf: true
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
            visible: false

            id: windometer
            parent: windometerBackground
            width: windometerBackground.width * 0.9
            height: windometerBackground.height * 0.9
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
                centerLabelVisible: false
                startingAngle: 270
                endingAngle: 90
                reverseArc: true
                minValue: parent.minimumValue
                maxValue: parent.maximumValue
                stepSize: 10
                lowValues: -15
                highValues: 15
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
            visible: false

            id: speedometer
            parent: speedometerBackground
            width: speedometerBackground.width * 0.9
            height: speedometerBackground.height * 0.9
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


        // menu elements

        Rectangle {
            id:statusLights

            height: rpmometer.height / 2 - 100
            anchors.right: rpmometerBackground.horizontalCenter
            anchors.verticalCenter: rpmometerBackground.verticalCenter
            anchors.rightMargin: 200

            Rectangle {
                id: canStatus

                StatusIndicator
                {
                    id: canIndicator
                    color: "#5e5e5e"
                    active: UIRaceDataset.canStatus

                }

                Text {
                    text: "CAN"
                    font.bold: true
                    font.pointSize: 20
                    anchors.left: canIndicator.right
                    anchors.verticalCenter: canIndicator.verticalCenter
                    anchors.leftMargin: 10
                    color: "#FFFFFF"
                }
            }

            Rectangle {
                id: networkStatus
                anchors.top: canStatus.bottom
                anchors.topMargin: 75

                StatusIndicator
                {
                    id: networkIndicator
                    color: "#5e5e5e"
                    active: UIRaceDataset.networkStatus

                }

                Text {
                    text: "Network"
                    font.bold: true
                    font.pointSize: 20
                    anchors.left: networkIndicator.right
                    anchors.verticalCenter: networkIndicator.verticalCenter
                    anchors.leftMargin: 10
                    color: "#FFFFFF"
                }
            }

            Rectangle {
                id: efiStatus
                anchors.top: networkStatus.bottom
                anchors.topMargin: 75

                StatusIndicator
                {
                    id: efiIndicator
                    color: "#5e5e5e"
                    active: UIRaceDataset.networkStatus

                }

                Text {
                    text: "EFI"
                    font.bold: true
                    font.pointSize: 20
                    color: "#FFFFFF"
                    anchors.left: efiIndicator.right
                    anchors.verticalCenter: efiIndicator.verticalCenter
                    anchors.leftMargin: 10

                }
            }
        }



        Rectangle {
            id:checkBoxOptions

            height: gpsModeOption.height + unitsCheckBox.height
            anchors.right: speedometerBackground.horizontalCenter
            anchors.bottom: speedometerBackground.verticalCenter
            anchors.rightMargin: 200

            Rectangle {
                id: gpsModeOption
                height: gpsModeCheckBox.height

                CheckBox {
                    id: gpsModeCheckBox
                    style: CheckBoxStyle {
                        indicator: Rectangle {
                                        implicitWidth: 35
                                        implicitHeight: 35
                                        radius: 3
                                        border.width: 3
                                        Rectangle {
                                            visible: control.checked
                                            color: "#00ff54"
                                            border.color: "#000000"
                                            border.width: 1
                                            radius: 1
                                            anchors.margins: 2
                                            anchors.fill: parent

                                            Image {
                                                source: "check.png"
                                                fillMode: Image.PreserveAspectFit
                                                height: parent.height
                                                width: parent.width
                                            }
                                        }
                                }
                    }

                }

                Text {
                    text: "Use GPS for Speed"
                    font.bold: true
                    font.pointSize: 20
                    color: "#FFFFFF"
                    anchors.left: gpsModeCheckBox.right
                    anchors.verticalCenter: gpsModeCheckBox.verticalCenter
                    anchors.leftMargin: 10

                }
            }


            Rectangle {
                id: unitsOption

                anchors.top: gpsModeOption.bottom
                anchors.topMargin: 25

                CheckBox {
                    id: unitsCheckBox
                    style: CheckBoxStyle {
                        indicator: Rectangle {
                                        implicitWidth: 35
                                        implicitHeight: 35
                                        radius: 3
                                        border.width: 3
                                        Rectangle {
                                            visible: control.checked
                                            color: "#00ff54"
                                            border.color: "#000000"
                                            border.width: 1
                                            radius: 1
                                            anchors.margins: 2
                                            anchors.fill: parent

                                            Image {
                                                source: "check.png"
                                                fillMode: Image.PreserveAspectFit
                                                height: parent.height
                                                width: parent.width
                                            }
                                        }
                                }
                    }

                }

                Text {
                    text: "Kilometer per Hour"
                    font.bold: true
                    font.pointSize: 20
                    color: "#FFFFFF"
                    anchors.left: unitsCheckBox.right
                    anchors.verticalCenter: unitsCheckBox.verticalCenter
                    anchors.leftMargin: 10

                }
            }
        }

        Button {
            id:startRaceBtn
            text: "Start"
            anchors.horizontalCenter: speedometerBackground.horizontalCenter
            y: 150

            style: ButtonStyle {
                background: EllipseShape {

                       }
            }
        }

        //end menu

        Rectangle {
            id: mapRectangle
            height: parent.height
            width: parent.width - speedometer.width - rpmometer.width -batteryImage.width
            anchors.right: parent.right

            Plugin {
                id: mapPlugin
                name: "osm" // "mapboxgl", "esri", ...
                // specify plugin parameters if necessary
                PluginParameter {
                     name: "osm.mapping.host"
                     value: "http://163.11.136.233"
                  }
            }

            Map {
                anchors.fill: parent
                bearing: -45
                plugin: mapPlugin
                center: QtPositioning.coordinate(38.161724, -122.456705) // Sonoma
                zoomLevel: 16.5
                gesture.enabled: false
            }
        }
    }
}
