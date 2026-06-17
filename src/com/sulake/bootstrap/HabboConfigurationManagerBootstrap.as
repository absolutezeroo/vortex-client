package com.sulake.bootstrap
{
    import com.sulake.habbo.configuration.HabboConfigurationManager;
    import com.sulake.core.runtime.IContext;
    import com.sulake.core.assets.IAssetLibrary;

    public class HabboConfigurationManagerBootstrap extends HabboConfigurationManager 
    {

        public function HabboConfigurationManagerBootstrap(context:IContext, flags:uint=0, assetLibrary:IAssetLibrary=null)
        {
            super(context, flags, assetLibrary);
        }

    }
}