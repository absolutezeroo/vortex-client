package com.sulake.habbo.notifications.feed
{
    public class StateController 
    {

        private var _isEnabled:Boolean;
        private var _isGameMode:Boolean;
        private var _currentState:int = 0;
        private var _lastRequestedState:int = 1;

        private function isActive():Boolean
        {
            return ((_isEnabled) && (!(_isGameMode)));
        }

        public function setEnabled(_arg_1:Boolean):int
        {
            _isEnabled = _arg_1;

            if (!isActive())
            {
                return (requestState(0));
            };

            return (setVisible());
        }

        public function setGameMode(_arg_1:Boolean):int
        {
            _isGameMode = _arg_1;

            if (!isActive())
            {
                return (requestState(0));
            };

            return (setVisible());
        }

        public function currentState():int
        {
            return (_currentState);
        }

        public function requestState(_arg_1:int):int
        {
            if (!isActive())
            {
                _lastRequestedState = _arg_1;
                return (_currentState);
            };

            _currentState = _arg_1;
            _lastRequestedState = _arg_1;
            return (_currentState);
        }

        private function setVisible():int
        {
            var _local_1:int = _lastRequestedState;

            if (_local_1 == 0)
            {
                _local_1 = 1;
            };

            _currentState = _local_1;
            _lastRequestedState = _local_1;
            return (_local_1);
        }

    }
}
