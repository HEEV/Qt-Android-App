#include "uiracedataset.h"

UIRaceDataSet::UIRaceDataSet(QObject *parent) : QObject(parent)
{

}

qreal UIRaceDataSet::getProjectedProgress()
{
    return projectedProgress;
}

void UIRaceDataSet::setProjectedProgress(double projectedProgress)
{
    this->projectedProgress = projectedProgress;
}
