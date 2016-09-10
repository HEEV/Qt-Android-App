import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0

Item {
    id: item1
    property alias serverSwitch: serverSwitch

    Rectangle {
        id: rectangle1
        color: "#000000"
        z: -1
        anchors.fill: parent
    }

    ColumnLayout {
        id: columnLayout1
        x: 20
        y: 20
        spacing: 200
        anchors.rightMargin: 0
        anchors.bottomMargin: 0
        anchors.leftMargin: 0
        anchors.topMargin: 19
        anchors.fill: parent

        RowLayout {
            id: rowLayout2
            width: 246
            height: 100
            Layout.alignment: Qt.AlignLeft | Qt.AlignBottom
            Layout.columnSpan: 2
            Layout.rowSpan: 1
            Layout.fillHeight: false
            Layout.fillWidth: false
            anchors.horizontalCenterOffset: 0
            Switch {
                id: serverSwitch
                text: qsTr("")
                anchors.leftMargin: 0
                enabled: true
                antialiasing: true
                anchors.left: parent.left
            }

            Text {
                id: serverText
                color: "#ffffff"
                text: qsTr("Server")
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: 20
            }

            Image {
                id: serverConnectImage
                width: 100
                height: 100
                clip: false
                sourceSize.height: 50
                sourceSize.width: 50
                Layout.fillHeight: false
                Layout.fillWidth: false
                fillMode: Image.Stretch
                source: "../resources/images/x.png"
            }
            anchors.horizontalCenter: parent.horizontalCenter
        }

        RowLayout {
            id: rowLayout1
            width: 246
            height: 100
            Layout.columnSpan: 2
            Layout.rowSpan: 1
            Layout.alignment: Qt.AlignLeft | Qt.AlignBaseline
            Layout.fillWidth: false
            anchors.top: parent.top
            anchors.topMargin: 0
            anchors.horizontalCenter: parent.horizontalCenter

            Switch {
                id: usbSwitch
                text: qsTr("")
                topPadding: 4
                anchors.left: parent.left
                anchors.leftMargin: 0
                enabled: true
                antialiasing: true
            }

            Text {
                id: usbText
                color: "#ffffff"
                text: qsTr("USB")
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: 20
            }

            Image {
                id: usbConnectImage
                width: 100
                height: 100
                Layout.fillWidth: false
                source: "../resources/images/x.png"
                Layout.fillHeight: false
                sourceSize.width: 50
                sourceSize.height: 50
                fillMode: Image.Stretch
            }
        }

    }
}
