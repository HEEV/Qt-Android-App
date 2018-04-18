#include <QString>
#ifndef BATTERYSTATES_H
#define BATTERYSTATES_H

class BatteryStates {
    public:
        static QString CRITICAL;
        static QString URGENT;
        static QString CAUTION;
        static QString GOOD;

        BatteryStates();
};

#endif // BATTERYSTATES_H
