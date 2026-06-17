package com.sulake.habbo.room.utils
{
    import com.sulake.habbo.room.ISelectedRoomObjectData;
    import com.sulake.room.utils.Vector3d;
    import com.sulake.habbo.room.IStuffData;
    import com.sulake.room.utils.IVector3d;

        public class SelectedRoomObjectData implements ISelectedRoomObjectData 
    {

        private var _id:int = 0;
        private var _category:int = 0;
        private var _operation:String = "";
        private var _loc:Vector3d = null;
        private var _dir:Vector3d = null;
        private var _typeId:int = 0;
        private var _instanceData:String = null;
        private var _stuffData:IStuffData = null;
        private var _state:int = -1;
        private var _animFrame:int = -1;
        private var _posture:String = null;

        public function SelectedRoomObjectData(id:int, category:int, operation:String, loc:IVector3d, dir:IVector3d, typeId:int=0, instanceData:String=null, stuffData:IStuffData=null, state:int=-1, animFrame:int=-1, posture:String=null)
        {
            _id = id;
            _category = category;
            _operation = operation;
            _loc = new Vector3d();
            _loc.assign(loc);
            _dir = new Vector3d();
            _dir.assign(dir);
            _typeId = typeId;
            _instanceData = instanceData;
            _stuffData = stuffData;
            _state = state;
            _animFrame = animFrame;
            _posture = posture;
        }

        public function get id():int
        {
            return (_id);
        }

        public function get category():int
        {
            return (_category);
        }

        public function get operation():String
        {
            return (_operation);
        }

        public function get loc():Vector3d
        {
            return (_loc);
        }

        public function get dir():Vector3d
        {
            return (_dir);
        }

        public function get typeId():int
        {
            return (_typeId);
        }

        public function get instanceData():String
        {
            return (_instanceData);
        }

        public function get stuffData():IStuffData
        {
            return (_stuffData);
        }

        public function get state():int
        {
            return (_state);
        }

        public function get animFrame():int
        {
            return (_animFrame);
        }

        public function get posture():String
        {
            return (_posture);
        }

        public function dispose():void
        {
            _loc = null;
            _dir = null;
        }

    }
}