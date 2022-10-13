FoxitInvoke(command, FoxitID:="") {		                                                         			;-- wm_command wrapper for FoxitReader Version:  9.1
	static FoxitCommand:= [], run:=0

	If !run {
		split:=[]
		FoxitCommands =
		(Comments
			SaveAs                                                             	: 1299
			Close                                                               	: 57602
			Hand                                                                	: 1348       	;Home - Tools
			Select_Text                                                       	: 46178     	;Home - Tools
			Select_Annotation                                              	: 46017     	;Home - Tools
			Snapshot                                                         	: 46069     	;Home - Tools
			Clipboard_SelectAll                                            	: 57642     	;Home - Tools
			Clipboard_Copy                                               	: 57634     	;Home - Tools
			Clipboard_Paste                                                 	: 57637     	;Home - Tools
			Actual_Size                                                      	: 1332       	;Home - View
			Fit_Page                                                           	: 1343       	;Home - View
			Fit_Width                                                         	: 1345        	;Home - View
			Reflow                                                             	: 32818     	;Home - View
			Zoom_Field                                                      	: 1363       	;Home - View
			Zoom_Plus                                                       	: 1360       	;Home - View
			Zoom_Minus                                                   	: 1362       	;Home - View
			Rotate_Left                                                      	: 1340       	;Home - View
			Rotate_Right                                                    	: 1337       	;Home - View
			Highlight                                                         	: 46130     	;Home - Comment
			Typewriter                                                        	: 46096     	;Home - Comment, Comment - TypeWriter
			Open_From_File                                                 	: 46140     	;Home - Create
			Open_Blank                                                     	: 46141     	;Home - Create
			Open_From_Scanner                                          	: 46165     	;Home - Create
			Open_From_Clipboard                                       	: 46142     	;Home - Create - new pdf from clipboard
			PDF_Sign                                                          	: 46157     	;Home - Protect
			Create_Link                                                         	: 46080     	;Home - Links
			Create_Bookmark                                               	: 46070     	;Home - Links
			File_Attachment                                               	: 46094     	;Home - Insert
			Image_Annotation                                              	: 46081     	;Home - Insert
			Audio_and_Video                                              	: 46082     	;Home - Insert
			Comments_Import                                          	: 46083     	;Comments
			Highlight                                                         	: 46130     	;Comments - Text Markup
			Squiggly_Underline                                          	: 46131     	;Comments - Text Markup
			Underline                                                         	: 46132     	;Comments - Text Markup
			Strikeout                                                          	: 46133     	;Comments - Text Markup
			Replace_Text                                                      	: 46134     	;Comments - Text Markup
			Insert_Text                                                       	: 46135     	;Comments - Text Markup
			Note                                                                	: 46137     	;Comments - Pin
	    	File                                                                   	: 46095     	;Comments - Pin
	    	Callout                                                                	: 46097     	;Comments - Typewriter
	    	Textbox                                                              	: 46098     	;Comments - Typewriter
	    	Rectangle                                                           	: 46101     	;Comments - Drawing
	    	Oval                                                                 	: 46102     	;Comments - Drawing
	    	Polygon                                                           	: 46103     	;Comments - Drawing
	    	Cloud                                                               	: 46104     	;Comments - Drawing
	    	Arrow                                                               	: 46105     	;Comments - Drawing
	    	Line                                                                  	: 46106     	;Comments - Drawing
	    	Polyline                                                            	: 46107     	;Comments - Drawing
	    	Pencil                                                               	: 46108     	;Comments - Drawing
	    	Eraser                                                               	: 46109     	;Comments - Drawing
	    	Area_Highligt                                                     	: 46136     	;Comments - Drawing
	    	Distance                                                          	: 46110     	;Comments - Measure
	    	Perimeter                                                          	: 46111     	;Comments - Measure
	    	Area                                                                 	: 46112     	;Comments - Measure
	    	Stamp				                                                	: 46149     	;Comments - Stamps , opens only the dialog
	    	Create_custom_stamp                                        	: 46151     	;Comments - Stamps
	    	Create_custom_dynamic_stamp                         	: 46152     	;Comments - Stamps
	    	Summarize_Comments                                   	: 46188     	;Comments - Manage Comments
	    	Import                                                              	: 46083     	;Comments - Manage Comments
	    	Export_All_Comments                                      	: 46086     	;Comments - Manage Comments
	    	Export_Highlighted_Texts                                   	: 46087     	;Comments - Manage Comments
	    	FDF_via_Email                                                   	: 46084     	;Comments - Manage Comments
	    	Comments                                                       	: 46088     	;Comments - Manage Comments
	    	Comments_Show_All                                        	: 46089     	;Comments - Manage Comments
	    	Comments_Hide_All                                        	: 46090     	;Comments - Manage Comments
	    	Popup_Notes                                                    	: 46091     	;Comments - Manage Comments
	    	Popup_Notes_Open_All                                    	: 46092     	;Comments - Manage Comments
	    	Popup_Notes_Close_All                                    	: 46093     	;Comments - Manage Comments
			firstPage                                                          	: 1286       	;View - Go To
			lastPage                                                           	: 1288       	;View - Go To
        	nextPage                                                         	: 1289       	;View - Go To
        	previousPage                                                   	: 1290       	;View - Go To
        	previousView                                                   	: 1335       	;View - Go To
        	nextView                                                          	: 1346       	;View - Go To
        	ReadMode                                                       	: 1351       	;View - Document Views
        	ReverseView                                                    	: 1353       	;View - Document Views
        	TextViewer                                                       	: 46180     	;View - Document Views
        	Reflow                                                             	: 32818     	;View - Document Views
        	turnPage_left                                                   	: 1340       	;View - Page Display
        	turnPage_right                                                 	: 1337       	;View - Page Display
        	SinglePage                                                      	: 1357       	;View - Page Display
        	Continuous                                                      	: 1338       	;View - Page Display
        	Facing                                                              	: 1356       	;View - Page Display - two pages side by side
        	Continuous_Facing                                           	: 1339       	;View - Page Display - two pages side by side with scrolling enabled
        	Separate_CoverPage                                         	: 1341       	;View - Page Display
        	Horizontally_Split                                              	: 1364       	;View - Page Display
        	Vertically_Split                                                  	: 1365       	;View - Page Display
        	Spreadsheet_Split                                             	: 1368       	;View - Page Display
        	Guides                                                             	: 1354       	;View - Page Display
        	Rulers                                                              	: 1355       	;View - Page Display
        	LineWeights                                                    	: 1350       	;View - Page Display
        	AutoScroll                                                        	: 1334       	;View - Assistant
        	Marquee                                                          	: 1361       	;View - Assistant
        	Loupe                                                              	: 46138     	;View - Assistant
        	Magnifier                                                         	: 46139     	;View - Assistant
        	Read_Activate                                                  	: 46198     	;View - Read
        	Read_CurrentPage                                           	: 46199     	;View - Read
        	Read_from_CurrentPage                                  	: 46200     	;View - Read
        	Read_Stop                                                       	: 46201     	;View - Read
        	Read_Pause                                                     	: 46206     	;View - Read
			Navigation_Panels                                           	: 46010      	;View - View Setting
			Navigation_Bookmark                                     	: 45401      	;View - View Setting
			Navigation_Pages                                            	: 45402     	;View - View Setting
			Navigation_Layers                                           	: 45403     	;View - View Setting
			Navigation_Comments                                    	: 45404     	;View - View Setting
			Navigation_Appends                                       	: 45405     	;View - View Setting
			Navigation_Security                                        	: 45406     	;View - View Setting
			Navigation_Signatures                                    	: 45408     	;View - View Setting
			Navigation_WinOff                                          	: 1318       	;View - View Setting
			Navigation_ResetAllWins                                	: 1316       	;View - View Setting
			Status_Bar                                                        	: 46008       	;View - View Setting
			Status_Show                                                    	: 1358       	;View - View Setting
			Status_Auto_Hide                                               	: 1333       	;View - View Setting
			Status_Hide                                                     	: 1349       	;View - View Setting
			WordCount                                                     	: 46179     	;View - Review
			Form_to_sheet                                                    	: 46072     	;Form - Form Data
			Combine_Forms_to_a_sheet                            	: 46074     	;Form - Form Data
			DocuSign                                                            	: 46189     	;Protect
			Login_to_DocuSign                                           	: 46190     	;Protect
			Sign_with_DocuSign                                          	: 46191     	;Protect
			Send_via_DocuSign                                          	: 46192     	;Protect
			Sign_and_Certify                                              	: 46181     	;Protect
			Place_Signature1                                              	: 46182     	;Protect
			Place_Signature2                                              	: 46183     	;Protect
			Validate                                                            	: 46185     	;Protect
			Time_Stamp_Document                                    	: 46184     	;Protect
			Digital_IDs                                                        	: 46186     	;Protect
			Trusted_Certificates                                            	: 46187     	;Protect
			Email                                                                 	: 1296       	;Share - Send To - same like Email current tab
			Email_All_Open_Tabs                                       	: 46012       	;Share - Send To
			Tracker                                                               	: 46207       	;Share - Tracker
			User_Manual                                                      	: 1277       	;Help - Help
			Help_Center                                                     	: 558        	;Help - Help
			Command_Line_Help                                         	: 32768        	;Help - Help
			Post_Your_Idea                                                  	: 1279        	;Help - Help
			Check_for_Updates                                            	: 46209        	;Help - Product
			Install_Update                                                    	: 46210        	;Help - Product
			Set_to_Default_Reader                                    	: 32770        	;Help - Product
			Foxit_Plug-Ins                                                    	: 1312        	;Help - Product
			About_Foxit_Reader                                           	: 57664        	;Help - Product
			Register                                                           	: 1280        	;Help - Register
			Open_from_Foxit_Drive                                   	: 1024        	;Extras - maybe this is not correct!
			Add_to_Foxit_Drive                                           	: 1025        	;Extras - maybe this is not correct!
			Delete_from_Foxit_Drive                                    	: 1026        	;Extras - maybe this is not correct!
			Options                                                           	: 243           	;the following one's are to set directly any options
			Use_single-key_accelerators_to_access_tools 	: 128           	;Options/General
			Use_fixed_resolution_for_snapshots                	: 126           	;Options/General
			Create_links_from_URLs                                   	: 133           	;Options/General
			Minimize_to_system_tray                                 	: 138           	;Options/General
			Screen_word-capturing                                    	: 127           	;Options/General
			Make_Hand_Tool_select_text                          	: 129           	;Options/General
			Double-click_to_close_a_tab                           	: 91             	;Options/General
			Auto-hide_status_bar                                      	: 162           	;Options/General
			Show_scroll_lock_button                                 	: 89             	;Options/General
			Automatically_expand_notification_message  	: 1725          	;Options/General - only 1 can be set from these 3
			Dont_automatically_expand_notification        	: 1726          	;Options/General - only 1 can be set from these 3
			Dont_show_notification_messages_again     		: 1727          	;Options/General - only 1 can be set from these 3
			Collect_data_to_improve_user_&experience   	: 111           	;Options/General
			Disable_all_features_which_require_internet 		: 562           	;Options/General
			Show_Start_Page                                             	: 160           	;Options/General
			Change_Skin                                                    	: 46004
			Filter_Options                                                  	: 46167        	;the following are searchfilter options
			Whole_words_only                                          	: 46168        	;searchfilter option
			Case-Sensitive                                                 	: 46169        	;searchfilter option
			Include_Bookmarks                                         	: 46170        	;searchfilter option
			Include_Comments                                          	: 46171        	;searchfilter option
			Include_Form_Data                                          	: 46172        	;searchfilter option
			Highlight_All_Text                                           	: 46173        	;searchfilter option
			Filter_Properties                                              	: 46174        	;searchfilter option
			Print                                                                 	: 57607
			Properties                                                        	: 1302          	;opens the PDF file properties dialog
			Mouse_Mode                                                  	: 1311
			Touch_Mode                                                   	: 1174
			predifined_Text                                               	: 46099
			set_predefined_Text                                        	: 46100
			Create_Signature                                             	: 26885     	;Signature
			Draw_Signature                                               	: 26902     	;Signature
			Import_Signature                                            	: 26886     	;Signature
			Paste_Signature                                               	: 26884     	;Signature
			Type_Signature                                                	: 27005     	;Signature
			Pdf_Sign_Close                                                	: 46164     	;Pdf-Sign
		)

		FoxitCommands:= StrReplace(FoxitCommands, A_Space, "")

		Loop, Parse, FoxitCommands, `n
		{
				line:= RegExReplace(A_LoopField, ";.*", "")
				split:= StrSplit(line, ":")
				key:= Trim(split[1])
				value:= Trim(split[2])
				FoxitCommand[key]:= value
		}

		run=1

	}

	If FoxitID {
		SendMessage, 0x111, % FoxitCommand[command],,, ahk_id %FoxitID%
		return ErrorLevel
	} else {
		return FoxitCommand[command]
	}