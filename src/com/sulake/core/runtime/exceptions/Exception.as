package com.sulake.core.runtime.exceptions
{
    import flash.utils.getQualifiedClassName;

    public class Exception extends Error 
    {

        private var _cause:Error;

        public function Exception(message:String, id:int=0, cause:Error=null)
        {
            super(message, id);
            _cause = cause;
        }

        public static function getChainedStackTrace(error:Error):String
        {
            var _local_3:String;
            var _local_2:String;

            while (error != null)
            {
                _local_3 = error.getStackTrace();

                if (_local_3 != null)
                {
                    if (_local_2 == null)
                    {
                        _local_2 = _local_3;
                    }

                    else
                    {
                        _local_2 = (_local_2 + "\ncaused by ");
                        _local_2 = (_local_2 + _local_3);
                    };
                };

                if ((error is Exception))
                {
                    error = (error as Exception).cause;
                }

                else
                {
                    error = null;
                };
            };

            return (_local_2);
        }

        public function get cause():Error
        {
            return (_cause);
        }

        public function toString():String
        {
            var _local_1:String = ((getQualifiedClassName(this) + ": ") + super.message);

            if (_cause != null)
            {
                _local_1 = (_local_1 + ", caused by ");
                _local_1 = (_local_1 + _cause.toString());
            };

            return (_local_1);
        }

    }
}