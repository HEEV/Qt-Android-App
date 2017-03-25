#include <QGuiApplication>
#include <QQmlEngine>
#include <QQmlContext>
#include <QQmlComponent>
#include <UIRaceDataset.h>
#include <CANInterface.h>
#include <DataProcessor.h>
#include <QStandardPaths>
#include <QDateTime>
#include <Logger.h>

static const QString LOG_FILE_BASE_NAME = QString("SupermileageLogs/SMDashboardLog");
static const QString LOG_FILE_EXTENSION = QString(".txt");

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    QQmlEngine engine;
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

    engine.rootContext()->setContextProperty("UIRaceDataset", raceDataset);
    engine.rootContext()->setContextProperty("Logger", logger);

    QQmlComponent component(&engine, QUrl(QLatin1String("qrc:/main.qml")));
    component.create();

    const int returnval = app.exec();

    return returnval;
}
