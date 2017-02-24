#include "Logger.h"
#include <assert.h>

Logger::Logger(string logFileName, QObject *parent) : QObject(parent)
{
    logStream = new QTextStream(new QFile(QString::fromStdString(logFileName)));
    bool logFileOpened = openLogFile();
    // Using an assertion here until we decide on a way to handle exceptions
    assert(logFileOpened);
}

Logger::~Logger()
{
    logStream->flush();
    logStream->device()->close();
}

bool Logger::openLogFile()
{
   return logStream->device()->open(QIODevice::WriteOnly);
}

void Logger::closeLogFile()
{
    logStream->device()->close();
}

void Logger::println(string message)
{
    QString newEntry = QString::fromStdString(message + "\n");
    log.append(newEntry);

    if (logStream->device()->isOpen())
    {
        *logStream << newEntry;
        // If we do not flush, the text will not get written to the file
        // unless and until the file is closed.
        logStream->flush();
    } else {
        // Using an assertion here until we decide on a way to handle exceptions
        assert(false);
    }

    logNotify();
}

QString Logger::getLog()
{
    return log;
}
