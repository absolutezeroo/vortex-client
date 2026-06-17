package com.sulake.bootstrap
{
    import com.sulake.habbo.communication.HabboCommunicationManager;
    import com.sulake.core.runtime.IContext;
    import com.sulake.core.assets.IAssetLibrary;

    public class HabboCommunicationManagerBootstrap extends HabboCommunicationManager 
    {

        public function HabboCommunicationManagerBootstrap(context:IContext, flags:uint=0, assetLibrary:IAssetLibrary=null)
        {
            super(context, flags, assetLibrary);
        }

    }
}