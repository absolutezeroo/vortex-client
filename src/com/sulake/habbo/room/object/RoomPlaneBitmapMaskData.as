package com.sulake.habbo.room.object
{
    import com.sulake.room.utils.Vector3d;
    import com.sulake.room.utils.IVector3d;

    public class RoomPlaneBitmapMaskData 
    {

        public static const MASK_CATEGORY_WINDOW:String = "window";
        public static const MASK_CATEGORY_HOLE:String = "hole";

        private var _loc:Vector3d = null;
        private var _type:String = null;
        private var _category:String = null;

        public function RoomPlaneBitmapMaskData(type:String, loc:IVector3d, category:String)
        {
            this.type = type;
            this.loc = loc;
            this.category = category;
        }

        public function get loc():IVector3d
        {
            return (_loc);
        }

        public function set loc(_arg_1:IVector3d):void
        {
            if (_loc == null)
            {
                _loc = new Vector3d();
            };

            _loc.assign(_arg_1);
        }

        public function get type():String
        {
            return (_type);
        }

        public function set type(type:String):void
        {
            _type = type;
        }

        public function get category():String
        {
            return (_category);
        }

        public function set category(category:String):void
        {
            _category = category;
        }

        public function dispose():void
        {
            _loc = null;
        }

    }
}