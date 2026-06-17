package onBoardingHcUi
{
    import flash.display.Sprite;
    import com.sulake.core.localization.ILocalizable;
    import com.sulake.core.localization.ICoreLocalizationManager;

    public class LocalizedSprite extends Sprite implements ILocalizable
    {

        private static var _localizationManager:ICoreLocalizationManager;

        protected var _localized:Boolean = false;

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
            var labelOrKey:String = "";

            if ((this is Button))
            {
                labelOrKey = (this as Button).label;
            };

            removeOldLocalization(labelOrKey);
        }

        public function set localization(localizationKey:String):void
        {
            if ((this is Button))
            {
                (this as Button).localizedText = localizationKey;
            };
        }

        protected function removeOldLocalization(localizationKey:String):void
        {
            if (_localized)
            {
                localizationManager.removeListener(localizationKey.slice(2, localizationKey.indexOf("}")), this);
                _localized = false;
            };
        }

        protected function checkLocalization(localizationKey:String):void
        {
            if (((((localizationManager) && (localizationKey)) && (localizationKey.charAt(0) == "$")) && (localizationKey.charAt(1) == "{")))
            {
                _localized = true;
                localizationManager.registerListener(localizationKey.slice(2, localizationKey.indexOf("}")), this);
            };
        }

    }
}
