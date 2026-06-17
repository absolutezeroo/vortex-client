package com.sulake.bootstrap
{
    import com.sulake.habbo.navigator.HabboNavigator;
    import com.sulake.core.runtime.IContext;
    import com.sulake.core.assets.IAssetLibrary;

    public class HabboNavigatorBootstrap extends HabboNavigator 
    {

        public function HabboNavigatorBootstrap(context:IContext, flags:uint=0, assetLibrary:IAssetLibrary=null)
        {
            super(context, flags, assetLibrary);
        }

    }
}