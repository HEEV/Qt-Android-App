QT += qml quick serialport
QT += androidextras
CONFIG += c++11

SOURCES += main.cpp

RESOURCES += qml.qrc

INCLUDEPATH += /usr/local/include/python3.5m

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

DISTFILES += \
    qml/DashboardGaugeStyle.qml \
    qml/IconGaugeStyle.qml \
    qml/TachometerStyle.qml \
    qml/TurnIndicator.qml \
    qml/ValueSource.qml \
    qml/ConnectionsForm.ui.qml \
    qml/DisplayForm.ui.qml \
    qml/Connections.qml \
    qml/Display.qml \
    android-sources/AndroidManifest.xml \
    android-sources/src/com/interface/usb/UsbJavaInterface.java

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android-sources

DISTFILES += android-sources/AndroidManifest.xml
OTHER_FILES += android-sources/src/com/interface/usb/UsbJavaInterface.java
