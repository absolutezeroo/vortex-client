package com.sulake.habbo.ui.widget.camera
{
    import flash.display.BitmapData;

    public class CameraSlotData 
    {

        public var image:BitmapData;
        private var _date:Date;
        public var isEmpty:Boolean;

        public function setDate(_arg_1:Date):void
        {
            _date = _arg_1;
        }

        public function get dateString():String
        {
            return ((((((((_date.date + "/") + (_date.month + 1)) + "/") + _date.getFullYear()) + " ") + _date.getHours()) + ":") + addLeadingZero(_date.getMinutes()));
        }

        private function addLeadingZero(_arg_1:int):String
        {
            var _local_2:String = _arg_1.toString();

            if (_local_2.length == 1)
            {
                _local_2 = ("0" + _local_2);
            };

            return (_local_2);
        }

        public function getDateTimestamp():int
        {
            return (_date.time);
        }

    }
}
