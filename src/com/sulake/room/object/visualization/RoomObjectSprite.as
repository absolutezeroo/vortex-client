package com.sulake.room.object.visualization
{
    import flash.display.BitmapData;
    import flash.geom.Point;
    import com.sulake.room.object.enum.RoomObjectSpriteType;

    public final class RoomObjectSprite implements IRoomObjectSprite
    {

        private static var _nextInstanceId:int = 0;

        private var _asset:BitmapData = null;
        private var _assetName:String = "";
        private var _libraryAssetName:String = "";
        private var _assetPosture:String = null;
        private var _assetGesture:String = null;
        private var _visible:Boolean = true;
        private var _tag:String = "";
        private var _alpha:int = 0xFF;
        private var _color:int = 0xFFFFFF;
        private var _blendMode:String = "normal";
        private var _flipH:Boolean = false;
        private var _flipV:Boolean = false;
        private var _direction:int = 0;
        private var _offset:Point = new Point(0, 0);
        private var _width:int = 0;
        private var _height:int = 0;
        private var _relativeDepth:Number = 0;
        private var _planeId:int = 0;
        private var _varyingDepth:Boolean = false;
        private var _alphaTolerance:int = 128;
        private var _clickHandling:Boolean = false;
        private var _updateId:int = 0;
        private var _instanceId:int = 0;
        private var _filters:Array = null;
        protected var _spriteType:int = RoomObjectSpriteType.DEFAULT;
        private var _objectType:String;

        public function RoomObjectSprite()
        {
            _instanceId = _nextInstanceId++;
        }

        public function dispose():void
        {
            _asset = null;
            _width = 0;
            _height = 0;
        }

        public function get asset():BitmapData
        {
            return (_asset);
        }

        public function get assetName():String
        {
            return (_assetName);
        }

        public function get assetPosture():String
        {
            return (_assetPosture);
        }

        public function set assetPosture(posture:String):void
        {
            _assetPosture = posture;
        }

        public function get assetGesture():String
        {
            return (_assetGesture);
        }

        public function set assetGesture(gesture:String):void
        {
            _assetGesture = gesture;
        }

        public function get visible():Boolean
        {
            return (_visible);
        }

        public function get tag():String
        {
            return (_tag);
        }

        public function get alpha():int
        {
            return (_alpha);
        }

        public function get color():int
        {
            return (_color);
        }

        public function get blendMode():String
        {
            return (_blendMode);
        }

        public function get flipV():Boolean
        {
            return (_flipV);
        }

        public function get flipH():Boolean
        {
            return (_flipH);
        }

        public function get direction():int
        {
            return (_direction);
        }

        public function get offsetX():int
        {
            return (_offset.x);
        }

        public function get offsetY():int
        {
            return (_offset.y);
        }

        public function get width():int
        {
            return (_width);
        }

        public function get height():int
        {
            return (_height);
        }

        public function get relativeDepth():Number
        {
            return (_relativeDepth);
        }

        public function get varyingDepth():Boolean
        {
            return (_varyingDepth);
        }

        public function get clickHandling():Boolean
        {
            return (_clickHandling);
        }

        public function get instanceId():int
        {
            return (_instanceId);
        }

        public function get updateId():int
        {
            return (_updateId);
        }

        public function get filters():Array
        {
            return (_filters);
        }

        public function get spriteType():int
        {
            return (_spriteType);
        }

        public function get objectType():String
        {
            return (_objectType);
        }

        public function set objectType(type:String):void
        {
            _objectType = type;
        }

        public function get planeId():int
        {
            return (_planeId);
        }

        public function set planeId(planeId:int):void
        {
            _planeId = planeId;
        }

        public function set spriteType(spriteType:int):void
        {
            _spriteType = spriteType;
        }

        public function set asset(bitmapData:BitmapData):void
        {
            if (bitmapData == _asset)
            {
                return;
            };

            if (bitmapData != null)
            {
                _width = bitmapData.width;
                _height = bitmapData.height;
            };

            _asset = bitmapData;
            _updateId++;
        }

        public function set assetName(name:String):void
        {
            if (name == _assetName)
            {
                return;
            };

            _assetName = name;
            _updateId++;
        }

        public function set visible(visible:Boolean):void
        {
            if (visible == _visible)
            {
                return;
            };

            _visible = visible;
            _updateId++;
        }

        public function set tag(tag:String):void
        {
            if (tag == _tag)
            {
                return;
            };

            _tag = tag;
            _updateId++;
        }

        public function set alpha(value:int):void
        {
            value = (value & 0xFF);

            if (value == _alpha)
            {
                return;
            };

            _alpha = value;
            _updateId++;
        }

        public function set color(value:int):void
        {
            value = (value & 0xFFFFFF);

            if (value == _color)
            {
                return;
            };

            _color = value;
            _updateId++;
        }

        public function set blendMode(mode:String):void
        {
            if (mode == _blendMode)
            {
                return;
            };

            _blendMode = mode;
            _updateId++;
        }

        public function set filters(filters:Array):void
        {
            if (filters == _filters)
            {
                return;
            };

            _filters = filters;
            _updateId++;
        }

        public function set flipH(flipHorizontal:Boolean):void
        {
            if (flipHorizontal == _flipH)
            {
                return;
            };

            _flipH = flipHorizontal;
            _updateId++;
        }

        public function set flipV(flipVertical:Boolean):void
        {
            if (flipVertical == _flipV)
            {
                return;
            };

            _flipV = flipVertical;
            _updateId++;
        }

        public function set direction(direction:int):void
        {
            _direction = direction;
        }

        public function set offsetX(xOffset:int):void
        {
            if (xOffset == _offset.x)
            {
                return;
            };

            _offset.x = xOffset;
            _updateId++;
        }

        public function set offsetY(yOffset:int):void
        {
            if (yOffset == _offset.y)
            {
                return;
            };

            _offset.y = yOffset;
            _updateId++;
        }

        public function set relativeDepth(depth:Number):void
        {
            if (depth == _relativeDepth)
            {
                return;
            };

            _relativeDepth = depth;
            _updateId++;
        }

        public function set varyingDepth(varying:Boolean):void
        {
            if (varying == _varyingDepth)
            {
                return;
            };

            _varyingDepth = varying;
            _updateId++;
        }

        public function set clickHandling(value:Boolean):void
        {
            if (_clickHandling == value)
            {
                return;
            };

            _clickHandling = value;
            _updateId++;
        }

        public function get alphaTolerance():int
        {
            return (_alphaTolerance);
        }

        public function set alphaTolerance(value:int):void
        {
            if (_alphaTolerance == value)
            {
                return;
            };

            _alphaTolerance = value;
            _updateId++;
        }

        public function get libraryAssetName():String
        {
            return (_libraryAssetName);
        }

        public function set libraryAssetName(name:String):void
        {
            _libraryAssetName = name;
        }

    }
}
