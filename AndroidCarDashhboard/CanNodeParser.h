/**
 * Convert from a CanNode message frame to basic integer types
 *
 * Sam Ellicott: 2-11-17
 */

#ifndef CAN_NODE_PARSER_H_
#define CAN_NODE_PARSER_H_

#include <QCanBusFrame>
#include <UIRaceDataset.h>
#include <QDebug>
#include <stdint.h>

class CanNodeParser
{
public:
    //no constructor needed just a bunch of static functions
    static const int DATA_OK=0;
    static const int INVALID_TYPE=1;

    //begin static functions
    /// \brief Get a signed 8-bit integer from a CanMessage.
    static int getData(const QByteArray msg,   int8_t& data);
    /// \brief Get an unsigned 8-bit integer from a CanMessage.
    static int getData(const QByteArray msg,  uint8_t& data);
    /// \brief Get a signed 16-bit integer from a CanMessage.
    static int getData(const QByteArray msg,  int16_t& data);
    /// \brief Get an unsigned 16-bit integer from a CanMessage.
    static int getData(const QByteArray msg, uint16_t& data);
    /// \brief Get a signed 32-bit integer from a CanMessage.
    static int getData(const QByteArray msg,  int32_t& data);
    /// \brief Get an unsigned 32-bit integer from a CanMessage.
    static int getData(const QByteArray msg, uint32_t& data);

private:
   enum CanNodeDataType{
        CAN_DATA=0,
        CAN_UINT8=0,     ///< Unsigned 8-bit integer
        CAN_INT8,      ///< Signed 8-bit integer
        CAN_UINT16,    ///< Unsigned 16-bit integer
        CAN_INT16,     ///< Signed 16-bit integer
        CAN_UINT32,    ///< Unsigned 32-bit integer
        CAN_INT32,     ///< Signed 32-bit integer
        CAN_BIT_FIELD, ///< Each bit defines the state of value
        CAN_CUSTOM     ///< Catch all
    };
};
#endif //CAN_NODE_PARSER_H_
