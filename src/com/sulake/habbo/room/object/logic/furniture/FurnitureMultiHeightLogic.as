package com.sulake.habbo.room.object.logic.furniture
{
    public class FurnitureMultiHeightLogic extends FurnitureMultiStateLogic 
    {

        override public function initialize(_arg_xml:XML):void
        {
            super.initialize(_arg_xml);
            object.getModelController().setNumber("furniture_is_variable_height", 1, true);
        }

    }
}