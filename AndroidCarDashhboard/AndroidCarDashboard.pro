TEMPLATE = app

QT += qml quick serialport serialbus widgets core positioning network

#If we are compiling for android platform we should also compile with the androidextras library.
android {
    QT += androidextras
} else {
}

CONFIG += c++11

SOURCES += main.cpp \
    UIRaceDataset.cpp \
    CANInterface.cpp \
    DataProcessor.cpp \
    CanNodeParser.cpp \
    Logger.cpp \
    RaceActionManager.cpp \
    GPSPositioningService.cpp \
    NetworkInterface.cpp \
    BatteryStates.cpp \
    canBus.cpp \
    canSocket.cpp

RESOURCES += qml.qrc

include(./QMLLib/View.pri)

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

HEADERS += \
    UIRaceDataset.h \
    CANInterface.h \
    DataProcessor.h \
    CanNodeParser.h \
    Logger.h \
    RaceActionManager.h \
    GPSPositioningService.h \
    NetworkInterface.h \
    BatteryStates.h \

DISTFILES += \
    QMLLib/View.pri \
    Windometer.png \
    simulationData.csv
