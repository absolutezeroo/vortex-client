package com.sulake.habbo.avatar.actions
{
    import com.sulake.core.utils.Map;
    import flash.utils.Dictionary;

    public class ActionDefinition implements IActionDefinition
    {

        private var _id:String;
        private var _state:String;
        private var _precedence:int;
        private var _activePartSet:String;
        private var _assetPartDefinition:String;
        private var _lay:String;
        private var _geometryType:String;
        private var _isMain:Boolean = false;
        private var _isDefault:Boolean = false;
        private var _isAnimation:Boolean = false;
        private var _startFromFrameZero:Boolean = false;
        private var _prevents:Array = [];
        private var _preventHeadTurn:Boolean;
        private var _canvasOffsets:Map;
        private var _types:Dictionary = new Dictionary();
        private var _params:Dictionary = new Dictionary();
        private var _defaultParameterValue:String = "";

        public function ActionDefinition(_arg_1:XML)
        {
            super();

            var _local_6:String = null;
            var _local_7:String = null;
            var _local_4:String = null;
            _id = String(_arg_1.@id);
            _state = String(_arg_1.@state);
            _precedence = parseInt(_arg_1.@precedence);
            _activePartSet = String(_arg_1.@activepartset);
            _assetPartDefinition = String(_arg_1.@assetpartdefinition);
            _lay = String(_arg_1.@lay);
            _geometryType = String(_arg_1.@geometrytype);
            _isMain = !!parseInt(_arg_1.@main);
            _isDefault = !!parseInt(_arg_1.@isdefault);
            _isAnimation = !!parseInt(_arg_1.@animation);
            _startFromFrameZero = (_arg_1.@startfromframezero == "true");
            _preventHeadTurn = (_arg_1.@preventheadturn == "true");

            var _local_3:String = String(_arg_1.@prevents);

            if (_local_3 != "")
            {
                _prevents = _local_3.split(",");
            };

            for each (var _local_2:XML in _arg_1.param)
            {
                _local_6 = String(_local_2.@id);
                _local_7 = String(_local_2.@value);

                if (_local_6 == "default")
                {
                    _defaultParameterValue = _local_7;
                }

                else
                {
                    _params[_local_6] = _local_7;
                };
            };

            for each (var _local_5:XML in _arg_1.type)
            {
                _local_4 = String(_local_5.@id);
                _types[_local_4] = new ActionType(_local_5);
            };
        }

        public function setOffsets(_arg_1:String, _arg_2:int, _arg_3:Array):void
        {
            if (_canvasOffsets == null)
            {
                _canvasOffsets = new Map();
            };

            if (_canvasOffsets.getValue(_arg_1) == null)
            {
                _canvasOffsets.add(_arg_1, new Map());
            };

            var _local_4:Map = _canvasOffsets.getValue(_arg_1);
            _local_4.add(_arg_2, _arg_3);
        }

        public function getOffsets(_arg_1:String, _arg_2:int):Array
        {
            if (_canvasOffsets == null)
            {
                return (null);
            };

            var _local_3:Map = (_canvasOffsets.getValue(_arg_1) as Map);

            if (_local_3 == null)
            {
                return (null);
            };

            return (_local_3.getValue(_arg_2) as Array);
        }

        public function getParameterValue(_arg_1:String):String
        {
            if (_arg_1 == "")
            {
                return ("");
            };

            var _local_2:String = _params[_arg_1];

            if (_local_2 == null)
            {
                _local_2 = _defaultParameterValue;
            };

            return (_local_2);
        }

        private function getTypePrevents(_arg_1:String):Array
        {
            if (_arg_1 == "")
            {
                return ([]);
            };

            var _local_2:ActionType = _types[_arg_1];

            if (_local_2 != null)
            {
                return (_local_2.prevents);
            };

            return ([]);
        }

        public function toString():String
        {
            return ((((((((((((((((((((((("[ActionDefinition]\nid:           " + id) + "\n") + "state:        ") + state) + "\n") + "main:         ") + isMain) + "\n") + "default:      ") + isDefault) + "\n") + "geometry:     ") + state) + "\n") + "precedence:   ") + precedence) + "\n") + "activepartset:") + activePartSet) + "\n") + "activepartdef:") + assetPartDefinition) + "");
        }

        public function get id():String
        {
            return (_id);
        }

        public function get state():String
        {
            return (_state);
        }

        public function get precedence():int
        {
            return (_precedence);
        }

        public function get activePartSet():String
        {
            return (_activePartSet);
        }

        public function get isMain():Boolean
        {
            return (_isMain);
        }

        public function get isDefault():Boolean
        {
            return (_isDefault);
        }

        public function get assetPartDefinition():String
        {
            return (_assetPartDefinition);
        }

        public function get lay():String
        {
            return (_lay);
        }

        public function get geometryType():String
        {
            return (_geometryType);
        }

        public function get isAnimation():Boolean
        {
            return (_isAnimation);
        }

        public function getPrevents(_arg_1:String=""):Array
        {
            return (_prevents.concat(getTypePrevents(_arg_1)));
        }

        public function getPreventHeadTurn(_arg_1:String=""):Boolean
        {
            if (_arg_1 == "")
            {
                return (_preventHeadTurn);
            };

            var _local_2:ActionType = _types[_arg_1];

            if (_local_2 != null)
            {
                return (_local_2.preventHeadTurn);
            };

            return (_preventHeadTurn);
        }

        public function isAnimated(_arg_1:String):Boolean
        {
            if (_arg_1 == "")
            {
                return (true);
            };

            var _local_2:ActionType = _types[_arg_1];

            if (_local_2 != null)
            {
                return (_local_2.isAnimated);
            };

            return (true);
        }

        public function get startFromFrameZero():Boolean
        {
            return (_startFromFrameZero);
        }

        public function get params():Dictionary
        {
            return (_params);
        }

    }
}