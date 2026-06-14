package com.sulake.habbo.friendbar.talent
{
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.habbo.communication.messages.parser.talent.TalentTrack;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IStaticBitmapWrapperWindow;
    import com.sulake.core.window.components.IWidgetWindow;
    import com.sulake.habbo.utils._SafeStr_25;
    import com.sulake.habbo.window.widgets.IAvatarImageWidget;
    import com.sulake.core.window.IWindow;

    public class TalentProgressMeter implements IDisposable 
    {

        private const ACHIEVED_DIVIDER:String = "talent_achieved_div";
        private const UNACHIEVED_DIVIDER:String = "talent_unachieved_div";
        private const DIVIDER_WINDOW_PREFIX:String = "progress_divider_level_";
        private const AVATAR_GLOW_RADIUS:int = 10;

        private var _disposed:Boolean = false;
        private var _habboTalent:HabboTalent;
        private var _controller:TalentTrackController;
        private var _talentTrack:TalentTrack;
        private var _progressContainer:IWindowContainer;
        private var _divider:IStaticBitmapWrapperWindow;
        private var _progressNeedle:IWidgetWindow;
        private var _achievedMid:IStaticBitmapWrapperWindow;
        private var _unachievedMid:IStaticBitmapWrapperWindow;

        public function TalentProgressMeter(_arg_1:HabboTalent, _arg_2:TalentTrackController)
        {
            _habboTalent = _arg_1;
            _controller = _arg_2;
            _talentTrack = _controller.talentTrack;
            createMeter();
        }

        public function get width():int
        {
            return (_controller.window.width);
        }

        public function get progressPerLevelWidth():int
        {
            return (Math.floor(_SafeStr_25.lerp(_talentTrack.progressPerLevel, 0, width)));
        }

        private function createMeter():void
        {
            var _local_2:int;
            var _local_1:IStaticBitmapWrapperWindow;
            _progressContainer = IWindowContainer(_controller.window.findChildByName("progress_container"));
            _divider = IStaticBitmapWrapperWindow(_progressContainer.removeChild(_progressContainer.findChildByName("progress_level_divider")));
            _achievedMid = IStaticBitmapWrapperWindow(_progressContainer.findChildByName("achieved_mid"));
            _unachievedMid = IStaticBitmapWrapperWindow(_progressContainer.findChildByName("unachieved_mid"));
            _local_2 = 1;

            while (_local_2 < _talentTrack.levels.length)
            {
                _local_1 = IStaticBitmapWrapperWindow(_divider.clone());
                _local_1.name = ("progress_divider_level_" + _local_2);
                _progressContainer.addChild(_local_1);
                _local_2++;
            };

            _progressNeedle = IWidgetWindow(_progressContainer.findChildByName("progress_needle"));
            IAvatarImageWidget(_progressNeedle.widget).figure = _habboTalent.sessionManager.figure;
            _progressContainer.setChildIndex(_progressNeedle, (_progressContainer.numChildren - 1));
        }

        public function dispose():void
        {
            if (!_disposed)
            {
                if (_divider)
                {
                    _divider.dispose();
                    _divider = null;
                };

                _achievedMid = null;
                _unachievedMid = null;
                _progressNeedle = null;
                _progressContainer = null;
                _talentTrack = null;
                _controller = null;
                _habboTalent = null;
                _disposed = true;
            };
        }

        public function get disposed():Boolean
        {
            return (_disposed);
        }

        public function resize():void
        {
            var _local_5:int;
            var _local_4:IStaticBitmapWrapperWindow;
            var _local_1:int = Math.floor(_SafeStr_25.lerp(_talentTrack.totalProgress, 0, width));
            _progressContainer.width = width;
            _unachievedMid.width = width;
            _achievedMid.width = _local_1;
            _progressNeedle.x = _SafeStr_25.clamp((_local_1 - int((_progressNeedle.width / 2))), 0, (width - _progressNeedle.width));

            var _local_2:IWindow = _progressContainer.findChildByName("avatar_glow");
            _local_2.x = (_progressNeedle.x - 10);
            _local_2.y = (_progressNeedle.y - 10);
            _local_2.width = (_progressNeedle.width + (2 * 10));
            _local_2.height = (_progressNeedle.height + (2 * 10));

            var _local_3:IWindow = _progressContainer.findChildByName("progress_balloon");
            _local_3.x = (((_progressNeedle.x + Math.floor((_progressNeedle.width / 2))) - Math.floor((_local_3.width / 2))) + 5);
            _local_5 = 1;

            while (_local_5 < _talentTrack.levels.length)
            {
                _local_4 = IStaticBitmapWrapperWindow(_progressContainer.findChildByName(("progress_divider_level_" + _local_5)));
                _local_4.x = (_local_5 * progressPerLevelWidth);

                if (_local_4.x < _local_1)
                {
                    _local_4.assetUri = "talent_achieved_div";
                }

                else
                {
                    _local_4.assetUri = "talent_unachieved_div";
                };

                _local_4.visible = true;
                _local_5++;
            };

            _progressContainer.invalidate();
        }

    }
}
