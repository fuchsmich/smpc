import QtQuick 2.0
import Sailfish.Silica 1.0
import "pages"
import org.nemomobile.mpris 1.0

// FIXME to harbour.smpc.components.whatever import
import "components"



ApplicationWindow
{
    id: mainWindow

    // Signals for c++<->qml communication
//    signal setHostname(string hostname);
//    signal setPort(int port);
//    signal setPassword(string password);
//    signal connectToServer();
    //signal setVolume(int volume);
    signal setCurrentArtist(string artist);

    // Signals for database requests to networkaccess
    //Variant in format [artistname,albumname]
    signal addAlbum(variant album);
    signal addArtist(string artist);
    signal addFiles(string files);
    signal addSong(string uri);
    signal addSongToSaved(variant data);
    signal removeSongFromSaved(variant data);
    signal addSongAfterCurrent(string uri);
    signal addPlaylist(string name);
    signal playPlaylist(string name);
    signal playAlbum(variant album);
    signal playArtist(string artist);
    signal playFiles(string uri);
    signal playPlaylistSongNext(int index);
    //appends song to playlist
    signal playSong(string uri);
    // Adds all tracks from last search result to playlist
    signal addlastsearch();
    signal requestSavedPlaylists();
    signal requestSavedPlaylist(string name);
    signal requestAlbums();
    signal requestAlbum(variant album);
    signal requestArtists();
    signal requestArtistAlbums(string artist);
    signal requestFilesPage(string files);
    signal requestFilesModel(string files);
    signal requestCurrentPlaylist();
    signal requestOutputs();
    signal requestSearch(variant request);
    // Request an MPD database update (remote mpd db)
    signal updateDB();


    // Signals controller that stack of filemodels can be wiped
    signal popfilemodelstack();
    signal cleanFileStack();

    // Controller model clear signals (memory cleanup)
    signal clearAlbumList();
    signal clearArtistList();
    signal clearTrackList();
    signal clearPlaylists();

    // MPD Output controls
    signal enableOutput(int nr);
    signal disableOutput(int nr);

    // Control signals
    signal play();
    signal next();
    signal prev();
    signal stop();
    signal seek(int position);
    signal setRepeat(bool rep);
    signal setShuffle(bool shfl);

    //Playlist signals
    signal savePlaylist(string name);
    signal deletePlaylist();
    signal deleteSavedPlaylist(string name);
    signal playPlaylistTrack(int index);
    signal deletePlaylistTrack(int index);

    // Changes server profile or creates new one
    signal changeProfile(variant profile);
    signal newProfile(variant profile);
    signal deleteProfile(int index);
    // Requests controller to connect to MPD host
    signal connectProfile(int index);

    // Database stuff (local-metadata DB)
    signal bulkDownloadArtists();
    signal bulkDownloadAlbums();
    signal cleanupBlacklisted();
    signal cleanupArtists();
    signal cleanupAlbums();
    signal cleanupDB();

    // Wiki/Biography information requests for sqlDB
    signal requestArtistInfo(string artist);
    signal requestAlbumInfo(variant album);

    // Signals change in download-size preference
    signal newDownloadSize(int size)

    // Signals changed settings key
    // [settingkey,value]
    signal newSettingKey(variant setting);

    signal wakeUpServer(int index);

    // Propertys of application
    property string hostname;

    property int port;
    property string password;
    property int listfontsize : 12;
    property int liststretch : 20;
    property int lastsongid : mpd_status.id
    property string playbuttoniconsource : mpd_status.playbackStatus === 1 ? "image://theme/icon-l-pause" : "image://theme/icon-l-play";
    property string playbuttoniconsourcecover :  mpd_status.playbackStatus === 1 ? "image://theme/icon-cover-pause" : "image://theme/icon-cover-play";
    property string volumebuttoniconsource;
    property string lastpath;
    property string artistname;
    property string albumname;
    property string playlistname;
    property string coverimageurl;
    property string artistimageurl;
    property string profilename;
    property bool quitbtnenabled;
    property bool connected;
    property bool playing : false;
    property bool stopped : false;
    property bool fastscrollenabled : false;

    property real listPadding : Theme.paddingLarge
    property int populateDuration: 500

    property bool volumeChanging:false

    // current song information
    property string mTitle: mpd_status.title;
    property string mArtist: mpd_status.artist;
    property string mAlbum: mpd_status.album;
    property int mVolume: mpd_status.volume;
    property int mLength: mpd_status.length
    property int mPosition: mpd_status.currentTime
    property int mPlaylistlength : mpd_status.playlistSize
    property bool mRepeat: mpd_status.repeat
    property bool mShuffle: mpd_status.shuffle
    property bool mDebugEnabled
    property bool mPositionSliderActive:false;
    property string mAudioProperties: mpd_status.samplerate + " Hz " + mpd_status.bitDepth + " " + qsTr("bits") + " " + mpd_status.channelCount + " " + qsTr("channels") ;
    property string mTrackNr: mpd_status.trackNo
    property string mBitrate: mpd_status.bitrate + " " + qsTr("kbps");
    property string mUri: mpd_status.uri
    property string mLengthText: formatLength(mpd_status.length)

    property bool jollaQuickscroll: false

    property Page mPlaylistPage;
    property Page mCurrentSongPage;


    // JS-functions
    //TODO separation

    function slotConnected(profile)
    {
        profilename = profile;
        connected = true;
    }

    function slotDisconnected()
    {
        connected = false;
        profilename = "";
        playing = false;
    }

    function busy()
    {
        busyIndicator.running = true;
        inputBlock.enabled = true
    }

    function ready()
    {
        busyIndicator.running = false;
        inputBlock.enabled = false
    }

    function savedPlaylistClicked(modelData)
    {
        playlistname = modelData;
        requestSavedPlaylist(modelData);
    }


    function filesClicked(path)
    {
        lastpath = path;
        requestFilesPage(path);
    }

    function albumTrackClicked(title,album,artist,lengthformatted,uri,year,tracknr,trackmbid,artistmbid,albummbid)
    {
        pageStack.push(Qt.resolvedUrl("components/SongDialog.qml"),{title:title,album:album,artist:artist,filename:uri,lengthtext:lengthformatted,date:year,nr:tracknr,trackmbid:trackmbid,artistmbid:artistmbid,albummbid:albummbid});
    }

    function receiveFilesPage()
    {
        pageStack.push("pages/database/FileBrowserPage.qml",{listmodel: filesModel,filepath :lastpath});
        fastscrollenabled = true;
    }

    function popCleared() {
        fastscrollenabled = true;
    }

    // Nicely formats length values to string
    function formatLength(length)
    {
        if ( length === 0 ) {
            return "00:00"
        }

        var temphours = Math.floor(length/3600);
        var min = 0;
        var sec = 0;
        var temp="";
        if(temphours>1)
        {
            min=(length-(3600*temphours))/60;
        }
        else{
            min=Math.floor(length/60);
        }
        sec = length-temphours*3600-min*60;
        if(temphours===0)
        {
            temp=((min<10?"0":"")+min)+":"+(sec<10?"0":"")+(sec);
        }
        else
        {
            temp=((temphours<10?"0":"")+temphours)+":"+((min<10?"0":"")+min)+":"+(sec<10?"0":"")+(sec);
        }
        return temp;
    }

    function albumClicked(artist,albumstring)
    {
        requestAlbum([artist,albumstring]);
        artistname = artist;
        albumname = albumstring;
    }

    function artistClicked(item)
    {
        mainWindow.artistname = item;
        requestArtistAlbums(item);
    }

    function coverArtReceiver(url)
    {
        coverimageurl = url;
    }

    function coverArtistArtReceiver(url)
    {
        artistimageurl = url;
    }

    // Notifies user about ongoing action in netaccess
    BusyIndicator
    {
        id:busyIndicator
        size: BusyIndicatorSize.Large
        anchors.centerIn: parent
    }

    // Prevents clicking if active request is running
    MouseArea
    {
        id: inputBlock
        anchors.fill: parent
        preventStealing: true
        enabled: false
    }

    MprisPlayer {
        id: mprisPlayer

        property string artist: mpd_status.artist
        property string song: mpd_status.title

        property string message: ""
        onMessageChanged: console.debug("MPRIS Message: ", message);

        serviceName: (connected ? "smpc" : "") //this (un)registers the service due to connection to mpd_server
        //            serviceName: "smpc"

        //Mpris2 Root Interface
        identity: "SMPC"
        //        supportedUriSchemes: ["file"]
        //        supportedMimeTypes: ["audio/x-wav", "audio/x-vorbis+ogg"]

        //Mpris2 Player Interface
        canControl: true
        canGoNext: mTrackNr < mPlaylistlength
        canGoPrevious: true
        canPause: true //got to be always true for MprisController::playPause to work!
        canPlay: playbackStatus !== Mpris.Playing
        onCanPlayChanged: console.debug("canPlay", canPlay)
        canSeek: false

        playbackStatus:
            (mpd_status.playbackStatus === 0 ? Mpris.Paused :
                                               (mpd_status.playbackStatus === 1 ? Mpris.Playing
                                                                                : Mpris.Stopped))
        onPlaybackStatusChanged: console.debug("mpd_status.playbackStatus", mpd_status.playbackStatus, playbackStatus
                                               ,"canPlay", canPlay, "canPause", canPause)

        loopStatus: (mpd_status.repeat ? 1 : 0)
        shuffle: mpd_status.shuffle
        volume: 1

        onPauseRequested: {
            message = "Pause requested"
            play();
        }
        onPlayRequested: {
            message = "Play requested"
            play();
        }
        onPlayPauseRequested: message = "Play/Pause requested"
        onStopRequested: message = "Stop requested"
        onNextRequested: {
            message = "Next requested"
            next();
            console.debug(canGoNext, mTrackNr, mPlaylistlength)
        }
        onPreviousRequested: {
            message = "Previous requested"
            prev();
        }

        onArtistChanged: {
            var metadata = mprisPlayer.metadata

            metadata[Mpris.metadataToString(Mpris.Artist)] = [artist] // List of strings

            mprisPlayer.metadata = metadata
        }

        onSongChanged: {
            var metadata = mprisPlayer.metadata

            metadata[Mpris.metadataToString(Mpris.Title)] = song // String

            mprisPlayer.metadata = metadata
        }

    }



    ControlPanel {
        id: quickControlPanel
    }
    bottomMargin: quickControlPanel.visibleSize


    initialPage: Qt.resolvedUrl("pages/MainPage.qml")
    cover: Qt.resolvedUrl("cover/CoverPage.qml")

}
