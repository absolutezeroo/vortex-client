package com.sulake.habbo.sound
{
    import com.sulake.core.runtime.IUpdateReceiver;
    import flash.media.Sound;
    import flash.utils.ByteArray;
    import flash.media.SoundTransform;

    public class HabboSoundWithPitch extends HabboSoundBase implements IUpdateReceiver 
    {

        private const SILENCE_MS:uint = 50;
        private const FADEIN_MS:uint = 175;

        private var _pitch:Number;
        private var _dynamicSound:Sound;
        private var _loadedSamples:ByteArray;
        private var _numSamples:int;
        private var _updateMs:uint = 0;
        private var _startMs:uint = 0;
        private var _fadeComplete:Boolean = false;

        public function HabboSoundWithPitch(_arg_1:Sound, _arg_2:Number=1)
        {
            super(_arg_1);
            _pitch = _arg_2;
            _dynamicSound = new Sound();
            extractMonoSamples();
            setPitch(_pitch);
        }

        override public function dispose():void
        {
            super.dispose();
            _dynamicSound = null;
            _loadedSamples.clear();
            _loadedSamples = null;
        }

        override public function play(_arg_1:Number=0):Boolean
        {
            stop();
            _startMs = _updateMs;
            _fadeComplete = false;
            setComplete(false);
            setSoundChannel(_dynamicSound.play(0, 0, new SoundTransform(0)));
            return (true);
        }

        override public function stop():Boolean
        {
            if (getSoundChannel() != null)
            {
                getSoundChannel().stop();
            };

            return (true);
        }

        public function update(_arg_1:uint):void
        {
            _updateMs = (_updateMs + _arg_1);

            var _local_2:uint = (_updateMs - _startMs);

            if (((_startMs > 0) && (_local_2 < 50)))
            {
                setChannelVolume(0);
            }

            else
            {
                if ((((_startMs > 0) && (_local_2 >= 50)) && (_local_2 < 175)))
                {
                    setChannelVolume((volume * (_local_2 / 175)));
                }

                else
                {
                    if (!_fadeComplete)
                    {
                        setChannelVolume(volume);
                        _fadeComplete = true;
                    };
                };
            };
        }

        public function get disposed():Boolean
        {
            return (_loadedSamples == null);
        }

        public function setPitch(_arg_1:Number):void
        {
            var _local_5:Number;
            var _local_4:int;
            _pitch = _arg_1;

            var _local_6:ByteArray = new ByteArray();
            var _local_3:uint = uint(((_loadedSamples.length / 4) * _pitch));
            var _local_2:Number = 0;
            _local_4 = 0;

            while (((_local_4 < _local_3) && ((_local_2 * 4) < _loadedSamples.length)))
            {
                _loadedSamples.position = (_local_2 * 4);
                _local_5 = _loadedSamples.readFloat();
                _local_6.writeFloat(_local_5);
                _local_6.writeFloat(_local_5);
                _local_2 = (_local_2 + _pitch);
                _local_4++;
            };

            _local_6.position = 0;
            _dynamicSound.loadPCMFromByteArray(_local_6, (_local_6.length / 8), "float");
        }

        private function extractMonoSamples():void
        {
            var _local_2:int;
            var _local_3:Number;
            var _local_1:ByteArray = new ByteArray();
            _soundObject.extract(_local_1, (_soundObject.length * 44.1), 0);
            _loadedSamples = new ByteArray();
            _numSamples = (_local_1.length / 8);
            _local_1.position = 0;
            _local_2 = 0;

            while (_local_2 < _numSamples)
            {
                _local_3 = _local_1.readFloat();
                _local_1.readFloat();
                _loadedSamples.writeFloat(_local_3);
                _local_2++;
            };
        }

    }
}
