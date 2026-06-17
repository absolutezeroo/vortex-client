package com.sulake.bootstrap
{
    import com.sulake.habbo.quest.HabboQuestEngine;
    import com.sulake.core.runtime.IContext;
    import com.sulake.core.assets.IAssetLibrary;

    public class HabboQuestEngineBootstrap extends HabboQuestEngine 
    {

        public function HabboQuestEngineBootstrap(context:IContext, flags:uint=0, assetLibrary:IAssetLibrary=null)
        {
            super(context, flags, assetLibrary);
        }

    }
}