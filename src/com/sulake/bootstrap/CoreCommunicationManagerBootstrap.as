package com.sulake.bootstrap
{
    import com.sulake.core.communication.CoreCommunicationManager;
    import com.sulake.core.runtime.IContext;

    public class CoreCommunicationManagerBootstrap extends CoreCommunicationManager 
    {

        public function CoreCommunicationManagerBootstrap(context:IContext, flags:uint=0)
        {
            super(context, flags);
        }

    }
}