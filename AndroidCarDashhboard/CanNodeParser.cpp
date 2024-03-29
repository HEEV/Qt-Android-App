/**
 * Implementation of CanNodeParser class
 */

#include "CanNodeParser.h"

//begin static functions
/// \brief Get a signed 8-bit integer from a CanMessage.
int CanNodeParser::getData_int8(const QByteArray msg, int8_t& data)
{
    //check configuration byte
    if((msg[0] >> 5) != CAN_INT8 ||   //not right type
       (msg[0] & 0x1F) != CAN_DATA ){ //not data

        return INVALID_TYPE;
    }

    data = (int8_t) (msg[1] & 0xFF);
    return DATA_OK;
}

/// \brief Get an unsigned 8-bit integer from a CanMessage.
int CanNodeParser::getData_uint8(const QByteArray msg, uint8_t& data)
{
    //check configuration byte
    if((msg[0] >> 5) != CAN_UINT8 ||   //not right type
       (msg[0] & 0x1F) != CAN_DATA ){ //not data

        return INVALID_TYPE;
    }

    data = (uint8_t) (msg[1] & 0xFF);
    return DATA_OK;
}

/// \brief Get a signed 16-bit integer from a CanMessage.
int CanNodeParser::getData_int16(const QByteArray msg, int16_t& data)
{
    //check configuration byte
    if((msg[0] >> 5) != CAN_INT16 ||   //not right type
       (msg[0] & 0x1F) != CAN_DATA ){ //not data

        return INVALID_TYPE;
    }

    data  = (int16_t) (  msg[1] & 0xFF);
    data |= (int16_t) ( (msg[2] << 8) & 0xFF00 );
    return DATA_OK;
}

/// \brief Get an unsigned 16-bit integer from a CanMessage.
int CanNodeParser::getData_uint16(const QByteArray msg, uint16_t& data)
{
    //check configuration byte
    if((msg[0] >> 5) != CAN_UINT16 ||   //not right type
       (msg[0] & 0x1F) != CAN_DATA ){ //not data

        return INVALID_TYPE;
    }

    data  = (uint16_t) (  msg[1] & 0xFF);
    data |= (uint16_t) ( (msg[2] << 8) & 0xFF00 );
    return DATA_OK;
}

/// \brief Get a signed 32-bit integer from a CanMessage.
int CanNodeParser::getData_int32(const QByteArray msg, int32_t& data)
{
    //check configuration byte
    /*if((msg[0] >> 5) != CAN_INT32 ||   //not right type
       (msg[0] & 0x1F) != CAN_DATA ){ //not data

        return INVALID_TYPE;
    }*/

    if(msg.length() != 5)
    {
        return INVALID_TYPE;
    }

    data  = (int32_t)   (msg[1] & 0xFF);
    data |= (int32_t) ( (msg[2] << 8) & 0xFF00);
    data |= (int32_t) ( (msg[3] <<16) & 0xFF0000);
    data |= (int32_t) ( (msg[4] <<24) & 0xFF000000);
    return DATA_OK;
}

/// \brief Get an unsigned 32-bit integer from a CanMessage.
int CanNodeParser::getData_uint32(const QByteArray msg, uint32_t& data)
{
    //check configuration byte
    /*if((msg[0] >> 5) != CAN_UINT32 ||   //not right type
       (msg[0] & 0x1F) != CAN_DATA ){ //not data

        return INVALID_TYPE;
    }*/
    if(msg.length() != 5)
    {
        return INVALID_TYPE;
    }
    data  = (uint32_t)   (msg[1] & 0xFF);
    data |= (uint32_t) ( (msg[2] << 8) & 0xFF00);
    data |= (uint32_t) ( (msg[3] <<16) & 0xFF0000);
    data |= (uint32_t) ( (msg[4] <<24) & 0xFF000000);
    return DATA_OK;
}

/*int CanNodeParser::getData(const QByteArray msg, int& data)
{
    data  = (int) msg[1];
    data |= (int) (msg[2]<<8);
    data |= (int) (msg[3]<<16);
    data |= (int) (msg[4]<<24);
    return DATA_OK;
}*/

