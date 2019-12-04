using System;
using System.Collections.Generic;
using System.Text;

namespace ExpressBase.Common
{
    public static class HtmlConstants
    {
        public const string Label = @"";
        public const string CONT_PROP_BTN = @"<div class='cont-prop-btn' ctrl-ebsid='@ebsid@'><i class='fa fa-ellipsis-v' aria-hidden='true'></i></div>";
        public const string TOOL_HTML = @"
<div class='tool_item_head' data-toggle='collapse' data-target='#@id@'><i class='fa fa-caret-down'></i> @label@ </div>
    <div id='@id@' ebclass='tool-sec-cont' class='tool-sec-cont collapse in'>";

        public const string HelpText = @"";

        public const string CONTROL_WRAPER_HTML4WEB = @"
        <div id='cont_@ebsid@' ebsid='@ebsid@' name='@name@' class='Eb-ctrlContainer' @childOf@ ctype='@type@' eb-hidden='@isHidden@'>
            <span class='eb-ctrl-label eb-label-editable' ui-label id='@ebsidLbl'>@Label@</span>
            <input id='@ebsid@lbltxtb' class='eb-lbltxtb' type='text'/> @req@ 
                <div  id='@ebsid@Wraper' class='ctrl-cover' eb-readonly='@isReadonly@'>
                    @barehtml@
                </div>
            <span class='helpText' ui-helptxt>@helpText@ </span>
        </div>";

		public const string CONTROL_WRAPER_HTML4BOT = @"
			<div id='cont_@ebsid@' ebsid='@ebsid@' name='@name@' ctype='@type@' eb-type='@type@' class='Eb-ctrlContainer iw-mTrigger' >
			   <div class='msg-cont'>
				  <div class='bot-icon'></div>
				  <div class='msg-cont-bot'>
					 <div class='msg-wraper-bot'>
						@Label@
						<div class='msg-time'>3:44pm</div>
					 </div>
				  </div>
			   </div>
			   <div class='msg-cont' >
				  <div class='msg-cont-bot'>
					 <div class='msg-wraper-bot' style='border: none; background-color: transparent; width: 99%; padding-right: 3px;'>
						<div class='chat-ctrl-cont'>
						   <div class='ctrl-wraper'>
								@barehtml@
						   </div>
						</div>
					 </div>
				  </div>
			   </div>
			</div>";
	}
}
