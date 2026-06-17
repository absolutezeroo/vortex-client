package com.sulake.bootstrap
{
    import com.sulake.habbo.freeflowchat.HabboFreeFlowChat;
    import com.sulake.core.runtime.IContext;
    import com.sulake.core.assets.IAssetLibrary;

    public class HabboFreeFlowChatBootstrap extends HabboFreeFlowChat 
    {

        public function HabboFreeFlowChatBootstrap(context:IContext, flags:uint, assetLibrary:IAssetLibrary)
        {
            super(context, flags, assetLibrary);
        }

    }
}