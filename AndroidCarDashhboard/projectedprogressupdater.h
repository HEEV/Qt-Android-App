#ifndef PROJECTEDPROGRESSUPDATER_H
#define PROJECTEDPROGRESSUPDATER_H
#include <QTimer>

class ProjectedProgressUpdater
{
public:
    ProjectedProgressUpdater();
private:
    void updateProgress(int elapsedMilliseconds);
};

#endif // PROJECTEDPROGRESSUPDATER_H
