#include "DataProcessor.h"

DataProcessor::DataProcessor()
{

}

DataProcessor::routeCANFrame(QCanBusFrame frame)
{
    int id = frame.frameId();
    QByteArray data = frame.payload();

    // For efficienty, these cases should be ordered with the most
    // frequent ids at the top.
    switch(id)
    {
    case TACHOMETER_ID:
        updateGroundSpeed(data);
        break;
    case PITOT_ID:
        updateAirSpeed(data);
        break;
    case EFI_PRESSURE_ID:
        updateEFIPressure(data);
        break;
    case MEGASQUIRT_ID:
        updateMegasquirt(data);
        break;
    case CURRENT_ID:
        updateCurrent(data);
        break;
    case VOLTAGE_ID:
        updateVoltage(data);
        break;
    default:
        // Do nothing if the CAN frame does not have an ID that we care about
    }
}

DataProcessor::updateGroundSpeed(QByteArray data)
{

}

DataProcessor::updateAirSpeed(QByteArray data)
{

}

DataProcessor::updateEFIPressure(QByteArray data)
{

}

DataProcessor::updateMegasquirt(QByteArray data)
{

}

DataProcessor::updateCurrent(QByteArray data)
{

}

DataProcessor::updateVoltage(QByteArray data)
{

}

DataProcessor::updateInterfaceIndicators(QByteArray data)
{

}
