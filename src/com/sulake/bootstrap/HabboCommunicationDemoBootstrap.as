package com.sulake.bootstrap
{
    import com.sulake.habbo.communication.demo.HabboCommunicationDemo;
    import com.sulake.core.runtime.IContext;
    import com.sulake.core.assets.IAssetLibrary;

    public class HabboCommunicationDemoBootstrap extends HabboCommunicationDemo 
    {

        public function HabboCommunicationDemoBootstrap(context:IContext, flags:uint=0, assetLibrary:IAssetLibrary=null)
        {
            super(context, flags, assetLibrary);
        }

    }
}