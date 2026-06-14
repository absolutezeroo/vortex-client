package com.sulake.habbo.sound.trax
{
    import com.sulake.habbo.sound.IHabboSound;
    import com.sulake.core.runtime.IDisposable;
    import __AS3__.vec.Vector;
    import flash.events.IEventDispatcher;
    import flash.media.Sound;
    import flash.media.SoundChannel;
    import com.sulake.core.utils.Map;
    import flash.utils.Timer;
    import flash.media.SoundTransform;
    import flash.utils.getTimer;
    import flash.events.SampleDataEvent;
    import flash.utils.ByteArray;
    import flash.events.TimerEvent;
    import com.sulake.habbo.sound.events.SoundCompleteEvent;

    public class TraxSequencer implements IHabboSound, IDisposable 
    {

        private static const SAMPLES_PER_SECOND:Number = 44100;
        private static const BUFFER_LENGTH:uint = 0x2000;
        private static const SAMPLES_BAR_LENGTH:uint = 88000;
        private static const BAR_LENGTH:uint = 88000;
        private static const MIXING_BUFFER:Vector.<int> = new Vector.<int>(0x2000, true);
        private static const INTERPOLATION_BUFFER:Vector.<int> = new Vector.<int>(0x2000, true);

        private var _disposed:Boolean = false;
        private var _events:IEventDispatcher;
        private var _volume:Number;
        private var _sound:Sound;
        private var _soundChannel:SoundChannel;
        private var _traxData:TraxData;
        private var _samples:Map;
        private var _ready:Boolean;
        private var _songId:int;
        private var _playLengthSamples:int = 0;
        private var _playHead:uint;
        private var _sequence:Array;
        private var _prepared:Boolean;
        private var _finished:Boolean = true;
        private var _lengthSamples:uint;
        private var _latencyMs:uint = 30;
        private var _fadeInActive:Boolean;
        private var _fadeOutActive:Boolean;
        private var _fadeInLengthSamples:int;
        private var _fadeOutLengthSamples:int;
        private var _fadeInSampleCounter:int;
        private var _fadeOutSampleCounter:int;
        private var _fadeoutStopTimer:Timer;
        private var _stopTimer:Timer;
        private var _useCutMode:Boolean;
        private var _expectedStreamPosition:int = 0;
        private var _bufferUnderRunCount:int = 0;

        public function TraxSequencer(_arg_1:int, _arg_2:TraxData, _arg_3:Map, _arg_4:IEventDispatcher)
        {
            _events = _arg_4;
            _songId = _arg_1;
            _volume = 1;
            _sound = new Sound();
            _soundChannel = null;
            _samples = _arg_3;
            _traxData = _arg_2;
            _ready = true;
            _playHead = 0;
            _sequence = [];
            _prepared = false;
            _lengthSamples = 0;
            _finished = false;
            _fadeInActive = false;
            _fadeOutActive = false;
            _fadeInLengthSamples = 0;
            _fadeOutLengthSamples = 0;
            _fadeInSampleCounter = 0;
            _fadeOutSampleCounter = 0;
        }

        public function set position(_arg_1:Number):void
        {
            _playHead = (_arg_1 * 44100);
        }

        public function get volume():Number
        {
            return (_volume);
        }

        public function get position():Number
        {
            return (_playHead / 44100);
        }

        public function get ready():Boolean
        {
            return (_ready);
        }

        public function set ready(_arg_1:Boolean):void
        {
            _ready = _arg_1;
        }

        public function get finished():Boolean
        {
            return (_finished);
        }

        public function get fadeOutSeconds():Number
        {
            return (_fadeOutLengthSamples / 44100);
        }

        public function set fadeOutSeconds(_arg_1:Number):void
        {
            _fadeOutLengthSamples = (_arg_1 * 44100);
        }

        public function get fadeInSeconds():Number
        {
            return (_fadeInLengthSamples / 44100);
        }

        public function set fadeInSeconds(_arg_1:Number):void
        {
            _fadeInLengthSamples = (_arg_1 * 44100);
        }

        public function get traxData():TraxData
        {
            return (_traxData);
        }

        public function set volume(_arg_1:Number):void
        {
            _volume = _arg_1;

            if (_soundChannel != null)
            {
                _soundChannel.soundTransform = new SoundTransform(_volume);
            };
        }

        public function get length():Number
        {
            return (_lengthSamples / 44100);
        }

        public function get disposed():Boolean
        {
            return (_disposed);
        }

        public function dispose():void
        {
            if (!_disposed)
            {
                stopImmediately();
                _traxData = null;
                _samples = null;
                _sequence = null;
                _events = null;
                _sound = null;
                _disposed = true;
            };
        }

        public function prepare():Boolean
        {
            if (!_ready)
            {
                Logger.log("Cannot start trax playback until samples ready!");
                return (false);
            };

            if (!_prepared)
            {
                if (_traxData != null)
                {
                    _useCutMode = false;

                    if (_traxData.hasMetaData)
                    {
                        _useCutMode = _traxData.metaCutMode;
                    };

                    if (_useCutMode)
                    {
                        if (!prepareSequence())
                        {
                            Logger.log("Cannot start playback, prepare sequence failed!");
                            return (false);
                        };
                    }

                    else
                    {
                        if (!prepareLegacySequence())
                        {
                            Logger.log("Cannot start playback, prepare legacy sequence failed!");
                            return (false);
                        };
                    };
                };
            };

            return (true);
        }

        private function prepareLegacySequence():Boolean
        {
            var _local_8:int;
            var _local_3:Map;
            var _local_7:TraxChannel;
            var _local_4:uint;
            var _local_2:uint;
            var _local_9:int;
            var _local_5:int;
            var _local_12:TraxSample;
            var _local_11:int;
            var _local_6:int;
            var _local_10:int;

            if (_sequence == null)
            {
                return (false);
            };

            var _local_1:uint = getTimer();
            _local_8 = 0;

            while (_local_8 < _traxData.channels.length)
            {
                _local_3 = new Map();
                _local_7 = (_traxData.channels[_local_8] as TraxChannel);
                _local_4 = 0;
                _local_2 = 0;
                _local_9 = 0;

                while (_local_9 < _local_7.itemCount)
                {
                    _local_5 = _local_7.getItem(_local_9).id;
                    _local_12 = (_samples.getValue(_local_5) as TraxSample);
                    _local_12.setUsageFromSong(_songId, _local_1);

                    if (_local_12 != null)
                    {
                        _local_11 = getSampleBars(_local_12.length);
                        _local_6 = int((_local_7.getItem(_local_9).length / _local_11));
                        _local_10 = 0;

                        while (_local_10 < _local_6)
                        {
                            if (_local_5 != 0)
                            {
                                _local_3.add(_local_4, _local_12);
                            };

                            _local_2 = (_local_2 + _local_11);
                            _local_4 = (_local_2 * 88000);
                            _local_10++;
                        };
                    }

                    else
                    {
                        Logger.log("Error in prepareLegacySequence(), sample was null!");
                        return (false);
                    };

                    if (_lengthSamples < _local_4)
                    {
                        _lengthSamples = _local_4;
                    };

                    _local_9++;
                };

                _sequence.push(_local_3);
                _local_8++;
            };

            _prepared = true;
            return (true);
        }

        private function prepareSequence():Boolean
        {
            var _local_6:int;
            var _local_12:Map;
            var _local_5:TraxChannel;
            var _local_2:uint;
            var _local_11:uint;
            var _local_13:Boolean;
            var _local_7:int;
            var _local_4:int;
            var _local_9:TraxSample;
            var _local_3:int;
            var _local_14:int;
            var _local_8:int;
            var _local_1:int;

            if (_sequence == null)
            {
                return (false);
            };

            var _local_10:uint = getTimer();
            _local_6 = 0;

            while (_local_6 < _traxData.channels.length)
            {
                _local_12 = new Map();
                _local_5 = (_traxData.channels[_local_6] as TraxChannel);
                _local_2 = 0;
                _local_11 = 0;
                _local_13 = false;
                _local_7 = 0;

                while (_local_7 < _local_5.itemCount)
                {
                    _local_4 = _local_5.getItem(_local_7).id;
                    _local_9 = (_samples.getValue(_local_4) as TraxSample);
                    _local_9.setUsageFromSong(_songId, _local_10);

                    if (_local_9 != null)
                    {
                        _local_3 = _local_11;
                        _local_14 = _local_2;
                        _local_8 = getSampleBars(_local_9.length);
                        _local_1 = _local_5.getItem(_local_7).length;

                        while (_local_3 < (_local_11 + _local_1))
                        {
                            if (((!(_local_4 == 0)) || (_local_13)))
                            {
                                _local_12.add(_local_14, _local_9);
                                _local_13 = false;
                            };

                            _local_3 = (_local_3 + _local_8);
                            _local_14 = (_local_3 * 88000);

                            if (_local_3 > (_local_11 + _local_1))
                            {
                                _local_13 = true;
                            };
                        };

                        _local_11 = (_local_11 + _local_5.getItem(_local_7).length);
                        _local_2 = (_local_11 * 88000);
                    }

                    else
                    {
                        Logger.log("Error in prepareSequence(), sample was null!");
                        return (false);
                    };

                    if (_lengthSamples < _local_2)
                    {
                        _lengthSamples = _local_2;
                    };

                    _local_7++;
                };

                _sequence.push(_local_12);
                _local_6++;
            };

            _prepared = true;
            return (true);
        }

        public function play(_arg_1:Number=0):Boolean
        {
            if (!prepare())
            {
                return (false);
            };

            removeFadeoutStopTimer();

            if (_soundChannel != null)
            {
                stopImmediately();
            };

            if (_fadeInLengthSamples > 0)
            {
                _fadeInActive = true;
                _fadeInSampleCounter = 0;
            };

            _fadeOutActive = false;
            _fadeOutSampleCounter = 0;
            _finished = false;
            _sound.addEventListener("sampleData", onSampleData);
            _playLengthSamples = (_arg_1 * 44100);
            _expectedStreamPosition = 0;
            _bufferUnderRunCount = 0;
            _soundChannel = _sound.play();
            volume = _volume;
            return (true);
        }

        public function render(_arg_1:SampleDataEvent):Boolean
        {
            if (!prepare())
            {
                return (false);
            };

            while (!(_finished))
            {
                onSampleData(_arg_1);
            };

            return (true);
        }

        public function stop():Boolean
        {
            if (((_fadeOutLengthSamples > 0) && (!(_finished))))
            {
                stopWithFadeout();
            }

            else
            {
                playingComplete();
            };

            return (true);
        }

        private function stopImmediately():void
        {
            removeStopTimer();

            if (_soundChannel != null)
            {
                _soundChannel.stop();
                _soundChannel = null;
            };

            if (_sound != null)
            {
                _sound.removeEventListener("sampleData", onSampleData);
            };
        }

        private function stopWithFadeout():void
        {
            if (_fadeoutStopTimer == null)
            {
                _fadeOutActive = true;
                _fadeOutSampleCounter = 0;
                _fadeoutStopTimer = new Timer((_latencyMs + (_fadeOutLengthSamples / (44100 / 1000))), 1);
                _fadeoutStopTimer.start();
                _fadeoutStopTimer.addEventListener("timerComplete", onFadeOutComplete);
            };
        }

        private function getSampleBars(_arg_1:uint):int
        {
            if (_useCutMode)
            {
                return (Math.round((_arg_1 / 88000)));
            };

            return (Math.ceil((_arg_1 / 88000)));
        }

        private function getChannelSequenceOffsets():Array
        {
            var _local_1:int;
            var _local_3:int;
            var _local_5:Map;
            var _local_4:int;
            var _local_2:Array = [];

            if (_sequence != null)
            {
                _local_1 = _sequence.length;
                _local_3 = 0;

                while (_local_3 < _local_1)
                {
                    _local_5 = _sequence[_local_3];
                    _local_4 = 0;

                    while (((_local_4 < _local_5.length) && (_local_5.getKey(_local_4) < _playHead)))
                    {
                        _local_4++;
                    };

                    _local_2.push((_local_4 - 1));
                    _local_3++;
                };
            };

            return (_local_2);
        }

        private function mixChannelsIntoBuffer():void
        {
            var _local_6:int;
            var _local_7:Map;
            var _local_14:int;
            var _local_8:TraxSample;
            var _local_2:int;
            var _local_5:int;
            var _local_13:int;
            var _local_11:int;
            var _local_3:int;
            var _local_10:int;
            var _local_9:int;

            if (_sequence == null)
            {
                return;
            };

            var _local_4:Array = getChannelSequenceOffsets();
            var _local_1:int = _sequence.length;
            var _local_12:TraxChannelSample;
            _local_6 = (_local_1 - 1);

            while (_local_6 >= 0)
            {
                _local_7 = _sequence[_local_6];
                _local_14 = _local_4[_local_6];
                _local_8 = _local_7.getWithIndex(_local_14);

                if (_local_8 == null)
                {
                    _local_12 = null;
                }

                else
                {
                    _local_2 = _local_7.getKey(_local_14);
                    _local_5 = (_playHead - _local_2);

                    if (((_local_8.id == 0) || (_local_5 < 0)))
                    {
                        _local_12 = null;
                    }

                    else
                    {
                        _local_12 = new TraxChannelSample(_local_8, _local_5);
                    };
                };

                _local_13 = 0x2000;

                if ((_lengthSamples - _playHead) < _local_13)
                {
                    _local_13 = (_lengthSamples - _playHead);
                };

                _local_11 = 0;

                while (_local_11 < _local_13)
                {
                    _local_3 = _local_13;

                    if (_local_14 < (_local_7.length - 1))
                    {
                        _local_10 = _local_7.getKey((_local_14 + 1));

                        if ((_local_13 + _playHead) >= _local_10)
                        {
                            _local_3 = (_local_10 - _playHead);
                        };
                    };

                    if (_local_3 > (_local_13 - _local_11))
                    {
                        _local_3 = (_local_13 - _local_11);
                    };

                    if (_local_6 == (_local_1 - 1))
                    {
                        if (_local_12 != null)
                        {
                            _local_12.setSample(MIXING_BUFFER, _local_11, _local_3);
                            _local_11 = (_local_11 + _local_3);
                        }

                        else
                        {
                            _local_9 = 0;

                            while (_local_9 < _local_3)
                            {
                                MIXING_BUFFER[_local_11++] = 0;
                                _local_9++;
                            };
                        };
                    }

                    else
                    {
                        if (_local_12 != null)
                        {
                            _local_12.addSample(MIXING_BUFFER, _local_11, _local_3);
                        };

                        _local_11 = (_local_11 + _local_3);
                    };

                    if (_local_11 < _local_13)
                    {
                        _local_8 = _local_7.getWithIndex(++_local_14);

                        if (((_local_8 == null) || (_local_8.id == 0)))
                        {
                            _local_12 = null;
                        }

                        else
                        {
                            _local_12 = new TraxChannelSample(_local_8, 0);
                        };
                    };
                };

                _local_6--;
            };
        }

        private function checkSongFinishing():void
        {
            var _local_1:int = ((_lengthSamples < _playLengthSamples) ? _lengthSamples : ((_playLengthSamples > 0) ? _playLengthSamples : _lengthSamples));

            if (((_playHead > (_local_1 + (_latencyMs * (44100 / 1000)))) && (!(_finished))))
            {
                _finished = true;

                if (_stopTimer != null)
                {
                    _stopTimer.reset();
                    _stopTimer.removeEventListener("timerComplete", onPlayingComplete);
                };

                _stopTimer = new Timer(2, 1);
                _stopTimer.start();
                _stopTimer.addEventListener("timerComplete", onPlayingComplete);
            }

            else
            {
                if (((_playHead > (_local_1 - _fadeOutLengthSamples)) && (!(_fadeOutActive))))
                {
                    _fadeInActive = false;
                    _fadeOutActive = true;
                    _fadeOutSampleCounter = 0;
                };
            };
        }

        private function onSampleData(_arg_1:SampleDataEvent):void
        {
            if (_arg_1.position > _expectedStreamPosition)
            {
                _bufferUnderRunCount++;
                Logger.log("Audio buffer under run...");
                _expectedStreamPosition = _arg_1.position;
            };

            if (volume > 0)
            {
                mixChannelsIntoBuffer();
            };

            var _local_2:Number = 0x2000;

            if ((_lengthSamples - _playHead) < _local_2)
            {
                _local_2 = (_lengthSamples - _playHead);

                if (_local_2 < 0)
                {
                    _local_2 = 0;
                };
            };

            if (volume <= 0)
            {
                _local_2 = 0;
            };

            writeAudioToOutputStream(_arg_1.data, _local_2);
            _playHead = (_playHead + 0x2000);
            _expectedStreamPosition = (_expectedStreamPosition + 0x2000);

            if (_soundChannel != null)
            {
                _latencyMs = (((_arg_1.position / 44100) * 1000) - _soundChannel.position);
            };

            checkSongFinishing();
        }

        private function writeAudioToOutputStream(_arg_1:ByteArray, _arg_2:int):void
        {
            var _local_3:Number;
            var _local_4:Number;
            var _local_6:int;

            if (_arg_2 > 0)
            {
                if (((!(_fadeInActive)) && (!(_fadeOutActive))))
                {
                    writeMixingBufferToOutputStream(_arg_1, _arg_2);
                }

                else
                {
                    if (_fadeInActive)
                    {
                        _local_3 = (1 / _fadeInLengthSamples);
                        _local_4 = (_fadeInSampleCounter / _fadeInLengthSamples);
                        _fadeInSampleCounter = (_fadeInSampleCounter + 0x2000);

                        if (_fadeInSampleCounter > _fadeInLengthSamples)
                        {
                            _fadeInActive = false;
                        };
                    }

                    else
                    {
                        if (_fadeOutActive)
                        {
                            _local_3 = (-1 / _fadeOutLengthSamples);
                            _local_4 = (1 - (_fadeOutSampleCounter / _fadeOutLengthSamples));
                            _fadeOutSampleCounter = (_fadeOutSampleCounter + 0x2000);

                            if (_fadeOutSampleCounter > _fadeOutLengthSamples)
                            {
                                _fadeOutSampleCounter = _fadeOutLengthSamples;
                            };
                        };
                    };

                    writeMixingBufferToOutputStreamWithFade(_arg_1, _arg_2, _local_4, _local_3);
                };
            };

            var _local_5:Number = 0;
            _local_6 = _arg_2;

            while (_local_6 < 0x2000)
            {
                _arg_1.writeFloat(_local_5);
                _arg_1.writeFloat(_local_5);
                _local_6++;
            };
        }

        private function writeMixingBufferToOutputStream(_arg_1:ByteArray, _arg_2:int):void
        {
            var _local_3:int;
            var _local_4:Number = 0;
            _local_3 = 0;

            while (_local_3 < _arg_2)
            {
                _local_4 = (MIXING_BUFFER[_local_3] * 3.0517578125E-5);
                _arg_1.writeFloat(_local_4);
                _arg_1.writeFloat(_local_4);
                _local_3++;
            };
        }

        private function writeMixingBufferToOutputStreamWithFade(_arg_1:ByteArray, _arg_2:int, _arg_3:Number, _arg_4:Number):void
        {
            var _local_6:Number = 0;
            var _local_5:int;
            _local_5 = 0;

            while (_local_5 < _arg_2)
            {
                if (((_arg_3 < 0) || (_arg_3 > 1))) break;
                _local_6 = ((MIXING_BUFFER[_local_5] * 3.0517578125E-5) * _arg_3);
                _arg_3 = (_arg_3 + _arg_4);
                _arg_1.writeFloat(_local_6);
                _arg_1.writeFloat(_local_6);
                _local_5++;
            };

            if (_arg_3 < 0)
            {
                while (_local_5 < _arg_2)
                {
                    _arg_1.writeFloat(0);
                    _arg_1.writeFloat(0);
                    _local_5++;
                };
            }

            else
            {
                if (_arg_3 > 1)
                {
                    while (_local_5 < _arg_2)
                    {
                        _local_6 = (MIXING_BUFFER[_local_5] * 3.0517578125E-5);
                        _arg_3 = (_arg_3 + _arg_4);
                        _arg_1.writeFloat(_local_6);
                        _arg_1.writeFloat(_local_6);
                        _local_5++;
                    };
                };
            };
        }

        private function onPlayingComplete(_arg_1:TimerEvent):void
        {
            if (_finished)
            {
                playingComplete();
            };
        }

        private function onFadeOutComplete(_arg_1:TimerEvent):void
        {
            removeFadeoutStopTimer();
            playingComplete();
        }

        private function playingComplete():void
        {
            stopImmediately();
            _events.dispatchEvent(new SoundCompleteEvent("SCE_TRAX_SONG_COMPLETE", _songId));
        }

        private function removeFadeoutStopTimer():void
        {
            if (_fadeoutStopTimer != null)
            {
                _fadeoutStopTimer.removeEventListener("timerComplete", onFadeOutComplete);
                _fadeoutStopTimer.reset();
                _fadeoutStopTimer = null;
            };
        }

        private function removeStopTimer():void
        {
            if (_stopTimer != null)
            {
                _stopTimer.reset();
                _stopTimer.removeEventListener("timerComplete", onPlayingComplete);
                _stopTimer = null;
            };
        }

    }
}
