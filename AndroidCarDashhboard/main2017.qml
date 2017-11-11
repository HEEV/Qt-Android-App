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
    }

    Image {
        id: background
        source: "Guages.jpg"
        width: parent.width;
        height: parent.height;
        fillMode: Image.PreserveAspectFit
    }
}
