TEMPLATE = app

QT += qml quick serialport serialbus widgets core positioning network multimedia


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
    AVMedia.cpp \
    androidCarDashFAQ.mm

RESOURCES += qml.qrc

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
    AVMedia.h
