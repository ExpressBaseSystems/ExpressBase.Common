﻿using System;
using System.Collections.Generic;
using System.Text;

namespace ExpressBase.Common
{
    public static class HtmlConstants
    {
        public const string Label = @"";
        public const string TOOL_HTML = @"
<div class='tool_item_head' data-toggle='collapse' data-target='#@id@'><i class='fa fa-caret-down'></i> @label@ </div>
    <div id='@id@' ebclass='tool-sec-cont' class='tool-sec-cont collapse in'>";

        public const string HelpText = @"";

        public const string CONTROL_WRAPER_HTML4WEB = @"
        <div id='cont_@ebsid@' ebsid='@ebsid@' name='@name@' class='Eb-ctrlContainer' @childOf@ ctype='@type@' eb-hidden='@isHidden@'>
            <span class='eb-ctrl-label' ui-label id='@ebsidLbl'>@Label@ </span> @req@ 
                <div  id='@ebsid@Wraper' class='ctrl-cover'>
                    @barehtml@
                </div>
            <span class='helpText' ui-helptxt >@helpText@ </span>
        </div>";
    }
}