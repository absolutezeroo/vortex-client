package com.sulake.habbo.ui.widget.crafting.utils
{
    import flash.events.EventDispatcher;
    import com.sulake.habbo.session.furniture.IFurnitureData;
    import __AS3__.vec.Vector;

    public class CraftingFurnitureItem extends EventDispatcher 
    {

        private var _productCode:String;
        private var _furnitureData:IFurnitureData;
        private var _inventoryIds:Vector.<int>;
        private var _mixerIds:Vector.<int>;

        public function CraftingFurnitureItem(_arg_1:String, _arg_2:IFurnitureData)
        {
            _productCode = _arg_1;
            _furnitureData = _arg_2;
            _inventoryIds = new Vector.<int>(0);
            _mixerIds = new Vector.<int>(0);
        }

        public function get furnitureData():IFurnitureData
        {
            return (_furnitureData);
        }

        public function get productCode():String
        {
            return (_productCode);
        }

        public function get typeId():int
        {
            return ((_furnitureData) ? _furnitureData.id : -1);
        }

        public function get countInInventory():int
        {
            return ((_inventoryIds) ? _inventoryIds.length : 0);
        }

        public function set inventoryIds(_arg_1:Vector.<int>):void
        {
            _inventoryIds = _arg_1;
        }

        public function getItemToMixer():int
        {
            if (countInInventory == 0)
            {
                return (0);
            };

            var _local_1:int = _inventoryIds.shift();
            _mixerIds.push(_local_1);
            return (_local_1);
        }

        public function returnItemToInventory(_arg_1:int):void
        {
            _inventoryIds.push(_arg_1);
            _mixerIds.splice(_mixerIds.indexOf(_arg_1), 1);
        }

    }
}
