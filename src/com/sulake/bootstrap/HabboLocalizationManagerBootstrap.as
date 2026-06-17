package com.sulake.bootstrap
{
    import com.sulake.habbo.localization.HabboLocalizationManager;
    import com.sulake.core.runtime.IContext;
    import com.sulake.core.assets.IAssetLibrary;

    public class HabboLocalizationManagerBootstrap extends HabboLocalizationManager 
    {

        public function HabboLocalizationManagerBootstrap(context:IContext, flags:uint=0, assetLibrary:IAssetLibrary=null)
        {
            super(context, flags, assetLibrary);
        }

    }
}