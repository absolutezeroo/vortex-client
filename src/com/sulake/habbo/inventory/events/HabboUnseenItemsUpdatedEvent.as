package com.sulake.habbo.inventory.events
{
    import flash.events.Event;
    import flash.utils.Dictionary;

    public class HabboUnseenItemsUpdatedEvent extends Event 
    {

        public static const _SafeStr_2748:String = "HUIUE_UNSEEN_ITEMS_CHANGED";

        private var _inventoryCount:int;
        private var _categoryCount:Dictionary;

        public function HabboUnseenItemsUpdatedEvent(_arg_1:Boolean=false, _arg_2:Boolean=false)
        {
            super("HUIUE_UNSEEN_ITEMS_CHANGED");
            _categoryCount = new Dictionary();
        }

        public function setCategoryCount(_arg_1:int, _arg_2:int):void
        {
            _categoryCount[_arg_1.toString()] = _arg_2;
        }

        public function getCategoryCount(_arg_1:int):int
        {
            return (_categoryCount[_arg_1.toString()]);
        }

        public function set inventoryCount(_arg_1:int):void
        {
            _inventoryCount = _arg_1;
        }

        public function get inventoryCount():int
        {
            return (_inventoryCount);
        }

    }
}
