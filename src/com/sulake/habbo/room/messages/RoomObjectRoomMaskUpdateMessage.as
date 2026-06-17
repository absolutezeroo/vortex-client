package com.sulake.habbo.room.messages
{
    import com.sulake.room.messages.RoomObjectUpdateMessage;
    import com.sulake.room.utils.Vector3d;
    import com.sulake.room.utils.IVector3d;

    public class RoomObjectRoomMaskUpdateMessage extends RoomObjectUpdateMessage 
    {

        public static const ADD_MASK:String = "RORMUM_ADD_MASK";
        public static const REMOVE_MASK:String = "RORMUM_ADD_MASK";
        public static const MASK_TYPE_DOOR:String = "door";
        public static const MASK_CATEGORY_WINDOW:String = "window";
        public static const MASK_CATEGORY_HOLE:String = "hole";

        private var _type:String = "";
        private var _maskId:String = "";
        private var _maskType:String = "";
        private var _maskLocation:Vector3d = null;
        private var _maskCategory:String = "window";

        public function RoomObjectRoomMaskUpdateMessage(type:String, maskId:String, maskType:String=null, maskLocation:IVector3d=null, maskCategory:String="window")
        {
            super(null, null);
            _type = type;
            _maskId = maskId;
            _maskType = maskType;

            if (maskLocation != null)
            {
                _maskLocation = new Vector3d(maskLocation.x, maskLocation.y, maskLocation.z);
            };

            _maskCategory = maskCategory;
        }

        public function get type():String
        {
            return (_type);
        }

        public function get maskId():String
        {
            return (_maskId);
        }

        public function get maskType():String
        {
            return (_maskType);
        }

        public function get maskLocation():IVector3d
        {
            return (_maskLocation);
        }

        public function get maskCategory():String
        {
            return (_maskCategory);
        }

    }
}