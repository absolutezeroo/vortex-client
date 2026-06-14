package com.sulake.habbo.inventory.effects
{
    import com.sulake.habbo.inventory.common.IThumbListDataProvider;

    public class EffectListProxy implements IThumbListDataProvider 
    {

        private var _model:EffectsModel;
        private var _filter:int;

        public function EffectListProxy(_arg_1:EffectsModel, _arg_2:int)
        {
            _model = _arg_1;
            _filter = _arg_2;
        }

        public function dispose():void
        {
            _model = null;
        }

        public function getDrawableList():Array
        {
            return (_model.getEffects(_filter));
        }

    }
}
