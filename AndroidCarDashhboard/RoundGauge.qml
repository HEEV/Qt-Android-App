import QtQuick 2.2

// Sample RoundGauge
//            RoundGauge
//            {
//                id: windometer
//                width: parent.width*3/10 - 5
//                height: parent.width*3/10
//                anchors.top: parent.top
//                anchors.left: parent.left

//                anchors.bottomMargin: 5
//                anchors.leftMargin: 5
//                anchors.rightMargin: 0

//                outerCirclingColor: "#ff2200"
//                textFont.family : "Consolas"
//                textFont.bold : true
//                textFont.italic : true
//                digitalFont.family : "Consolas"
//                digitalFont.bold : true
//                digitalFont.italic : true

//                unit: "Ṽgw: mph"
//                unitFont.pointSize: 12
//                unitFont.bold: true
//                unitFont.italic: true
//                unitFont.family: "Consolas"
//                fullCircle: true
//                subDivs: 13
//                minValue: -35
//                maxValue: 35
//                lowValues: -20
//                highValues: 20
//                currentValue: (parent.randVal *  (maxValue - minValue) + minValue) | UIRaceDataset.windSpeed;
//                digitalFont.pointSize: 15
//            }


Canvas
{
    id : gauge_canvas
    contextType: "2d"
    antialiasing: true;

    property real currentValue : 0;
    property real minValue : 0
    property real maxValue : 0;
    property real lowValues : 0;
    property real highValues : 0;
    property int subDivs : 0
    property font textFont : {family : "Helvetica";}

    property color lowValuesColor : "#0066FF";
    property color highValuesColor : "#cc0000";
    property color innerCirclingColor : "#FFFFFF";
    property color outerCirclingColor : "#0099FF";
    property color textColor : "#FFFFFF";
    property color graduationColor : "#FFFFFF";
    property color backgroundColor : "#000000";
    property bool  digitalEnable : true
    property alias digitalFont : digital_readout.font
    property alias unit : measure_unit.text
    property alias unitFont : measure_unit.font
    property bool  fullCircle : false
    property int   indicatorWidth : 10

    QtObject
    {
        id : d
        property real range : maxValue - minValue;
        property real startAngle : Math.PI * 0.75;
        property real endAngle : Math.PI * 2.25;
        property real radius : Math.min(width * 0.5, height * 0.5) - 10
        property point center : Qt.point(width * 0.5, height * 0.5)
        property real wholeAngle : endAngle - startAngle;
        property int animTimer;
        property real currentValueRatio : (currentValue - minValue) / d.range;
        property real needleAngleRad : d.startAngle + currentValueRatio * d.wholeAngle;
        property real needleAngle : needleAngleRad  * 180 / Math.PI;
        Behavior on needleAngleRad {SpringAnimation {spring: 1.5; damping: 0.5;}}
        onNeedleAngleRadChanged: value_timer.requestPaint();
    }

    // DRAWN ONCE
    onPaint:
    {
        // BORDER
        context.beginPath();

        // BLUE ARC
        if (fullCircle)
            context.arc(d.center.x, d.center.y, d.radius , 0 , 2 * Math.PI);
        else
            context.arc(d.center.x, d.center.y, d.radius , Math.PI * 0.6666 , 2.3333 * Math.PI);
        context.strokeStyle = outerCirclingColor;
        context.lineWidth = 10;
        context.stroke();

        // INNER ARC WITH GRADIENT
        var fillGradiant = context.createRadialGradient(d.center.x, d.center.y, 0.1 * d.radius,
                                                        d.center.x, d.center.y, 0.75 * d.radius);
        fillGradiant.addColorStop(0, outerCirclingColor);
        fillGradiant.addColorStop(1, backgroundColor);

        // GRADIENT CIRCLE
        context.beginPath();
        if (fullCircle)
            context.arc(d.center.x, d.center.y, d.radius - 0.001, 0 , 2 * Math.PI);
        else
            context.arc(d.center.x, d.center.y, d.radius - 0.001, Math.PI * 0.6666 , 2.3333 * Math.PI);
        context.fillStyle = fillGradiant;
        context.shadowBlur = 10;
        context.shadowColor = outerCirclingColor;
        context.fill();

        // OUTSIDE WHITE CIRCLE
        context.beginPath();
        context.lineWidth = 2;
        context.strokeStyle = innerCirclingColor;
        context.arc(d.center.x, d.center.y, d.radius - 2, d.startAngle, d.endAngle);
        context.stroke();

        // WHITE ARC FOR VALUES PT 1
        context.beginPath();
        context.lineWidth = 2;
        context.strokeStyle = innerCirclingColor;
        context.arc(d.center.x, d.center.y, d.radius - (5 + indicatorWidth), d.startAngle, d.endAngle);
        context.stroke();

        context.shadowBlur = 0;
        context.shadowColor = "transparent";

        // WHITE ARC FOR VALUE PT 2
        context.beginPath();
        //        context.lineWidth = 2;
        //        context.strokeStyle = innerCirclingColor;
        context.arc(d.center.x, d.center.y, d.radius - (15 + indicatorWidth), d.startAngle, d.endAngle);
        context.stroke();

        // LOW VALUE ARC
        context.beginPath();
        context.lineWidth = 8;
        context.strokeStyle = lowValuesColor;
        context.arc(d.center.x, d.center.y, d.radius - (10 + indicatorWidth), d.startAngle, d.startAngle + ((lowValues - minValue) / d.range) * (d.wholeAngle));
        context.stroke();

        // HIGH VALUE ARC
        context.beginPath();
        context.lineWidth = 8;
        context.strokeStyle = highValuesColor;
        context.arc(d.center.x, d.center.y, d.radius - (10 + indicatorWidth), d.endAngle - (((d.range  - (highValues - minValue)) / d.range) * (d.wholeAngle)), d.endAngle);
        context.stroke();

        context.strokeStyle = graduationColor;
        context.lineWidth = 10
        text_model.clear();
        var angleStep = (d.wholeAngle) / (subDivs + 1);
        for (var i = 0; i <= subDivs + 1; i++)
        {
            // TICK MARKS
            context.beginPath();
            var rotAngle  = (d.startAngle) + i * (angleStep);
            var offset = (subDivs % 2 !== 0) ? (i % 2 !== 0) ? 0.015 : 0.005 : 0.005
            context.arc(d.center.x, d.center.y, d.radius - (10 + indicatorWidth), rotAngle - ((i === 0) ? 0 : offset), rotAngle + ((i === subDivs + 1) ? 0 : offset));
            context.stroke();
            var textVal = (((i * angleStep / d.wholeAngle) * d.range * 100) / 100 + minValue).toFixed();
            text_model.append({"text" : textVal,
                                  "x" : d.center.x + ((d.radius - ((25 + indicatorWidth) + textFont.pixelSize * 0.5)) * Math.cos(rotAngle)),
                                  "y" : d.center.y + (d.radius - ((25 + indicatorWidth) + textFont.pixelSize * 0.5)) * Math.sin(rotAngle)});

        }
    }

    // VALUES
    Repeater
    {
        anchors.fill: parent
        model :  ListModel {id : text_model}
        delegate : Component {
            Text
            {
                color : textColor
                font : textFont
                x : model.x - 0.5 * width
                y : model.y - 0.5 * height
                text : model.text
                style : Text.Sunken
                styleColor: outerCirclingColor
            }
        }
    }

    // REDRAWN WHEN GAUGE VALUE CHANGES
    Canvas
    {
        id : value_timer
        anchors.fill: parent
        contextType: "2d"
        antialiasing: true;

        function getCadranColor()
        {
            if (currentValue <= lowValues)
                return Qt.rgba(lowValuesColor.r, lowValuesColor.g - ((currentValue - lowValues) / (minValue - lowValues)), lowValuesColor.b);
            else if (currentValue >= highValues)
                return Qt.rgba(highValuesColor.r, (1 - ((currentValue - highValues) / (maxValue - highValues))) * 0.5, highValuesColor.b);
            else
            {
                var colorRatio = (currentValue - lowValues) / (highValues - lowValues);
                return Qt.rgba(colorRatio, 1, (1 - colorRatio) * 0.5);
            }
        }

        property color targetColor : getCadranColor();
        Behavior on targetColor {ColorAnimation {duration: 750}}

        onPaint:
        {
            // VALUE GRADIENT ANIMATION
            context.reset();
            context.beginPath();
            context.lineWidth = indicatorWidth;
            context.strokeStyle = targetColor;
            context.arc(d.center.x, d.center.y, d.radius - 3.5 - indicatorWidth * 0.5, d.startAngle, d.needleAngleRad);
            context.stroke();
        }
    }

    Text
    {
        id : digital_readout
        visible : digitalEnable
        anchors
        {
            top : needle_holder.bottom
            topMargin : needle_holder.width * 0.3
            horizontalCenter : parent.horizontalCenter
        }
        text : Math.round(currentValue * 10) / 10;
        style : Text.Sunken
        styleColor: outerCirclingColor
        color : textColor
    }

    Text
    {
        id : measure_unit
        anchors
        {
            top : digital_readout.bottom
            topMargin : d.radius * 0.1
            horizontalCenter : parent.horizontalCenter
        }
        style : Text.Sunken
        styleColor: outerCirclingColor
        color : textColor
    }

    // NEEDLE HOLDER
    Rectangle
    {
        id : needle_holder
        width : d.radius * 0.4
        opacity : 0.8
        height: width
        radius: 180
        x : d.center.x - width * 0.5
        y : d.center.y - height * 0.5
        border
        {
            width : 1
            color : "#FFFFFF"
        }

        color : "#000000"
    }

    // NEEDLE
    Item
    {
        id : needle
        width : d.radius * 0.9
        height : needle_pic.height
        x : d.center.x
        y : d.center.y
        smooth : true

        Image
        {
            id : needle_pic
            source : "needle.png"
            fillMode: Image.PreserveAspectFit
            width : parent.width + needle_holder.width * 0.7
            x : -needle_holder.width *0.7
            smooth : true
        }

        transform : Rotation {
            angle : d.needleAngle
            axis { x : 0; y : 0; z : 1}
        }
    }

    Rectangle
    {
        width : d.radius * 0.1
        height : width
        radius : 180
        color : innerCirclingColor
        x : d.center.x - width * 0.5
        y : d.center.y - height * 0.5
        border
        {
            width : 1
            color : innerCirclingColor
        }
    }

}
