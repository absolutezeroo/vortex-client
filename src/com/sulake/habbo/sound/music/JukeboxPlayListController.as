package com.sulake.habbo.sound.music
{
    import com.sulake.habbo.sound.IPlayListController;
    import com.sulake.habbo.sound.IHabboMusicController;
    import flash.events.IEventDispatcher;
    import com.sulake.core.communication.connection.IConnection;
    import com.sulake.habbo.sound.HabboSoundManagerFlash10;
    import com.sulake.habbo.communication.messages.incoming.sound.NowPlayingMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.sound.JukeboxSongDisksMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.sound.JukeboxPlayListFullMessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.outgoing.sound.GetJukeboxPlayListMessageComposer;
    import com.sulake.habbo.sound.ISongInfo;
    import com.sulake.habbo.sound.events.SoundCompleteEvent;
    import com.sulake.habbo.communication.messages.parser.sound.NowPlayingMessageParser;
    import com.sulake.habbo.sound.events.NowPlayingEvent;
    import com.sulake.habbo.communication.messages.parser.sound.JukeboxSongDisksMessageParser;
    import com.sulake.habbo.sound.events.PlayListStatusEvent;
    import com.sulake.habbo.sound.events.SongInfoReceivedEvent;

    public class JukeboxPlayListController implements IPlayListController 
    {

        private var _disposed:Boolean = false;
        private var _isPlaying:Boolean = false;
        private var _entries:Array = [];
        private var _musicController:IHabboMusicController;
        private var _events:IEventDispatcher;
        private var _connection:IConnection;
        private var _soundManager:HabboSoundManagerFlash10;
        private var _nowPlayingSongId:int = -1;
        private var _missingSongInfo:Array = [];
        private var _messageEvents:Array;
        private var _playPosition:int = -1;

        public function JukeboxPlayListController(_arg_1:HabboSoundManagerFlash10, _arg_2:HabboMusicController, _arg_3:IEventDispatcher, _arg_4:IConnection)
        {
            _soundManager = _arg_1;
            _musicController = _arg_2;
            _events = _arg_3;
            _connection = _arg_4;
            _messageEvents = [];
            _messageEvents.push(new NowPlayingMessageEvent(onNowPlayingMessage));
            _messageEvents.push(new JukeboxSongDisksMessageEvent(onJukeboxSongDisksMessage));
            _messageEvents.push(new JukeboxPlayListFullMessageEvent(onJukeboxPlayListFullMessage));

            for each (var _local_5:IMessageEvent in _messageEvents)
            {
                _connection.addMessageEvent(_local_5);
            };

            _events.addEventListener("SCE_TRAX_SONG_COMPLETE", onSongFinishedPlayingEvent);
            _musicController.events.addEventListener("SIR_TRAX_SONG_INFO_RECEIVED", onSongInfoReceivedEvent);
        }

        public function get priority():int
        {
            return (0);
        }

        public function get nowPlayingSongId():int
        {
            return (_nowPlayingSongId);
        }

        public function get playPosition():int
        {
            return (_playPosition);
        }

        public function get disposed():Boolean
        {
            return (_disposed);
        }

        public function get isPlaying():Boolean
        {
            return (_isPlaying);
        }

        public function get length():int
        {
            if (_entries == null)
            {
                return (0);
            };

            return (_entries.length);
        }

        public function dispose():void
        {
            if (!_disposed)
            {
                stopPlaying();

                if (_musicController.events)
                {
                    _musicController.events.removeEventListener("SIR_TRAX_SONG_INFO_RECEIVED", onSongInfoReceivedEvent);
                };

                _musicController = null;
                _soundManager = null;

                if (_connection)
                {
                    for each (var _local_1:IMessageEvent in _messageEvents)
                    {
                        _connection.removeMessageEvent(_local_1);
                        _local_1.dispose();
                    };

                    _messageEvents = null;
                    _connection = null;
                };

                if (_events)
                {
                    _events.removeEventListener("SCE_TRAX_SONG_COMPLETE", onSongFinishedPlayingEvent);
                    _events = null;
                };

                _disposed = true;
            };
        }

        public function stopPlaying():void
        {
            _musicController.stop(priority);
            _nowPlayingSongId = -1;
            _playPosition = -1;
            _isPlaying = false;
        }

        public function requestPlayList():void
        {
            if (_connection == null)
            {
                return;
            };

            _connection.send(new GetJukeboxPlayListMessageComposer());
        }

        public function getEntry(_arg_1:int):ISongInfo
        {
            if (((_arg_1 < 0) || (_arg_1 >= _entries.length)))
            {
                return (null);
            };

            return (_entries[_arg_1]);
        }

        protected function onSongFinishedPlayingEvent(_arg_1:SoundCompleteEvent):void
        {
        }

        private function onNowPlayingMessage(_arg_1:IMessageEvent):void
        {
            var _local_3:NowPlayingMessageEvent = (_arg_1 as NowPlayingMessageEvent);
            var _local_2:NowPlayingMessageParser = (_local_3.getParser() as NowPlayingMessageParser);
            Logger.log(((((("Received Now Playing message with: " + _local_2.currentSongId) + ", ") + _local_2.nextSongId) + ", ") + _local_2.syncCount));
            _isPlaying = (!(_local_2.currentSongId == -1));

            if (_local_2.currentSongId >= 0)
            {
                _musicController.playSong(_local_2.currentSongId, 0, (_local_2.syncCount / 1000), 0, 1, 1);
                _nowPlayingSongId = _local_2.currentSongId;
            }

            else
            {
                stopPlaying();
            };

            if (_local_2.nextSongId >= 0)
            {
                _musicController.addSongInfoRequest(_local_2.nextSongId);
            };

            _playPosition = _local_2.currentPosition;
            _soundManager.events.dispatchEvent(new NowPlayingEvent("NPE_SONG_CHANGED", 0, _local_2.currentSongId, _local_2.currentPosition));
        }

        private function onJukeboxSongDisksMessage(_arg_1:IMessageEvent):void
        {
            var _local_4:int;
            var _local_7:int;
            var _local_6:int;
            var _local_3:SongDataEntry;
            var _local_5:JukeboxSongDisksMessageEvent = (_arg_1 as JukeboxSongDisksMessageEvent);
            var _local_2:JukeboxSongDisksMessageParser = (_local_5.getParser() as JukeboxSongDisksMessageParser);
            Logger.log(("Received Jukebox song disks (=playlist) message, length of playlist: " + _local_2.songDisks.length));
            _entries = [];
            _local_4 = 0;

            while (_local_4 < _local_2.songDisks.length)
            {
                _local_7 = _local_2.songDisks.getWithIndex(_local_4);
                _local_6 = _local_2.songDisks.getKey(_local_4);
                _local_3 = (_musicController.getSongInfo(_local_7) as SongDataEntry);

                if (_local_3 == null)
                {
                    _local_3 = new SongDataEntry(_local_7, -1, null, null, null);

                    if (_missingSongInfo.indexOf(_local_7) < 0)
                    {
                        _missingSongInfo.push(_local_7);
                        _musicController.requestSongInfoWithoutSamples(_local_7);
                    };
                };

                _local_3.diskId = _local_6;
                _entries.push(_local_3);
                _local_4++;
            };

            if (_missingSongInfo.length == 0)
            {
                _events.dispatchEvent(new PlayListStatusEvent("PLUE_PLAY_LIST_UPDATED"));
            };
        }

        private function onJukeboxPlayListFullMessage(_arg_1:IMessageEvent):void
        {
            Logger.log("Received jukebox playlist full message.");
            _events.dispatchEvent(new PlayListStatusEvent("PLUE_PLAY_LIST_FULL"));
        }

        private function onSongInfoReceivedEvent(_arg_1:SongInfoReceivedEvent):void
        {
            var _local_4:int;
            var _local_2:ISongInfo;
            var _local_6:int;
            var _local_3:SongDataEntry;
            _local_4 = 0;

            while (_local_4 < length)
            {
                _local_2 = _entries[_local_4];

                if (_local_2.id == _arg_1.id)
                {
                    _local_6 = _local_2.diskId;
                    _local_3 = (_musicController.getSongInfo(_arg_1.id) as SongDataEntry);

                    if (_local_3 != null)
                    {
                        _local_3.diskId = _local_6;
                        _entries[_local_4] = _local_3;
                    };

                    break;
                };

                _local_4++;
            };

            var _local_5:int = _missingSongInfo.indexOf(_arg_1.id);

            if (_local_5 >= 0)
            {
                _missingSongInfo.splice(_local_5, 1);
            };

            if (_missingSongInfo.length == 0)
            {
                _events.dispatchEvent(new PlayListStatusEvent("PLUE_PLAY_LIST_UPDATED"));
            };
        }

    }
}
