package com.sulake.bootstrap
{
    import com.sulake.habbo.navigator.HabboNewNavigator;
    import com.sulake.core.runtime.IContext;
    import com.sulake.core.assets.IAssetLibrary;

    public class HabboNewNavigatorBootstrap extends HabboNewNavigator 
    {

        public function HabboNewNavigatorBootstrap(context:IContext, flags:uint=0, assetLibrary:IAssetLibrary=null)
        {
            super(context, flags, assetLibrary);
        }

    }
}