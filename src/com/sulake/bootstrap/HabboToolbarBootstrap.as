package com.sulake.bootstrap
{
    import com.sulake.habbo.toolbar.HabboToolbar;
    import com.sulake.core.runtime.IContext;
    import com.sulake.core.assets.IAssetLibrary;

    public class HabboToolbarBootstrap extends HabboToolbar 
    {

        public function HabboToolbarBootstrap(context:IContext, flags:uint=0, assetLibrary:IAssetLibrary=null)
        {
            super(context, flags, assetLibrary);
        }

    }
}