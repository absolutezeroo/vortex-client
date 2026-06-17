package com.sulake.bootstrap
{
    import com.sulake.habbo.tracking.HabboTracking;
    import com.sulake.core.runtime.IContext;
    import com.sulake.core.assets.IAssetLibrary;

    public class HabboTrackingBootstrap extends HabboTracking 
    {

        public function HabboTrackingBootstrap(context:IContext, flags:uint=0, assetLibrary:IAssetLibrary=null)
        {
            super(context, flags, assetLibrary);
        }

    }
}