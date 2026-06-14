package com.sulake.core.runtime
{
    public class ComponentDependency 
    {

        private var _identifier:IID;
        private var _dependencySetter:Function;
        private var _isRequired:Boolean;
        private var _eventListeners:Array;

        public function ComponentDependency(identifier:IID, dependecySetter:Function, isRequired:Boolean=true, eventListeners:Array=null)
        {
            _identifier = identifier;
            _dependencySetter = dependecySetter;
            _isRequired = isRequired;
            _eventListeners = eventListeners;
        }

        internal function get identifier():IID
        {
            return (_identifier);
        }

        internal function get dependencySetter():Function
        {
            return (_dependencySetter);
        }

        internal function get isRequired():Boolean
        {
            return (_isRequired);
        }

        internal function get eventListeners():Array
        {
            return (_eventListeners);
        }

    }
}