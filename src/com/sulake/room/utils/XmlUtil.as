package com.sulake.room.utils
{
    public class XmlUtil
    {

        public static function checkRequiredAttributes(xmlOrList:Object, requiredAttributes:Array):Boolean
        {
            var sourceXml:XML;
            var sourceXmlList:XMLList;

            if (((xmlOrList == null) || (requiredAttributes == null)))
            {
                return (false);
            }

            var index:int;

            if ((xmlOrList is XML))
            {
                sourceXml = (xmlOrList as XML);
                index = 0;

                while (index < requiredAttributes.length)
                {
                    if (sourceXml.attribute(requiredAttributes[index]).length() == 0)
                    {
                        return (false);
                    }

                    index++;
                }
            }
            else
            {
                if ((xmlOrList is XMLList))
                {
                    sourceXmlList = (xmlOrList as XMLList);
                    index = 0;

                    while (index < requiredAttributes.length)
                    {
                        if (sourceXmlList.attribute(requiredAttributes[index]).length() == 0)
                        {
                            return (false);
                        }

                        index++;
                    }
                }
                else
                {
                    return (false);
                }
            }

            return (true);
        }

    }
}
