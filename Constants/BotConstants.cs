using System;
using System.Collections.Generic;
using System.Text;

namespace ExpressBase.Common.Constants
{
	public static class BotConstants
	{
		public const string BOT_HEADER_PART = @"
align-items: center;
display: flex;
color: white;
padding: 10px 15px;
background-color: var( --ebbotThemeColor );";
		public const string BOT_HEADER_ICON_CONT = @"
width: 35px;
height: 35px;
border-radius: 50%;
display: flex;
float: left;";
		public const string BOT_HEADER_IMAGE = @"
border-radius: 50%;
height: 100%;
width: 100%;";

		public const string BOT_APP_NAME = @"
font-family: arial;
font-size: 20px;
display: inline-block;
margin-left: 10px;
margin-top: 10px;";
		public const string BOT_HEADERSUBTEXT = @"
font-family: arial;
font-size: 10px;
display: flex;";

		public const string BOT_IFRAME_CSS = @"
right: 0.8%;
bottom: 1.5%;
width: 28%;
height: 97%;
min-width: 300px;
box-shadow: 0 12px 40px 0 rgba(0, 0, 0, .175);
flex-direction: column;
position: fixed;
transition: 0.4s;
overflow: hidden;
border-radius: 2px;
background-color: white;
border-radius: 20px;";

		public const string BOT_CHAT_BUTTON = @"right: 24px;
bottom: 15px;
color: #fff;
padding: 12px;
border-radius: 50%;
box-shadow: 2px 2px 5px 1px rgba(0, 0, 0, 0.39);
position: fixed;
background-color: var( --ebbotThemeColor );
Float: right;";

		public const string BOT_IMAGE_CONT = @"
width: 50px;
height: 50px;
border-radius: 50%;
display: flex;
align-items: center;
justify-content: center;";

		public const string BOT_BUTTON_IMAGE = @"
border-radius: 50%;
height:100%;
width: 100%;";
	
	public const string BOT_CLOSE_BUTTON = @"
display: inline-block;
float: right;
font-size: 1.2em;
padding: 0px 5px;
margin: 10px 0px;
cursor: pointer;";

	public const string BOT_MAXIMIZE_BUTTON = @"
margin-left: auto !important;
display: inline-block;
float: right;
font-size: 1.2em;
padding: 0px 5px;
margin: 8px 3px;
cursor: pointer;";
	}
}
