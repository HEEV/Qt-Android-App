import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import QtQuick 2.2
import QtQuick.Window 2.1
import QtQuick.Controls 1.4
import QtQuick.Controls 2.0
import QtQuick.Controls.Styles 1.4
import QtQuick.Extras 1.4

Item {
    id: item1
    width: 1280
    height: 800

    Rectangle {
        id: rectangle1
        color: "#000000"
        z: -1
        anchors.fill: parent
    }

    ValueSource {
        id: valueSource
    }

    RowLayout {
        id: gaugeHolder
        anchors.fill: parent

        CircularGauge
        {
            id: speedometer
            width: 200
            height: 200
            value: valueSource.kph
            anchors.verticalCenter: parent.verticalCenter
            maximumValue: 280
            // We set the width to the height, because the height will always be
            // the more limited factor. Also, all circular controls letterbox
            // their contents to ensure that they remain circular. However, we
            // don't want to extra space on the left and right of our gauges,
            // because they're laid out horizontally, and that would create
            // large horizontal gaps between gauges on wide screens.
            anchors.horizontalCenter: parent.horizontalCenter

            style: DashboardGaugeStyle {}
        }
        /*CircularGauge
        {
            id: fuelGauge
            value: valueSource.fuel
            maximumValue: 1
            y: parent.height / 2 - height / 2 - container.height * 0.01
            width: parent.width
            height: parent.height * 0.7

            style: IconGaugeStyle
            {
                id: fuelGaugeStyle

                icon: "qrc:/images/fuel-icon.png"
                minWarningColor: Qt.rgba(0.5, 0, 0, 1)

                tickmarkLabel: Text
                {
                    color: "white"
                    visible: styleData.value === 0 || styleData.value === 1
                    font.pixelSize: fuelGaugeStyle.toPixels(0.225)
                    text: styleData.value === 0 ? "E" : (styleData.value === 1 ? "F" : "")
                }
            }
        }*/
    }

}
