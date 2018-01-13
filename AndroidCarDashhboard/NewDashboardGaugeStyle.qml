import QtQuick 2.2
import QtQuick.Controls.Styles 1.4

CircularGaugeStyle {
    property real startingAngle: -145
    property real endingAngle: 145
    property real stepSize: 5

    tickmarkInset: 10
    minorTickmarkInset: tickmarkInset
    tickmarkStepSize: stepSize
    labelStepSize: stepSize
    minimumValueAngle: startingAngle
    maximumValueAngle: endingAngle
    labelInset: toPixels(0.32)

    property bool reverseArc: false

    property real xCenter: outerRadius
    property real yCenter: outerRadius
    property real startAngle : Math.PI * (minimumValueAngle - 90) / 180;
    property real endAngle : Math.PI * (maximumValueAngle - 90) / 180;
    property real needleLength: outerRadius - tickmarkInset * 1.25
    property real needleTipWidth: toPixels(0.02)
    property real needleBaseWidth: toPixels(0.06)

    property real  valuesRatio : (values - minValue) / range
    property real  values: 0

    property color innerCirclingColor: "#ffffff"
    property color outerCirclingColor: "#cc0000"
    property color lowValuesColor : "#0066FF"
    property color highValuesColor : "#cc0000"
    property color backgroundColor: "#000000"

    property real minValue : 0
    property real maxValue : 0
    property real lowValues : 0
    property real highValues : 0
    property real range : maxValue - minValue
    property real wholeAngle : endAngle - startAngle
    property string label: ""
    property bool tickmarkLabelVisible: true

    function toPixels(percentage) {
        return percentage * outerRadius;
    }

    function degToRad(degrees) {
        return degrees * (Math.PI / 180);
    }

    function radToDeg(radians) {
        return radians * (180 / Math.PI);
    }

    tickmark: Rectangle {
        visible: true
        implicitWidth: 10
        antialiasing: true
        implicitHeight: 40
        color: "#ffffff"
    }

    minorTickmark: Rectangle {
        visible: true
        implicitWidth: 4
        antialiasing: true
        implicitHeight: 8
        color: "#ffffff"
    }

    tickmarkLabel:  Text {
            visible: tickmarkLabelVisible
            font.family: "Consolas"
            font.pixelSize: Math.max(6, outerRadius * 0.14)
            text: styleData.value
            color: "#ffffff"
            antialiasing: true
    }

    function paintBackground(ctx)
    {
        // LOW VALUE ARC
        ctx.beginPath();
        ctx.lineWidth = 35;
        ctx.strokeStyle = lowValuesColor;
        ctx.arc(ctx.canvas.width/2, ctx.canvas.height/2, parent.height/2 - 17.5, startAngle, startAngle + ((lowValues - minValue) / range) * (wholeAngle), reverseArc);
        ctx.stroke();

        // HIGH VALUE ARC
        ctx.beginPath();
        ctx.lineWidth = 35;
        ctx.strokeStyle = highValuesColor;
        ctx.arc(ctx.canvas.width/2, ctx.canvas.height/2, parent.height/2 - 17.5, endAngle - (((range  - (highValues - minValue)) / range) * (wholeAngle)), endAngle, reverseArc);
        ctx.stroke();

        // INNER WHITE ARC FOR VALUES
        ctx.beginPath();
        ctx.lineWidth = 6;
        ctx.strokeStyle = innerCirclingColor;
        ctx.arc(ctx.canvas.width/2, ctx.canvas.height/2, parent.height/2 - 3, startAngle, endAngle, reverseArc);
        ctx.stroke();
    }

    background: Canvas
    {
        onPaint:
        {
            var ctx = getContext("2d");
            paintBackground(ctx);
        }

        Text
        {
            id: speedText
            font.pixelSize: toPixels(0.3)
            text: kphInt
            color: "white"
            horizontalAlignment: Text.AlignRight
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.verticalCenter
            anchors.topMargin: toPixels(0.1)

            readonly property int kphInt: control.value
        }
        Text
        {
            text: label
            color: "white"
            font.pixelSize: toPixels(0.10)
            anchors.top: speedText.bottom
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }

    needle: Canvas
    {
        implicitWidth: needleBaseWidth
        implicitHeight: needleLength

        property real xCenter: width / 2
        property real yCenter: height / 2

            onPaint:
            {
            var ctx = getContext("2d");
            ctx.reset();

            ctx.beginPath();
            ctx.moveTo(xCenter, height);
            ctx.lineTo(xCenter - needleBaseWidth / 2, height - needleBaseWidth / 2);
            ctx.lineTo(xCenter - needleTipWidth / 2, 0);
            ctx.lineTo(xCenter, yCenter - needleLength);
            ctx.lineTo(xCenter, 0);
            ctx.closePath();
            ctx.fillStyle = Qt.rgba(0.9, 0.5, 0, 0.9);
            ctx.fill();

            ctx.beginPath();
            ctx.moveTo(xCenter, height)
            ctx.lineTo(width, height - needleBaseWidth / 2);
            ctx.lineTo(xCenter + needleTipWidth / 2, 0);
            ctx.lineTo(xCenter, 0);
            ctx.closePath();
            ctx.fillStyle = Qt.lighter(Qt.rgba(0.9, 0.5, 0, 0.9));
            ctx.fill();
        }

    }

    foreground: null
}
