package com.sulake.habbo.catalog.viewer.widgets.events
{
    import flash.events.Event;

    public class CatalogWidgetSellablePetPalettesEvent extends Event 
    {

        private var _productCode:String;
        private var _sellablePalettes:Array;

        public function CatalogWidgetSellablePetPalettesEvent(_arg_1:String, _arg_2:Array, _arg_3:Boolean=false, _arg_4:Boolean=false)
        {
            super("SELLABLE_PET_PALETTES", _arg_3, _arg_4);
            _productCode = _arg_1;
            _sellablePalettes = _arg_2;
        }

        public function get productCode():String
        {
            return (_productCode);
        }

        public function get sellablePalettes():Array
        {
            if (_sellablePalettes != null)
            {
                return (_sellablePalettes.slice());
            };

            return ([]);
        }

    }
}
