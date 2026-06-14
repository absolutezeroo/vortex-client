package
{
    import flash.net.LocalConnection;
    import flash.display.Sprite;
    import flash.utils.ByteArray;

    public class DomainValidator
    {
        private var _encryptedDomainsClass:Class;
        private var _encryptionKeyClass:Class;

        public function DomainValidator()
        {
            this._encryptedDomainsClass = _SafeStr_5;
            this._encryptionKeyClass = _SafeStr_4;
            super();
        }

        public function validate(host:Sprite):Boolean
        {
            var allowLocalhost:Boolean = false;
            var allowAny:Boolean = false;
            var domain:String = null;
            var urlPrefixes:Array = [];
            var domainPattern:String = "";
            var loaderUrl:String = host.loaderInfo.loaderURL;
            var localDomain:String = new LocalConnection().domain;
            var allowedList:Array = this.getAllowedDomains().split("|");
            var i:int = 0;

            while (i < allowedList.length)
            {
                domain = (allowedList[i] as String).toLocaleLowerCase();

                if (domain == "?")
                {
                    allowAny = true;
                }

                else if (domain.indexOf("localhost") != -1)
                {
                    allowLocalhost = true;
                }

                else if (domain.indexOf("http:") == 0 || domain.indexOf("https:") == 0)
                {
                    urlPrefixes.push(domain);
                }

                else
                {
                    if (domainPattern != "")
                    {
                        domainPattern += "|";
                    }

                    if (domain.indexOf("*.") == 0)
                    {
                        domain = domain.replace("*.","((\\w|-|_)+\\.)*");
                    }

                    domainPattern += domain;
                }

                i++;
            }

            var domainRegex:RegExp = new RegExp("^http(|s)://((www)+\\.)*(" + domainPattern + ")","i");

            if (localDomain.toLowerCase() == "localhost")
            {
                if (allowLocalhost)
                {
                    return true;
                }

                if (allowAny)
                {
                    host.width = 0;
                    host.height = 0;
                    return false;
                }
            }

            if (domainRegex.test(loaderUrl))
            {
                return true;
            }

            var j:int = 0;

            while(j < urlPrefixes.length)
            {
                if (loaderUrl.indexOf(urlPrefixes[j]) == 0)
                {
                return true;
                }

                j++;
            }

            if (domainPattern.length == 0 && urlPrefixes.length == 0 && allowAny)
            {
                return true;
            }

            //  host.width = 0;
            //  host.height = 0;
            return true;
        }

        private function getAllowedDomains():String
        {
            var data:ByteArray = new this._encryptedDomainsClass() as ByteArray;
            var cipher:RC4 = new RC4(new this._encryptionKeyClass() as ByteArray);
            cipher._SafeStr_248(data);
            data.position = 0;
            return data.readUTFBytes(data.length);
        }
    }
}
