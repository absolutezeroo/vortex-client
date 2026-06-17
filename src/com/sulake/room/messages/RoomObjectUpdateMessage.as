package com.sulake.room.messages
{
    import com.sulake.room.utils.IVector3d;

    public class RoomObjectUpdateMessage 
    {

        protected var _location:IVector3d;
        protected var _direction:IVector3d;

        public function RoomObjectUpdateMessage(location:IVector3d, direction:IVector3d)
        {
            _location = location;
            _direction = direction;
        }

        public function get loc():IVector3d
        {
            return (_location);
        }

        public function get dir():IVector3d
        {
            return (_direction);
        }

    }
}

