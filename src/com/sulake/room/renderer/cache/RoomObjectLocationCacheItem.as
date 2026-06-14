package com.sulake.room.renderer.cache
{
    import com.sulake.room.utils.Vector3d;
    import com.sulake.room.utils.IVector3d;
    import com.sulake.room.object.IRoomObject;
    import com.sulake.room.utils.IRoomGeometry;

        public class RoomObjectLocationCacheItem 
    {

        private var _roomObjectVariableAccurateZ:String = "";
        private var _geometryUpdateId:int = -1;
        private var _objectUpdateId:int = -1;
        private var _objectUpdateLoc:Vector3d = new Vector3d();
        private var _screenLoc:Vector3d = null;
        private var _locationChanged:Boolean = false;

        public function RoomObjectLocationCacheItem(_arg_1:String)
        {
            _roomObjectVariableAccurateZ = _arg_1;
            _screenLoc = new Vector3d();
        }

        public function get locationChanged():Boolean
        {
            return (_locationChanged);
        }

        public function dispose():void
        {
            _screenLoc = null;
        }

        public function getScreenLocation(_arg_1:IRoomObject, _arg_2:IRoomGeometry):IVector3d
        {
            var _local_8:IVector3d;
            var _local_3:Number;
            var _local_4:Vector3d;
            var _local_6:IVector3d;

            if (((_arg_1 == null) || (_arg_2 == null)))
            {
                return (null);
            };

            var _local_5:Boolean;
            var _local_7:IVector3d = _arg_1.getLocation();

            if (((!(_arg_2.updateId == _geometryUpdateId)) || (!(_arg_1.getUpdateID() == _objectUpdateId))))
            {
                _objectUpdateId = _arg_1.getUpdateID();

                if (((((!(_arg_2.updateId == _geometryUpdateId)) || (!(_local_7.x == _objectUpdateLoc.x))) || (!(_local_7.y == _objectUpdateLoc.y))) || (!(_local_7.z == _objectUpdateLoc.z))))
                {
                    _geometryUpdateId = _arg_2.updateId;
                    _objectUpdateLoc.assign(_local_7);
                    _local_5 = true;
                };
            };

            _locationChanged = _local_5;

            if (_local_5)
            {
                _local_8 = _arg_2.getScreenPosition(_local_7);

                if (_local_8 == null)
                {
                    return (null);
                };

                _local_3 = _arg_1.getModel().getNumber(_roomObjectVariableAccurateZ);

                if (((isNaN(_local_3)) || (_local_3 == 0)))
                {
                    _local_4 = new Vector3d(Math.round(_local_7.x), Math.round(_local_7.y), _local_7.z);

                    if (((!(_local_4.x == _local_7.x)) || (!(_local_4.y == _local_7.y))))
                    {
                        _local_6 = _arg_2.getScreenPosition(_local_4);
                        _screenLoc.assign(_local_8);

                        if (_local_6 != null)
                        {
                            _screenLoc.z = _local_6.z;
                        };
                    }

                    else
                    {
                        _screenLoc.assign(_local_8);
                    };
                }

                else
                {
                    _screenLoc.assign(_local_8);
                };

                _screenLoc.x = Math.round(_screenLoc.x);
                _screenLoc.y = Math.round(_screenLoc.y);
            };

            return (_screenLoc);
        }

    }
}
