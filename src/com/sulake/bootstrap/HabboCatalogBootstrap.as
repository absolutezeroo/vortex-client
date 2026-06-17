package com.sulake.bootstrap
{
    import com.sulake.habbo.catalog.HabboCatalog;
    import com.sulake.core.runtime.IContext;
    import com.sulake.core.assets.IAssetLibrary;

    public class HabboCatalogBootstrap extends HabboCatalog 
    {

        public function HabboCatalogBootstrap(context:IContext, flags:uint=0, assetLibrary:IAssetLibrary=null)
        {
            super(context, flags, assetLibrary);
        }

    }
}