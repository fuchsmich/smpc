import QtQuick 2.0
import org.nemomobile.mpris 1.0

MprisPlayer {
    id: mprisPlayer

    property string artist: ctl.player.playbackStatus.artist
    onArtistChanged: {
        var metadata = mprisPlayer.metadata
        metadata[Mpris.metadataToString(Mpris.Artist)] = [artist] // List of strings
        mprisPlayer.metadata = metadata
    }

    property string song: ctl.player.playbackStatus.title
    onSongChanged: {
        var metadata = mprisPlayer.metadata
        metadata[Mpris.metadataToString(Mpris.Title)] = song // String
        mprisPlayer.metadata = metadata
    }


    property string message: ""
    onMessageChanged: {
        console.debug("MPRIS Message: ", message)
        console.debug(ctl.player.playbackStatus.playlistSize, ctl.player.playbackStatus.trackNo)
    }

    serviceName: (connected ? "smpc" : "") //this (un)registers the service due to connection to mpd_server

    //Mpris2 Root Interface
    identity: "SMPC"
    //        supportedUriSchemes: ["file"]
    //        supportedMimeTypes: ["audio/x-wav", "audio/x-vorbis+ogg"]

    //Mpris2 Player Interface
    canControl: true
    canGoNext: playbackStatus !== Mpris.Stopped && ctl.player.playbackStatus.trackNo < ctl.player.playbackStatus.playlistSize
    onCanGoNextChanged: console.debug(canGoNext)
    canGoPrevious: playbackStatus !== Mpris.Stopped && ctl.player.playbackStatus.trackNo > 1
    onCanGoPreviousChanged: console.debug(canGoPrevious, ctl.player.playbackStatus.trackNo)
    canPause: true //got to be always true for MprisController::playPause to work!
    canPlay: true //mprisPlayer.playbackStatus !== Mpris.Playing
    //onCanPlayChanged: console.debug("canPlay", canPlay)
    canSeek: mprisPlayer.playbackStatus === Mpris.Playing || mprisPlayer.playbackStatus === Mpris.Paused

    playbackStatus: (ctl.player.playbackStatus.playbackStatus === 0 ?
                         Mpris.Paused : (ctl.player.playbackStatus.playbackStatus === 1 ?
                                          Mpris.Playing : Mpris.Stopped))

    loopStatus: (ctl.player.playbackStatus.repeat ? 1 : 0)
    shuffle: ctl.player.playbackStatus.shuffle
    volume: 1

    onPauseRequested: {
        message = "Pause requested"
        ctl.player.play()
    }
    onPlayRequested: {
        message = "Play requested"
        ctl.player.play()
    }
    onPlayPauseRequested: message = "Play/Pause requested"
    onStopRequested: {
        message = "Stop requested"
        ctl.player.stop()
    }
    onNextRequested: {
        message = "Next requested"
        ctl.player.next()
    }
    onPreviousRequested: {
        message = "Previous requested"
        ctl.player.previous()
    }
}
