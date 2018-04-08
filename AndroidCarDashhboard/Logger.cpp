#include "Logger.h"
#include <QDir>
#include <QFileInfo>
#include <assert.h>


Logger::Logger(QString logFileName, QObject *parent)
{
    logFile = new QFile(logFileName);
    logStream = new QTextStream(new QFile(logFileName));

    bool logFileOpened = openLogFile();
    // Using an assertion here until we decide on a way to handle exceptions

#ifndef Q_OS_WIN
    assert(logFileOpened);
#endif

}

Logger::Logger(string logFileName, QObject *parent) : QObject(parent)
{
    Logger(QString::fromStdString(logFileName), parent);
}

Logger::~Logger()
{
    logStream->flush();
    logStream->device()->close();
    delete logStream;
    delete logFile;
}

bool Logger::openLogFile()
{
    QFileInfo logFileInfo(*logFile);
    QDir logFileDir = logFileInfo.dir();
    logFileDir.mkpath(logFileDir.path());
    return logStream->device()->open(QIODevice::WriteOnly);
}

void Logger::closeLogFile()
{
    logStream->device()->close();
}

void Logger::println(string message)
{
    //Cast the c++ string to a QString as that has the best compatiblity with Qt file system.
    QString newEntry = QString::fromStdString(message + "\n");
    //Use the overloaded method for conviencence sake.
    println((QString)newEntry);
}

void Logger::println(QString message)
{
    /*log.append(message);

    if (logStream->device()->isOpen())
    {
        *logStream << message;
        // If we do not flush, the text will not get written to the file
        // unless and until the file is closed.
        logStream->flush();
    } else {
        // Using an assertion here until we decide on a way to handle exceptions
#ifndef Q_OS_WIN
        assert(false);
#endif
    }

    logNotify();*/
}

QString Logger::getLog()
{
    return log;
}
