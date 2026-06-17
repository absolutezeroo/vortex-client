package com.sulake.bootstrap
{
    import com.sulake.habbo.inventory.HabboInventory;
    import com.sulake.core.runtime.IContext;
    import com.sulake.core.assets.IAssetLibrary;

    public class HabboInventoryBootstrap extends HabboInventory 
    {

        public function HabboInventoryBootstrap(context:IContext, flags:uint=0, assetLibrary:IAssetLibrary=null)
        {
            super(context, flags, assetLibrary);
        }

    }
}