#ifndef LOGGER_H
#define LOGGER_H

#include <QObject>
#include <QFile>
#include <QTextStream>
#include <string>

using namespace std;

class Logger : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString log READ getLog NOTIFY logNotify)
public:
    explicit Logger(QString logFileName, QObject *parent = 0);
    explicit Logger(string logFileName, QObject *parent = 0);
    ~Logger();

    QString getLog();
    void println(string message);
    void println(QString message);

    bool openLogFile();
    void closeLogFile();
private:
    QString log;
    QFile *logFile;
    QTextStream *logStream;
signals:
    void logNotify();
public slots:
};

#endif // LOGGER_H
