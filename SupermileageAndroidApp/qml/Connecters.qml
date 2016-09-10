import QtQuick 2.7

ConnectersForm {
    serverSwitch.onClicked: {
        console.log("Switch is clicked");
        //switchUIImage(this, "check");
    }
    /*function switchUIImage(caller,imageType) {
        if(caller.id == "serverSwitch")
        {
            serverImage.Image.switchImage(imageType);
        }
        else if(caller.id == "usbSwitch")
        {
            usbImage.Image.switchImage(imageType);
        }
    }*/
}
