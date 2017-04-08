#include "AVMedia.h"

AVMedia::AVMedia()
{
    player = new QMediaPlayer();
}

bool AVMedia::load(QString name)
{
    player->setMedia(QUrl("qrc:///rick_roll.mp3"));
    player->setVolume(50);
}

void AVMedia::play()
{
    player->play();
}

void AVMedia::pause()
{
    player->pause();
}

void AVMedia::stop()
{
    player->stop();
}

AVMedia::~AVMedia()
{

}
