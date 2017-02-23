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
    explicit Logger(string logFileName, QObject *parent = 0);
    QString getLog();
    void println(string message);
private:
    QString log;
    QString fileName;
    QTextStream *logStream;
signals:
    void logNotify();
public slots:
};

#endif // LOGGER_H
