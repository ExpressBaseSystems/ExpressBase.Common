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
        <div id='cont_@ebsid@' ebsid='@ebsid@' name='@name@' class='Eb-ctrlContainer' @childOf@ ctype='@type@' eb-hidden='@isHidden@' eb-readonly='@isReadonly@'>
            <span class='eb-ctrl-label eb-label-editable'>
                <span ui-label id='@ebsid@Lbl'>@Label@</span>
                <div id='@ebsid@Lblic' tabindex='-1' class='label-infoCont'></div>
            </span>
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

    public static class JSFnsConstants
    {

        public const string EbSimpleSelect_GetValueFromDOMJSfn = @"
let val = $('#' + this.EbSid_CtxId).selectpicker('val');
val = (val === null) ? '-1' : val.toString();
if(!this.MultiSelect)    
    val = string2EBType(val, this.EbDbType);
if (ebcontext.renderContext === 'WebForm' && val.toString() === '-1')
    val = null;
return val;";

        public const string PS_SetDisplayMemberJSfn = @"
if(this.RenderAsSimpleSelect){"
    + EbSimpleSelect_JustSetValueJSfn +
@"}
else{                        
    EBPSSetDisplayMember.bind(this)(p1, p2);
}";

        public const string SS_SetValueJSfn = EbSimpleSelect_JustSetValueJSfn + " $('#' + this.EbSid_CtxId).trigger('change');";

        public const string DG_hiddenColCheckCode = @"
if(this.Hidden){
    if(this.__isEditing)
        this.curRowDataVals.Value = p1;
    else
        this.DataVals.Value = p1;
}
else ";

        public const string SS_EnableJSfn = @"this.__IsDisable = false; return $('#' + this.EbSid_CtxId +'Wraper .dropdown-toggle').prop('disabled',false).css('pointer-events', 'inherit').css('background-color', '#fff');";

        public const string SS_DisableJSfn = @"this.__IsDisable = true; return $('#' + this.EbSid_CtxId +'Wraper .dropdown-toggle').attr('disabled', 'disabled').css('pointer-events', 'none').css('background-color', '#f3f3f3');";

        public const string SS_IsRequiredOKJSfn = @" let val = this.getValue(); return !this.isInVisibleInUI ? (!isNaNOrEmpty(val) && (val !== '-1') && (val !== null)) : true;";

        public const string SS_GetDisplayMemberJSfn = @"return $('#' + this.EbSid_CtxId +' :selected').text();";

        public const string PS_DisableJSfn = @"
this.__IsDisable = true;
$('#cont_' + this.EbSid_CtxId).attr('eb-readonly','true').find('.ctrl-cover').attr('eb-readonly','true');
$('#cont_' + this.EbSid_CtxId + ' *').attr('disabled', 'disabled').css('pointer-events', 'none').find('[ui-inp]').css('background-color', '#f3f3f3');
$('#cont_' + this.EbSid_CtxId + ' .ctrl-cover .input-group-addon').css('background-color', '#f3f3f3');";



        public const string PS_in_EnableJSfn = @"
this.__IsDisable = false;
$('#cont_' + this.EbSid_CtxId).attr('eb-readonly','false').find('.ctrl-cover').attr('eb-readonly','false');
$('#cont_' + this.EbSid_CtxId + ' *').prop('disabled',false).css('pointer-events', 'inherit').find('[ui-inp]').css('background-color', '#fff');
$('#cont_' + this.EbSid_CtxId + ' .ctrl-cover .input-group-addon').css('background-color', 'inherit');";

        public const string Ctrl_DisableJSfn = @"this.__IsDisable = true; $('#cont_' + this.EbSid_CtxId + ' *').attr('disabled', 'disabled').css('pointer-events', 'none').find('[ui-inp]').css('background-color', '#f3f3f3');$('#cont_' + this.EbSid_CtxId + ' .ctrl-cover .input-group-addon').css('background-color', '#f3f3f3');";

        public const string Ctrl_EnableJSfn = @"this.__IsDisable = false; $('#cont_' + this.EbSid_CtxId + ' *').prop('disabled',false).css('pointer-events', 'inherit').find('[ui-inp]').css('background-color', '#fff');$('#cont_' + this.EbSid_CtxId + ' .ctrl-cover .input-group-addon').css('background-color', 'inherit');";

        public const string Ctrl_IsRequiredOKJSfn = @"let val = this.getValue(); return !this.isInVisibleInUI ? (!isNaNOrEmpty(val) && val !== null && val !== 0): true;";

        public const string PS_JustSetValueJSfn = @"
{
    this.___isNotUpdateValExpDepCtrls = true;"
    + PS_SetValueJSfn +
"}";

        public const string PS_SetValueJSfn = @"
                    if(this.RenderAsSimpleSelect){"
                        + JSFnsConstants.SS_SetValueJSfn +
                    @"}
                    else{
                        this.initializer.setValues(p1, p2);
                    }
                ";

        public const string PS_GetDisplayMemberJSfn = @"
                    if(this.RenderAsSimpleSelect){"
                        + JSFnsConstants.SS_GetDisplayMemberJSfn +
                    @"}
                    else{"
                        + @" 
                         return this.initializer.getDisplayMemberModel();
" +
                    @"}
                ";

        public const string PS_EnableJSfn = @"
this.__IsDisable = false; 
if(this.RenderAsSimpleSelect){"
    + SS_EnableJSfn +
@"}
else{"
    + PS_in_EnableJSfn +
@"}";

        public const string EbSimpleSelect_JustSetValueJSfn = @"
{
    if(p1 === null)
        p1 = -1;
    isContained = false;
if(this.MultiSelect){
    if(p1 === -1)
        p1 = p1.toString();
    p1 = p1.split(',');
}
    $('#' + this.EbSid_CtxId + ' option').each(function (i, opt) {
        if ($(opt).attr('value') == p1 || (this.MultiSelect && p1.contains($(opt).attr('value')))) {
            isContained = true;
            return false;
        }
    }.bind(this));
    if(!isContained)
        return;
    $('#' + this.EbSid_CtxId).selectpicker('val', p1)
}";

        public const string CB_JustSetValueJSfn = @"$('#' + this.EbSid_CtxId).prop('checked', p1 === true);";

        //        public const string EbSimpleSelect_SetValueJSfn = @"
        //if(p1 === null)
        //    p1 = -1;
        //isContained = false;
        //if(this.MultiSelect) p1 = p1.split(',');
        //$('#' + this.EbSid_CtxId + ' option').each(function (i, opt) {
        //    if ($(opt).attr('value') == p1 || (this.MultiSelect && p1.contains($(opt).attr('value')))) {
        //        isContained = true;
        //        return false;
        //    }
        //}.bind(this));

        //if(!isContained)
        //    return;
        //$('#' + this.EbSid_CtxId).selectpicker('val', p1);
        //";
    }
}