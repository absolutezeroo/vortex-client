package com.sulake.habbo.friendbar.landingview.layout
{
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.runtime.IUpdateReceiver;
    import com.sulake.habbo.friendbar.landingview.HabboLandingView;
    import com.sulake.core.utils.Map;
    import flash.events.EventDispatcher;
    import com.sulake.habbo.friendbar.landingview.layout.backgroundobjects._SafeStr_225;
    import com.sulake.habbo.friendbar.landingview.layout.backgroundobjects.BackgroundObject;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.friendbar.landingview.layout.backgroundobjects.*;

    public class MovingBackgroundObjects implements IDisposable, IUpdateReceiver 
    {

        private static const MAX_OBJECTS:int = 20;

        private var _landingView:HabboLandingView;
        private var _objects:Array = [];
        private var _objectTypeMap:Map = new Map();
        private var _events:EventDispatcher = new EventDispatcher();
        private var _timingCode:String = "";

        public function MovingBackgroundObjects(_arg_1:HabboLandingView)
        {
            _landingView = _arg_1;
            initializeObjectTypeMapping();
        }

        private function initializeObjectTypeMapping():void
        {
            _objectTypeMap.add("line", _SafeStr_225.CLASS_LINEAR);
            _objectTypeMap.add("spiral", _SafeStr_225.CLASS_SPIRAL);
            _objectTypeMap.add("animated", _SafeStr_225.CLASS_STATIC_ANIMATED);
            _objectTypeMap.add("randomwalk", _SafeStr_225.CLASS_RANDOM_WALK);
        }

        public function dispose():void
        {
            _landingView = null;

            for each (var _local_1:BackgroundObject in _objects)
            {
                _local_1.dispose();
            };

            _objects = null;
            _objectTypeMap.reset();
            _objectTypeMap = null;
            _events = null;
        }

        public function get disposed():Boolean
        {
            return (_landingView == null);
        }

        public function initialize(_arg_1:IWindowContainer):void
        {
            var _local_4:int;
            var _local_2:String;
            var _local_3:BackgroundObject;
            _arg_1 = IWindowContainer(_arg_1.findChildByName("moving_objects_container"));

            if (_arg_1 == null)
            {
                return;
            };

            if (_objects.length > 0)
            {
                return;
            };

            _local_4 = 1;

            while (_local_4 <= 20)
            {
                if (_timingCode == "")
                {
                    _local_2 = _landingView.getProperty(("landing.view.bgobject." + _local_4));
                }

                else
                {
                    _local_2 = _landingView.getProperty(((("landing.view." + _timingCode) + ".bgobject.") + _local_4));
                };

                if (_local_2 != "")
                {
                    _local_3 = getObjectByDataContent(_local_4, _local_2, _arg_1);

                    if (_local_3 != null)
                    {
                        _objects.push(_local_3);
                    };
                };

                _local_4++;
            };
        }

        public function update(_arg_1:uint):void
        {
            for each (var _local_2:BackgroundObject in _objects)
            {
                _local_2.update(_arg_1);
            };
        }

        private function getObjectByDataContent(_arg_1:int, _arg_2:String, _arg_3:IWindowContainer):BackgroundObject
        {
            var _local_6:String;
            var _local_5:Class;
            var _local_4:Array = _arg_2.split(";");

            if (_local_4.length >= 2)
            {
                _local_6 = _local_4[1];
                _local_5 = _objectTypeMap.getValue(_local_6);

                if (_local_5 != null)
                {
                    return (new _local_5(_arg_1, _arg_3, _events, _landingView, _arg_2));
                };
            };

            return (null);
        }

        public function set timingCode(_arg_1:String):void
        {
            _timingCode = _arg_1;
        }

    }
}
