#ifndef DATAPROCESSOR_H
#define DATAPROCESSOR_H

#include <QCanBusFrame>



class DataProcessor
{
public:
    DataProcessor();

    void routeCANFrame(QCanBusFrame frame);

    // Setters for values that come from CANInterface
    void updateGroundSpeed(QByteArray data);
    void updateAirSpeed(QByteArray data);
    void updateEFIPressure(QByteArray data);
    void updateMegasquirt(QByteArray data);
    void updateCurrent(QByteArray data);
    void updateVoltage(QByteArray data);

private:
    // CAN frame ids. These numbers have not been finalized or verified.
    static const int TACHOMETER_ID; // Used for ground speed
    static const int PITOT_ID; // Used for air speed
    static const int EFI_PRESSURE_ID; // Used for fuel injection info
    static const int MEGASQUIRT_ID; // Used for engine temperature and other info
    static const int CURRENT_ID;
    static const int VOLTAGE_ID;
};

#endif // DATAPROCESSOR_H
