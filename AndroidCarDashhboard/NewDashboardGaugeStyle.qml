import QtQuick 2.2
import QtQuick.Controls.Styles 1.4

// SAMPLE GAUGE
//        CircularGauge {
//            id: windometer
//            width: parent.width*3/10
//            height: parent.width*3/10

//            anchors.top: parent.top
//            anchors.left: parent.left

//            anchors.topMargin: 5
//            anchors.leftMargin: 5
//            anchors.rightMargin: 0

//            tickmarksVisible: true
//            maximumValue: 35
//            minimumValue: -35
//            value: UIRaceDataset.windSpeed | (parent.randVal * (maximumValue - minimumValue) + minimumValue)

//            property real values: UIRaceDataset.windSpeed | (parent.randVal * (maximumValue - minimumValue) + minimumValue)
//            property real lowValues: -20
//            property real highValues: 20
//            property real range : maximumValue - minimumValue
//            property real valuesRatio : (values - minimumValue) / range
//            property real startAngle : Math.PI * 0.691
//            property real endAngle : Math.PI * 2.310
//            property real wholeAngle : endAngle - startAngle
//            property real needleAngleRad : startAngle + valuesRatio * wholeAngle
//            property real needleAngle : needleAngleRad  * 180 / Math.PI

//            Behavior on needleAngleRad {SpringAnimation {spring: 1.2; damping: 0.3;}}
//            onNeedleAngleRadChanged: windometerValueGradient.requestPaint();

//            style: NewDashboardGaugeStyle
//            {
//                minValue: parent.minimumValue
//                maxValue: parent.maximumValue
//                lowValues: parent.lowValues
//                highValues: parent.highValues
//                label: "Ṽgw: mph"
//                values: UIRaceDataset.windSpeed | (parent.randVal * (maxValue - minValue) + minValue)
//            }

//            Canvas
//            {
//                id: windometerValueGradient
//                anchors.fill: parent
//                antialiasing: true

//                property real startAngle : Math.PI * 0.691
//                property real endAngle : Math.PI * 2.310
//                property color lowValuesColor: "#0066FF"
//                property color highValuesColor: "#cc0000"
//                property real values: parent.values

//                function getArcGradientColor()
//                {
//                    if (values <= parent.lowValues)
//                        return Qt.rgba(lowValuesColor.r, lowValuesColor.g - ((values - parent.lowValues) / (parent.minimumValue - parent.lowValues)), lowValuesColor.b);
//                    else if (values >= parent.highValues)
//                        return Qt.rgba(highValuesColor.r, (1 - ((values - parent.highValues) / (parent.maximumValue - parent.highValues))) * 0.5, highValuesColor.b);
//                    else
//                    {
//                        var colorRatio = (values - parent.lowValues) / (parent.highValues - parent.lowValues);
//                        return Qt.rgba(colorRatio, 1, (1 - colorRatio) * 0.5);
//                    }
//                }

//                property color targetColor : getArcGradientColor();
//                Behavior on targetColor {ColorAnimation {duration: 750}}

//                onPaint:
//                {
//                    var ctx = getContext("2d");
//                    targetColor = getArcGradientColor();
//                    ctx.reset();
//                    ctx.beginPath();
//                    ctx.lineWidth = 12;
//                    ctx.strokeStyle = targetColor;
//                    ctx.arc(ctx.canvas.width/2, ctx.canvas.height/2, ctx.canvas.width/2 - 18, parent.startAngle, parent.needleAngleRad);
//                    ctx.stroke();
//                }
//            }


//            //Every time the number changes this is the animation to play in response.
//            Behavior on value
//            {
//                SpringAnimation {spring: 1.2; damping: 0.3;}
//            }
//        }

CircularGaugeStyle {
    tickmarkInset: 38
    minorTickmarkInset: tickmarkInset
    labelStepSize: 5
    minimumValueAngle: -145
    maximumValueAngle: 145
    labelInset: toPixels(0.30)

    property real xCenter: outerRadius
    property real yCenter: outerRadius
    property real startAngle : Math.PI * 0.691;
    property real endAngle : Math.PI * 2.310;
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
        // BACKGROUND GRADIENT
//        var fillGradiant = ctx.createRadialGradient(xCenter, yCenter, 0.10 * (ctx.canvas.width/2),
//                                                    xCenter, yCenter, 0.75 * (ctx.canvas.width/2));
//        fillGradiant.addColorStop(0, outerCirclingColor);
//        fillGradiant.addColorStop(1, backgroundColor);

        // BACKGROUND CIRCLE
//        ctx.beginPath();
//        ctx.ellipse(0, 0, ctx.canvas.width, ctx.canvas.height);
//        ctx.fillStyle = fillGradiant;
//        //ctx.shadowBlur = 1;
//        //ctx.shadowColor = outerCirclingColor;
//        ctx.fill();

        // BORDER
//        ctx.beginPath();
//        ctx.lineWidth = 16;
//        ctx.strokeStyle = outerCirclingColor;
//        ctx.ellipse(14, 14, ctx.canvas.width - 28, ctx.canvas.width - 28);
//        ctx.stroke();

        // LOW VALUE ARC
        ctx.beginPath();
        ctx.lineWidth = 35;
        ctx.strokeStyle = lowValuesColor;
        ctx.arc(ctx.canvas.width/2, ctx.canvas.height/2, ctx.canvas.width/2 - 57, startAngle, startAngle + ((lowValues - minValue) / range) * (wholeAngle));
        ctx.stroke();

        // HIGH VALUE ARC
        ctx.beginPath();
        ctx.lineWidth = 35;
        ctx.strokeStyle = highValuesColor;
        ctx.arc(ctx.canvas.width/2, ctx.canvas.height/2, ctx.canvas.width/2 - 57, endAngle - (((range  - (highValues - minValue)) / range) * (wholeAngle)), endAngle);
        ctx.stroke();

        // BORDER WHITE CIRCLE
//        ctx.beginPath();
//        ctx.lineWidth = 8;
//        ctx.strokeStyle = innerCirclingColor;
//        ctx.ellipse(19, 19, ctx.canvas.width - 38, ctx.canvas.height - 38);
//        ctx.stroke();

        // OUTER CIRCLE ARC FOR VALUES
//        ctx.beginPath();
//        ctx.lineWidth = 7.5;
//        ctx.strokeStyle = innerCirclingColor;
//        ctx.ellipse(37, 37, ctx.canvas.width - 74, ctx.canvas.height - 74);
//        ctx.stroke();

        // INNER WHITE ARC FOR VALUES
        ctx.beginPath();
        ctx.lineWidth = 6;
        ctx.strokeStyle = innerCirclingColor;
        ctx.arc(ctx.canvas.width/2, ctx.canvas.height/2, ctx.canvas.width/2 - 75, startAngle, endAngle);
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
