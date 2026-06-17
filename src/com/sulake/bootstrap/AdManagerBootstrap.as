package com.sulake.bootstrap
{
    import com.sulake.habbo.advertisement.AdManager;
    import com.sulake.core.runtime.IContext;
    import com.sulake.core.assets.IAssetLibrary;

    public class AdManagerBootstrap extends AdManager 
    {

        public function AdManagerBootstrap(context:IContext, flags:uint=0, assetLibrary:IAssetLibrary=null)
        {
            super(context, flags, assetLibrary);
        }

    }
}
