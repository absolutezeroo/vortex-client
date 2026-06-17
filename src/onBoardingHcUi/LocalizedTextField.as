package onBoardingHcUi
{
    import flash.text.TextField;
    import com.sulake.core.localization.ILocalizable;
    import com.sulake.core.localization.ICoreLocalizationManager;

    public class LocalizedTextField extends TextField implements ILocalizable
    {

        private static var _localizationManager:ICoreLocalizationManager;

        protected var _localized:Boolean = false;
        private var _key:String;

        public static function set localizationManager(manager:ICoreLocalizationManager):void
        {
            _localizationManager = manager;
        }

        public static function get localizationManager():ICoreLocalizationManager
        {
            return (_localizationManager);
        }

        public function dispose():void
        {
            removeOldLocalization(_key);
        }

        override public function set htmlText(value:String):void
        {
            super.htmlText = value;
            checkLocalization(value);

            if (_localized)
            {
            };
        }

        public function set localization(localizationKey:String):void
        {
            super.htmlText = localizationKey;
        }

        protected function removeOldLocalization(localizationKey:String):void
        {
            if (_localized)
            {
                localizationManager.removeListener(localizationKey.slice(2, localizationKey.indexOf("}")), this);
                _localized = false;
            };
        }

        protected function checkLocalization(localizationValue:String):void
        {
            if (((((localizationManager) && (localizationValue)) && (localizationValue.charAt(0) == "$")) && (localizationValue.charAt(1) == "{")))
            {
                removeOldLocalization(_key);
                _key = localizationValue;
                _localized = true;
                localizationManager.registerListener(localizationValue.slice(2, localizationValue.indexOf("}")), this);
            };
        }

    }
}
