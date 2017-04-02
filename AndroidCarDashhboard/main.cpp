//QT includes.
#include <QGuiApplication>
#include <QtAndroidExtras/QtAndroidExtras>
#include <QQmlEngine>
#include <QQmlContext>
#include <QQmlComponent>
#include <QStandardPaths>
#include <QDateTime>

//Local Includes
#include <UIRaceDataset.h>
#include <CANInterface.h>
#include <DataProcessor.h>
#include <Logger.h>
#include <RaceActionManager.h>
#include <GPSPositioningService.h>

static const QString LOG_FILE_BASE_NAME = QString("SupermileageLogs/SMDashboardLog");
static const QString LOG_FILE_EXTENSION = QString(".txt");

void performJNIOperations();

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    QQmlEngine engine;

    //Get the screen to stay on hopefuly
    performJNIOperations();

    UIRaceDataset *raceDataset = new UIRaceDataset();
    // Placeholder temporary remove this later this is terrible blah blah blah
    raceDataset->setProjectedProgress(0.95);
    raceDataset->setGroundSpeed(38.0);

    // Set up logging
    QString logFilePath = QStandardPaths::writableLocation(QStandardPaths::DocumentsLocation)
            + "/" + LOG_FILE_BASE_NAME + "_" + (QDateTime::currentDateTime().toString(Qt::TextDate))
            + LOG_FILE_EXTENSION;
    Logger *logger = new Logger(logFilePath);
    logger->println("Begin logging test.");
    logger->println("This is a line of text");
    logger->println("This is another line of text");

    //Make a DataProcessor.
    DataProcessor *dataProcessor = new DataProcessor(raceDataset, 69.115 /*this number is just a guess*/, logger);

    //Make a instance of CANInterface.
    CANInterface *interface = new CANInterface(dataProcessor);

    //Make a GPS Service
    GPSPositioningService *gps = new GPSPositioningService(logger);

    //Set up the RaceActionManager to take care of the race progress
    RaceActionManager *manager = new RaceActionManager(interface, dataProcessor, logger, raceDataset, gps);



    //Make the UIRaceDataset, Logger and RaceActionManager accessable to the QML segment of the code.
    engine.rootContext()->setContextProperty("UIRaceDataset", raceDataset);
    engine.rootContext()->setContextProperty("Logger", logger);
    engine.rootContext()->setContextProperty("RaceActionManager", manager);

    QQmlComponent component(&engine, QUrl(QLatin1String("qrc:/main.qml")));
    component.create();

    const int returnval = app.exec();

    return returnval;
}





void performJNIOperations()
{
    QAndroidJniObject activity = QtAndroid::androidActivity();
    if (activity.isValid())
    {
        QAndroidJniObject window = activity.callObjectMethod("getWindow", "()Landroid/view/Window;");

        if (window.isValid())
        {
            const int FLAG_KEEP_SCREEN_ON = 128;
            window.callMethod<void>("addFlags", "(I)V", FLAG_KEEP_SCREEN_ON);
        }
        QAndroidJniEnvironment env; if (env->ExceptionCheck()) { env->ExceptionClear(); } //Clear any possible pending exceptions.
    }
}

