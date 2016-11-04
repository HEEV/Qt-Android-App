#ifndef UIRACEDATASET_H
#define UIRACEDATASET_H

#include <QObject>

class UIRaceDataSet : public QObject
{
    Q_OBJECT
    Q_PROPERTY(qreal projectedProgress READ getProjectedProgress NOTIFY projectedProgressNotify)
public:
    explicit UIRaceDataSet(QObject *parent = 0);
    void setProjectedProgress(double projectedProgress);
    qreal getProjectedProgress();
private:
    qreal projectedProgress;
signals:
    void projectedProgressNotify();
public slots:
};

#endif // UIRACEDATASET_H
