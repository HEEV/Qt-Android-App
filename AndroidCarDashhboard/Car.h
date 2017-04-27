#ifndef CAR_H
#define CAR_H

class Car : public QObject
{
    Q_OBJECT
public:
    enum Name
    {
        Urbie,
        Sting
    };
    Q_ENUM(Name)
};


#endif // CAR_H
