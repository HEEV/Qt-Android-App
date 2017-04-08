#ifndef AVMEDIA_H
#define AVMEDIA_H

#include <QString>
#include <QtMultimedia/QMediaPlayer>
#include <QUrl>

class AVMedia
{
public:
    AVMedia();
    ~AVMedia();

    bool load(QString name);
    void play();
    void pause();
    void stop();

private:
    QMediaPlayer *player;

};

#endif // AVMEDIA_H
