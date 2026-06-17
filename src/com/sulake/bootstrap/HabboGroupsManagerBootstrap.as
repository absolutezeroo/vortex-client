package com.sulake.bootstrap
{
    import com.sulake.habbo.groups.HabboGroupsManager;
    import com.sulake.core.runtime.IContext;
    import com.sulake.core.assets.IAssetLibrary;

    public class HabboGroupsManagerBootstrap extends HabboGroupsManager 
    {

        public function HabboGroupsManagerBootstrap(context:IContext, flags:uint=0, assetLibrary:IAssetLibrary=null)
        {
            super(context, flags, assetLibrary);
        }

    }
}