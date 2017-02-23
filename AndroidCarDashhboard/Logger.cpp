#include "Logger.h"

Logger::Logger(string logFileName, QObject *parent) : QObject(parent)
{
    fileName = QString::fromStdString(logFileName);
    logStream = new QTextStream(&fileName);
}

void Logger::println(string message)
    {
    QString newEntry = QString::fromStdString(message + "\n");
    log.append(newEntry);
    *logStream << newEntry;

    logNotify();
}

QString Logger::getLog()
{
    return log;
}
