extends Control

var player_score = 0

# background control
onready var background = $Background
var bg_texture = [
	# scene 1 buildup (0)
	null,
	load("res://.import/Scene 1-1.png-3dbaadc529479280440cbf70503aa421.stex"),
	load("res://.import/Scene 1-2.png-5da1eb8316e82f9faf23f9ccd39985b2.stex"),
	# scene 1 game (3)
	null,
	null,
	
	# scene 2 buildup (5)
	load("res://Background/Friend Group A BG.png"),
	load("res://Background/Friend Holding Phone BG.png"),
	load("res://.import/Scene 2-3 App Store.png-d1b6abca9ee9948027752353a0740122.stex"),
	load("res://.import/Scene 2-4 App Installation Page.png-247e8ebc25238e1a2b18ef92692002e2.stex"),
	
	# scene 2 game (9)
	load("res://.import/Scene 2-4 App Installation Page.png-247e8ebc25238e1a2b18ef92692002e2.stex"),
	load("res://.import/Scene 2-6 App Installed Page.png-9a47733253fff1536c08594ed0f07c0a.stex"),
	load("res://Background/Scene 2 Welcome to Social Media new.png"),
	
	# scene 3 game (11)
	load("res://Background/Scene 3 Welcome to Social Media new.png"),

	# scene 4 (13)
	load("res://Background/Friend Holding Phone BG.png"),
	load("res://Background/Scene 4 Gallery.png"),
	
	# scene 5 (15)
	load("res://Background/Scene 4 Gallery.png"),
	null,
	
	# scene 6
	
	# scene 7 (17)
	null,
	
	# scene 8 (18)
	load("res://Background/Scene 8 Notif.png"),
	null,
	
	# scene 9 (20)
	null,
	
	# scene 10 (21)
	null,
	null,
	load("res://Background/crowd.png"),
	load("res://Background/Scene 9 Addtl Settingspng.png"),
	
	# scene end (25)
	load("res://Background/End_Background.png")
	
]

# selected pic in scene 5
var selected_pic = 1 #  0 = pic A ; 1 = pic B
	
var bg_next = 0
var on_review = 0

# SET the starting scene for debug (0-indexed)
var init_scene = 0

# STORE player-choices
var collated_player_choices = {}

# STORE score deductions
var player_incorrects = []

# MAP of starting SCENE to background
var scene_to_bg = [0,5,11,12,15, 17, 17, 18, 21, 22, 25]

# MAP of scene timeline to corresponding function
var tl_to_end = {
	"/Scene1/WakingUp": "after_dialog",
	"/Scene2/2_Birthday": "scene2_2",
	"/Scene3/3_Username": "scene3_game",
	"/Scene4/4_TryApp": "scene4_1",
	"/Scene5/5_ChoosePicture": "scene5_1",
	"/Scene6/6_Guide": "scene6_1",
	"/Scene7/7_AdvancedSetting": "scene7_1",
	"/Scene8/8_Message": "scene8_1",
	"/Scene9/9_Start": "scene_9",
	"/Scene10/10_Notif": "scene10_1", 
	"/EndScene/Congrats": "end_scene_1",
}

# object Phone control
onready var phone = $Phone
var phone_texture = [
	load("res://.import/Scene 1-3 Phone Calendar Notification.png-a914fb709987c5630a087dad7dac6ca7.stex"),
	load("res://.import/Scene 1-4 Phone Link to Invitation Form.png-cb5646992d334d8c198611ed4f66c0a1.stex")
]

onready var formbutton = $Phone/FormButton
onready var app_store = $AppStore
onready var acc_aet = $AppStore/Access_AET
onready var acc_awaiu = $AppStore/Access_AWAIU
onready var acc_aa = $AppStore/Access_AA
onready var installButton = $AppStore/InstallButton
onready var permission = $AppStore/Permission
onready var userForm = $UsernameForm
onready var username = $UsernameForm/Username
onready var advSettings = $AdvancedSettings
onready var noLocData = $AdvancedSettings/NoLocationData
onready var locButton = $AdvancedSettings/LocationButton
onready var visibOpt = $AdvancedSettings/VisibilityOption
onready var phoneNotif = $PhoneNotif
onready var playerIcon = $PlayerIcon
onready var tagSetting = $TagSetting
onready var finScore = $FinalScore


var s2_butt_ind = 0

var perm_ind = 0
var permission_textures = [
	"res://Objects/Permission Location Services.png",
	"res://Objects/Permission Contacts.png",
	"res://Objects/Permission Camera.png",
	"res://Objects/Permission Microphone.png",
	"res://Objects/Permission Notifications.png"
]

var permission_settings = [
	0,
	0,
	0,
	0,
	0
]

# HELPER class for Button settings
class ButtonOpts:
	func _init(pos, size, icon):
		self.pos = pos
		self.size = size
		self.icon = icon
	var pos: Vector2
	var size: Vector2
	var icon: Resource

# I

# button position, size and icon
var s2_but_opts = [
	ButtonOpts.new(
		Vector2(370.656,-374.101),
		Vector2(246,65),
		load("res://.import/Install Button.png-88575df618f217c3a27fe4455e67d630.stex")
	),
	ButtonOpts.new(
		Vector2(154.44,-100.719),
		Vector2(268,72),
		load("res://.import/Open Button.png-3346a4996b224bfee63e3413847d133b.stex")
	)
]

# helper function to show all children
func show_all(node):
	node.show()
	
	if node.get_child_count() == 0:
		return
		
	for child in node.get_children():
		show_all(child)
		
# helper function to hide all children
func hide_all(node):
	node.hide()
	
	if node.get_child_count() == 0:
		return
		
	for child in node.get_children():
		hide_all(child)

# initialize other objects
func init():
	# initialize textures
	for child in self.get_children():
		child.visible = false
		
	background.texture = null
	background.visible = true
	phone.texture = null
	
	acc_aa.disabled = true
	acc_aet.disabled = true
	acc_awaiu.disabled = true
	formbutton.disabled = true
	acc_aa.visible = false
	acc_aet.visible = false
	acc_awaiu.visible = false
	permission.visible = false
	
	installButton.disabled = true
	
	installButton.rect_size = s2_but_opts[s2_butt_ind].size
	installButton.rect_position = s2_but_opts[s2_butt_ind].pos
	installButton.icon = s2_but_opts[s2_butt_ind].icon
	
# INIT permission attributes
func change_permission_texture(ind):
	permission.texture = load(permission_textures[ind])

# HELPER change scene
func change_scene(scene):
	# get timeline from scene no.
	var tl_key = tl_to_end.keys()[scene]
	print(tl_key, tl_to_end[tl_key])
	
	var dialogue = Dialogic.start(tl_key)
	dialogue.connect("timeline_end", self, tl_to_end[tl_key])
	dialogue.connect("dialogic_signal", self, 'dl_sig')
	bg_next = scene_to_bg[scene]
	dl_sig('change_bg')
	add_child(dialogue)
	
# Called when the node enters the scene tree for the first time.
func _ready():
	init()
	
	change_scene(init_scene)
	

# HELPER change background
func dl_sig(argument):
	if (argument == 'tag_header'):		
		$ScoreBreakdown/scene4_header/scene4_label.text = "Privacy Risk: Tagging of Freinds"
		hide_all($ScoreBreakdown)
		show_all($ScoreBreakdown/scene4_header)
		$ScoreBreakdown.show()
	if (argument == 'show_tags'):
		if collated_player_choices[4]["GroupPic"] == "A":
			for child in $TagA/Pic.get_children():
				child.show()
		else:
			for child in $TagB/Pic.get_children():
				child.show()
	if (argument == 'change_perm'):
		if perm_ind == 4:
			return
		perm_ind += 1
		change_permission_texture(perm_ind)
		
	if (argument == 'change_bg'):
		background.visible = true
		background.texture = bg_texture[bg_next]
		bg_next+=1
		
		# Scene 1 Game
		if 4 <= bg_next && bg_next <= 5:
			phone.visible = true
			phone.texture = phone_texture[bg_next-4]
			if bg_next == 5:
				formbutton.visible = true
				formbutton.disabled = false
				
		# Scene 4 Taking Pictures
	
		# Scene 2 Game
		return

# SCENE 1 fxn
func after_dialog(_timeline_name):
	dl_sig('change_bg')

	var bfast = Dialogic.start("/Scene1/Breakfast")
	add_child(bfast)
	bfast.connect("timeline_end", self, 'scene1_2')

# SCENE 1 fxn	
func scene1_2(_timeline_name):
	dl_sig('change_bg')
	
	var tl = Dialogic.start("/Scene1/Phone")
	tl.connect("dialogic_signal", self, 'dl_sig')
	add_child(tl)

# SCENE 1 end fxn
# SCENE 1 assess
func _on_EventForm_hide():
	if(bg_next != 5) or (on_review):
		return
	phone.visible = false;
	
	collated_player_choices[0] = {}
	
	# Set username for scene 3
	var playername = Dialogic.get_variable("PlayerName")
	var playericon = Dialogic.get_variable("PlayerIcon")
	
	# SAVE scene 1
	collated_player_choices[0]["PlayerName"] = playername
	collated_player_choices[0]["PlayerIcon"] = playericon
	
	# player-related usernames
	username.add_item(playername)
	username.add_item(playername.split(" ")[0] + "123")
	
	# anonymous usernames
	username.add_item("AvidDreamer")
	username.add_item("ChickenJoyLover")
	
	print("Scene 1")
	print(var2str(collated_player_choices[0]))
	
	change_scene(1)

# SCENE 2 fxn
func scene2_2(_timeline_name):	
	app_store.visible = true
	installButton.visible = true
	installButton.disabled = false
	change_permission_texture(perm_ind)
	collated_player_choices[1] = [0, 0, 0, 0, 0]
	dl_sig("change_bg")

# SCENE 2 end
func _on_InstallButton_pressed():
	s2_butt_ind +=1
	
	if(s2_butt_ind == 2):
		app_store.texture = load("res://Background/Scene 3 Allow App Access to.png")
		app_store.scale = Vector2(0.85,0.85)
		permission.visible = true
		
		acc_aa.visible = true
		acc_aa.disabled = false
		acc_aet.visible = true
		acc_aet.disabled = false
		acc_awaiu.visible = true
		acc_awaiu.disabled = false
		
		installButton.visible = false
		installButton.disabled = true
		return
	
	dl_sig("change_bg")
	
	# set s2 button options
	installButton.rect_position = s2_but_opts[s2_butt_ind].pos
	installButton.rect_size = s2_but_opts[s2_butt_ind].size
	installButton.icon = s2_but_opts[s2_butt_ind].icon

var scene2_score = 0 # Permissions

# SCENE 2 GAME
# SCENE 2 assess
func nextPermission(opt):
	if (opt != 1) and (player_incorrects.find(1) == -1):
		player_incorrects.append(1)
	
	player_score+= opt
	scene2_score += opt
	
	# end of scene 2 game
	if(perm_ind == 4):
		print("Scene 2")
		print(var2str(collated_player_choices[1]))
		app_store.visible = false
		change_scene(2)
		return
	
	
	perm_ind+= 1
	change_permission_texture(perm_ind)
	
	
func _on_Access_AA_pressed():
	permission_settings[perm_ind] = -1
	collated_player_choices[1][perm_ind] = -1
	nextPermission(-1)

func _on_Access_AWAIU_pressed():
	permission_settings[perm_ind] = 0
	collated_player_choices[1][perm_ind] = 0
	nextPermission(0)

func _on_Access_AET_pressed():
	permission_settings[perm_ind] = 1
	collated_player_choices[1][perm_ind] = 1
	nextPermission(1)

# SCENE 3 fxn
# SCENE 3 game
func scene3_game(_timeline_name):
	userForm.visible = true

var scene3_score = 0 # Username

# SCENE 3 end
# SCENE 3 assess
func _on_UsernameForm_hide():
		
	var selected = username.get_selected_id()
	
	collated_player_choices[2] = {
		"UsernameInd": selected
	}
	
	if on_review:
		return
		
	# ASSESSMENT score
	if (selected) < 2:
		player_incorrects.append(2)
		player_score += selected - 1
		scene3_score += selected - 1
	else:
		player_score += 1
		scene3_score += 1
	
	userForm.visible = false
	change_scene(3)

onready var cameraA = $Camera_A
onready var cameraB = $Camera_B
onready var cameraButtonA = $Camera_A/CameraButtonA
onready var cameraButtonB = $Camera_B/CameraButtonB

# SCENE 4 fxn
func scene4_1(_timeline_name):
	
	var takepictures = Dialogic.start("/Scene4/4_TakePictures")
	add_child(takepictures)
	
	background.visible = false
	cameraA.visible = true
	cameraButtonA.visible = true 

# SCENE 4 picture_taking (1)
func _on_CameraButtonA_pressed():
	cameraA.visible = false
	cameraButtonA.visible = false
	
	cameraB.visible = true
	cameraButtonB.visible = true

# SCENE 4 picture_taking (2)
func _on_CameraButtonB_pressed():
	
	background.visible = true
	cameraB.visible = false
	cameraButtonB.visible = false
	
	scene4_3()

# SCENE 4 end
func scene4_3():
	change_scene(4)

# SCENE 5 fxn
func scene5_1(_timeline_name):
	
	background.visible = false
	scene5_2()

onready var selectPicture = $SelectPicture
onready var tagA = $TagA
onready var tagB = $TagB

# Tag Friends A
onready var jake = $TagA/Pic/Jake
onready var sam = $TagA/Pic/Sam
onready var matt = $TagA/Pic/Matt
onready var cindy = $TagA/Pic/Cindy
# Tag Friends B
onready var jen = $TagB/Pic/Jen
onready var carl = $TagB/Pic/Carl
onready var mary = $TagB/Pic/Mary
onready var mike = $TagB/Pic/Mike
onready var angel = $TagB/Pic/Angel
onready var mia = $TagB/Pic/Mia

func scene5_2():
	selectPicture.visible = true
	for child in selectPicture.get_children():
		child.show()
		child.disabled = false
	
var scene4_score = 0 # Picture Selection

# SCENE 5 assess
func _on_GroupPicA_pressed():
	collated_player_choices[4] = {
		"GroupPic": "A"
	}
	
	player_incorrects.append(4)
	player_score -= 1
	scene4_score -= 1
	selected_pic = 0
	tagfriendsA()

# SCENE 5 assess	
func _on_GroupPicB_pressed():
	collated_player_choices[4] = {
		"GroupPic": "B"
	}
	player_score += 1
	scene4_score += 1
	selected_pic = 1
	tagfriendsB()
	
var jake_tagged = 0
var mary_tagged = 0
	
func tagfriendsA():
	var tagADial = Dialogic.start("/Scene5/5_TagGuide")
	add_child(tagADial)
	
	selectPicture.visible = false
	tagA.visible = true
	
var scene5_score = 0
	
func _on_DoneButtonA_pressed():
	
	if jake.text == "Jake":
		jake_tagged = 1
	
	if jake.text == "Jake" and sam.text == "Sam" and matt.text == "Matt" and cindy.text == "Cindy":
		player_score += 1
		scene5_score += 1
		collated_player_choices[4]["isTagCorrect"] = 1
	else:
		collated_player_choices[4]["isTagCorrect"] = 0
		player_score -= 1
		scene5_score -= 1
	scene6_1()
	
func tagfriendsB():
	var tagADial = Dialogic.start("/Scene5/5_TagGuide")
	add_child(tagADial)
	
	selectPicture.visible = false
	tagB.visible = true

	
func _on_DoneButtonB_pressed():
	
	if mary.text == "Mary":
		mary_tagged = 1
		
	if jen.text == "Jen" and carl.text == "Carl" and mary.text == "Mary" and mike.text == "Mike" and angel.text == "Angel" and mia.text == "Mia":
		player_score += 1
		scene6_score += 1
		collated_player_choices[4]["isTagCorrect"] = 1
	else:
		player_incorrects.append(4)
		collated_player_choices[4]["isTagCorrect"] = 0
		player_score -= 1
		scene6_score -= 1
	scene6_1()
	
onready var pickCaption = $PickCaption
onready var picA = $PickCaption/PicA
onready var picB = $PickCaption/PicB
onready var saySomething = $PickCaption/SaySomething
onready var captionForm = $PickCaption/SaySomething/Caption
onready var captionDone = $PickCaption/SaySomething/Done

var scene6_score = 0 # Caption Selection

# SCENE 6 fxn
func scene6_1():
	print(selected_pic)
	pickCaption.visible = true
	
	if selected_pic == 0:
		tagA.visible = false
		picA.visible = true
	elif selected_pic == 1:
		tagB.visible = false
		picB.visible = true
	
	var captionGuide = Dialogic.start("/Scene6/6_Guide")
	add_child(captionGuide)
	
	saySomething.visible = true 
	captionForm.visible = true
	captionDone.visible = true

func _on_DoneCaption_pressed():
	if captionForm.text == "Had a great time hanging out with these guys <3" or captionForm.text == "":
		collated_player_choices[5] = {
			"CaptionRevealsInfo": 0
		}
		player_score += 1
		scene6_score += 1
	else:
		player_incorrects.append(5)
		collated_player_choices[5] = {
			"CaptionRevealsInfo": 1
		}
		player_score -= 1
		scene6_score -= 1
		
	pickCaption.visible = false
	change_scene(6)
	
# SCENE 7 fxn
func scene7_1(_timeline_name):
	advSettings.visible = true
	
	# location_setting
	if permission_settings[0] == 1:
		# code for No Location Data Available
		noLocData.visible = true
		locButton.visible = false
		
		
	else:
		# code for other setting (auto-on)
		noLocData.visible = false
		locButton.visible = true
		locButton.pressed = true
		
var scene7a_score = 0 # Location Settings
var scene7b_score = 0 # Visibility Settings

# SCENE 7 end fxn
func _on_SaveSettings_pressed():
	
	# UPDATE scores (location)
	if (locButton.visible == false) or (locButton.pressed == false):
		player_score +=1
		scene7a_score += 1
		collated_player_choices[6] = {
			"LocationOption": 1
		}
	else:
		collated_player_choices[6] = {
			"LocationOption": 0
		}
		player_incorrects.append(6)
		player_score -= 1
		scene7a_score -= 1
	
	# UPDATE scores (visibility)
	if visibOpt.selected == 0:
		player_score +=1
		scene7b_score += 1
	elif visibOpt.selected == 2:
		if player_incorrects.find(6) == -1:
			player_incorrects.append(6)
		player_score -=1
		scene7b_score -= 1

	collated_player_choices[6]["VisibilityOption"] = visibOpt.selected
	
	advSettings.visible = false
		
	# connect to scene 8
	change_scene(7)



onready var removeTagA = $RemoveTagA
onready var notifA = $RemoveTagA/Notif
onready var messageA = $RemoveTagA/Message
onready var picATag = $RemoveTagA/Pic
onready var picATags = $RemoveTagA/Pic/Tags

onready var removeTagB = $RemoveTagB
onready var notifB = $RemoveTagB/Notif
onready var messageB = $RemoveTagB/Message
onready var picBTag = $RemoveTagB/Pic
onready var picBTags = $RemoveTagB/Pic/Tags


# SCENE 8 fxn
func scene8_1(_timeline_name):

	if selected_pic == 0 and jake_tagged == 1:
		
		removeTagA.visible = true
		
		var messageNotifA = Dialogic.start("/Scene8/8_MessageA")
		add_child(messageNotifA)
		
		messageA.visible = true 
		
		messageNotifA.connect("timeline_end", self, 'scene8_2')
		
		
	elif selected_pic == 1 and mary_tagged == 1:
		
		removeTagB.visible = true 
		
		var messageNotifA = Dialogic.start("/Scene8/8_MessageB")
		add_child(messageNotifA)	
		
		messageB.visible = true 
		
		messageNotifA.connect("timeline_end", self, 'scene8_2')

	else:
		scene_9(_timeline_name)
		

#	scene8_2()

var scene8_score = 0 # TagRemoval

# SCENE 8 assess
func _on_notjaketag_pressed():
	collated_player_choices[7] = {
		"TagRemoved": 0
	}
	
	player_incorrects.append(7)
	player_score -= 1
	scene8_score -= 1
	picATags.visible = false
	scene8_3()
	
func _on_jaketag_pressed():
	collated_player_choices[7] = {
		"TagRemoved": 1
	}
	
	player_score += 1
	scene8_score += 1
	picATags.visible = false
	scene8_3()
	
func _on_marytag_pressed():
	collated_player_choices[7] = {
		"TagRemoved": 1
	}
	
	player_score += 1
	scene8_score += 1
	picBTags.visible = false
	scene8_3()
	
func _on_notmarytag_pressed():
	collated_player_choices[7] = {
		"TagRemoved": 0
	}
	player_incorrects.append(7)
	player_score -= 1
	scene8_score -= 1
	picBTags.visible = false
	scene8_3()
	

# after message
func scene8_2(_timeline_name):
	
	background.visible = false
	
	var guide8 = Dialogic.start("/Scene8/8_Guide")
	add_child(guide8)
	yield(guide8, 'timeline_end')
	
	
	if selected_pic == 0:
		messageA.visible = false
		picATag.visible = true
		picATags.visible = true
		$RemoveTagA/Pic/Guide.show()
		
		var instr8 = Dialogic.start("/Scene8/8_Instr")
		add_child(instr8)
	
	elif selected_pic == 1:
		messageB.visible = false
		picBTag.visible = true
		picBTags.visible = true
		$RemoveTagB/Pic/Guide.show()
		
		var instr8 = Dialogic.start("/Scene8/8_Instr")
		add_child(instr8)
		
func scene8_3():
	background.hide()
	
	var removed8 = Dialogic.start("/Scene8/8_Removed")
	add_child(removed8)
	
	yield(removed8, 'timeline_end')
	
	# SCENE 8 end
	messageA.visible = false
	messageB.visible = false
	picA.visible = false
	picB.visible = false
	picATag.visible = false
	picBTag.visible = false
	
	change_scene(8)
	
# SCENE 10
func scene10_1(_timeline_name):
	# init
	phoneNotif.visible = true
	playerIcon.visible = false
	playerIcon.texture = load("res://People/%s.png" % Dialogic.get_variable("PlayerIcon"))
	background.hide()
	
	# continue scene
	var phone10 = Dialogic.start("/Scene10/10_Phone")
	add_child(phone10)
	yield(phone10, "timeline_end")
	dl_sig("change_bg")
	
	# Display corresponding images
	phoneNotif.visible = false
	playerIcon.visible = true
	$PlayerIcon/Discard.visible = false
	$PlayerIcon/Keep.visible = false
	background.show()
	
	# Start timeline
	var tag10 = Dialogic.start("/Scene10/10_Tag")
	add_child(tag10)
	
	yield(tag10, "timeline_end")
	
	# Show tagging options
	$PlayerIcon/Discard.visible = true
	$PlayerIcon/Keep.visible = true
	

func _on_Discard_pressed():
	scene10_2(1)

func _on_Keep_pressed():
	scene10_2(0)

var scene10_score = 0 # Discard Tag

func scene10_2(is_discarded):
	
	player_score += is_discarded
	scene10_score += is_discarded
	
	if is_discarded == 0:
		player_incorrects.append(9)
		
	collated_player_choices[9] = {
		"IsDiscarded": is_discarded
	}
	
	$PlayerIcon/Discard.visible = false
	$PlayerIcon/Keep.visible = false
	
	var aftertag10 = Dialogic.start("/Scene10/10_AfterTag")
	add_child(aftertag10)
	yield(aftertag10, "timeline_end")
	
	phoneNotif.visible = false
	playerIcon.visible = false
	dl_sig("change_bg")
	tagSetting.visible = true
	
	var settings10 = Dialogic.start("/Scene10/10_Settings")
	add_child(settings10)
	
# SCENE 10 end fxn
func _on_Button_pressed():
	if $TagSetting/Options.selected == 2:
		collated_player_choices[9]["Everyone"] = 1
		if player_incorrects.find(9) == -1:
			player_incorrects.append(9)
		player_score -= 1
		scene10_score -= 1
	else:
		collated_player_choices[9]["Everyone"] = 0
		player_score += 1
		scene10_score += 1
	
	# end scene
	tagSetting.visible = false
	change_scene(10)
	
func end_scene_1(_timeline_name):
	
	# $FinalScore/Label.text = "Game Over!\n\n\nYour Score:\n %d" % player_score
	# finScore.visible = true
	hide_all($ScoreBreakdown)
	$ScoreBreakdown/end.text = "App Permission: " + str(scene2_score) + "\nUsername Selection: " + str(scene3_score) + "\nPhoto Selection: " + str(scene4_score) + "\nTagging of Friends: " + str(scene5_score) + "\nCaption Selection: " + str(scene6_score) + "\nLocation Visibility: " + str(scene7a_score) + "\nPost Visibility: " + str(scene7b_score) + "\nTag Removal: " + str(scene8_score) + "\nFeature Persuasion: " + str(scene9_score) + "\nTag Setting Behavior: " + str(scene10_score) + "\nTotal Score: " + str(player_score)
	$ScoreBreakdown/end.show()
	$ScoreBreakdown.show()
	
	print("Game Over.")
	print(var2str(player_incorrects))
	print(var2str(collated_player_choices))
	print("Starting review...")
	# debug_review()
	review()
	
onready var x_scene = $xScene
onready var asbg =  $xScene/bg
onready var asf = $xScene/friend
onready var astp = $xScene/taggedphoto
onready var addiplayer = $xScene/player
onready var askb = $xScene/keep
onready var asrb = $xScene/remove
onready var gaslight = $xScene/gaslight

# SCENE 9
func scene_9(_timeline_name):
	
	pickCaption.visible = true
	background.visible = false
	
	if selected_pic == 0:
		picA.visible = true
		$PickCaption/SaySomething.visible = false
	else:
		picB.visible = true
		$PickCaption/SaySomething.visible = false
	
	var addscene_intro = Dialogic.start("/Scene9/9_Intro")
	add_child(addscene_intro)
	yield(addscene_intro, 'timeline_end')
	
	background.visible = false
	
	x_scene.visible = true
	asbg.visible = true
	asf.visible = true
	gaslight.visible = false
	astp.visible = false
	askb.visible = false
	asrb.visible = false
	
	var addscene_tagged = Dialogic.start("/Scene9/9_Tagged")
	add_child(addscene_tagged)
	addscene_tagged.connect("timeline_end", self, 'scene_9_1')

func scene_9_1(_timeline_name):
	
	pickCaption.visible = false
	
	asbg.visible = false
	asf.visible = false
	astp.visible = true	
	addiplayer.texture = load("res://People/%s.png" % Dialogic.get_variable("PlayerIcon"))
	addiplayer.visible = true
	
	var addscene_guide = Dialogic.start("/Scene9/9_Guide")
	add_child(addscene_guide)
	yield(addscene_guide, 'timeline_end')

	askb.visible = true
	asrb.visible = true

var scene9_score = 0 # Gaslight 
	
func _on_askb_pressed(): # keep button; proceed to end of scene
	player_score -= 1
	scene9_score -= 1
	player_incorrects.append(8)
#	collated_player_choices[8] = {
#		"IsDiscarded": 0,
#		"Gaslighted": 1
#	}
	scene_9_end()
	
func _on_asrb_pressed(): # remove button 
	scene_9_rb()
	
func _on_gaskb_pressed():
	player_score -= 1
	scene9_score -= 1
	player_incorrects.append(8)
	collated_player_choices[8] = {
		"IsDiscarded": 0,
		"Gaslighted": 1
	}
	scene_9_end()
	
func scene_9_rb(): # remove button pressed; gaslight
	askb.visible = false
	asrb.visible = false
	addiplayer.visible = false
	gaslight.visible = true
	
func _on_gasrb_pressed(): 
	collated_player_choices[8] = {
		"IsDiscarded": 1,
		"Gaslighted": 0
	}
	player_score += 1
	scene9_score += 1
	scene_9_end()
	
func scene_9_end():
	x_scene.visible = false
	background.visible = true
	change_scene(9)
	
	
func get_perm_str(perm_int):
	var perm_str = ""
	if permission_settings[0] == perm_int:
		perm_str = perm_str + "Location"
	if permission_settings[1] == perm_int:
		if perm_str != "":
			perm_str  = perm_str + ", "
		perm_str = perm_str + "Contacts"
	if permission_settings[2] == perm_int:
		if perm_str != "":
			perm_str  = perm_str + ", "
		perm_str = perm_str + "Camera"
	if permission_settings[3] == perm_int:
		if perm_str != "":
			perm_str  = perm_str + ", "
		perm_str = perm_str + "Microphone"
	if permission_settings[4] == perm_int:
		if perm_str != "":
			perm_str  = perm_str + ", "
		perm_str = perm_str + "Notifications"
	
	if perm_str == "":
		return "\"\""
	return perm_str

# DEBUG for review
func debug_review():
	player_incorrects = [1,2,4,5,6,7,8,9]		# DEBUG values, change to empty list before commiting
	
	var selected = username.get_selected_id()
	
	permission_settings = [
		0,
		0,
		0,
		0,
		0
	]
	collated_player_choices[2] = {
		"UsernameInd": selected
	}
	
	collated_player_choices[4] = {
		"GroupPic": "A",
		"isTagCorrect": 0
	}
	
	collated_player_choices[5] = {
			"CaptionRevealsInfo": 1
	}
	
	collated_player_choices[6] = {
		"LocationOption": 0,
		"VisibilityOption": 2
	}
	
	collated_player_choices[7] = {
		"TagRemoved": 0
	}
	
	collated_player_choices[8] = {
		"Gaslighted": 1,
		"IsDiscarded": 0
	}
	
	collated_player_choices[9] = {
		"IsDiscarded": 0,
		"Everyone": 1
	}
	
	print(collated_player_choices)
	
	review()

func review():
	
	var review_start = Dialogic.start("/ReviewScenes/Start")
	review_start.connect("dialogic_signal", self, "dl_sig")
	add_child(review_start)
	yield(review_start, 'timeline_end')
	
	# hide all
	for child in self.get_children():
		child.visible = false
	
	print("Incorrects: ")
	print(var2str(player_incorrects))
	
	on_review = 1
	# SCENE 2
	if player_incorrects.find(1) != -1:
		print("REVIEWING SCENE 2...")
		# setup dialogic variables
		print(Dialogic.get_variable("Scene2_AA"))
		print(Dialogic.get_variable("Scene2_AWAIU"))		
		Dialogic.set_variable("Scene2_AA", get_perm_str(-1))
		Dialogic.set_variable("Scene2_AWAIU", get_perm_str(0))
		print(Dialogic.get_variable("Scene2_AA"))
		print(Dialogic.get_variable("Scene2_AWAIU"))
			
		change_permission_texture(0)
		perm_ind = 0
		
		# set stuff visible
		$ScoreBreakdown/scene2_header/scene2_label.text = "Privacy Risk: App Permissions"
		hide_all($ScoreBreakdown)
		show_all($ScoreBreakdown/scene2_header)
		$ScoreBreakdown.show()

		app_store.texture = load("res://Background/Scene 3 Allow App Access to.png")
		app_store.show()
		app_store.scale = Vector2(0.85,0.85)
		for child in app_store.get_children():
			child.visible = true
		installButton.hide()
		
		# start review timeline
		var scene_review = Dialogic.start("/ReviewScenes/Scene2")
		scene_review.connect("dialogic_signal", self, "dl_sig")
		add_child(scene_review)
		
		yield(scene_review, 'timeline_end')
		
		# set stuff invisible
		app_store.hide()
		hide_all($ScoreBreakdown)
	
	# SCENE 3
	if player_incorrects.find(2) != -1:
		print("REVIEWING SCENE 3...")
		# setup dialogic variables
		Dialogic.set_variable("Scene3_UsernameInd", collated_player_choices[2]["UsernameInd"])
		
		# show stuff
		$ScoreBreakdown/scene3_header/scene3_label.text = "Privacy Risk: Username Selection"
		hide_all($ScoreBreakdown)
		show_all($ScoreBreakdown/scene3_header)
		$ScoreBreakdown.show()
		
		userForm.show()
		background.texture = load("res://.import/Scene 3 Welcome to Social Media.png-81facec361cf825f3bb7d2552989c71b.stex")
		background.show()
		$UsernameForm/Submit.disabled = true
		
		# start review timeline
		var scene_review = Dialogic.start("/ReviewScenes/Scene3")
		scene_review.connect("dialogic_signal", self, "dl_sig")
		add_child(scene_review)
		
		yield(scene_review, 'timeline_end')
		
		# hide stuff
		userForm.hide()
		background.hide()
		hide_all($ScoreBreakdown)
	
	# SCENE 5
	if player_incorrects.find(4) != -1:
		print("REVIEWING SCENE 5...")
		# dialogic variable
		Dialogic.set_variable("Scene5_GroupPic", collated_player_choices[4]["GroupPic"])
		Dialogic.set_variable("Scene5_IsTagCorrect", collated_player_choices[4]["isTagCorrect"])
		
		# show stuff
		$ScoreBreakdown/scene5_header/scene5_label.text = "Privacy Risk: Photo Selection"
		hide_all($ScoreBreakdown)
		show_all($ScoreBreakdown/scene5_header)
		$ScoreBreakdown.show()
		
		if collated_player_choices[4]["GroupPic"] == "A":
			tagA.show()
			for child in tagA.get_children():
				child.hide()
			$TagA/Pic.show()
			for child in $TagA/Pic.get_children():
				child.hide()
		else:
			tagB.show()
			for child in tagB.get_children():
				child.hide()
			$TagB/Pic.show()
			for child in $TagB/Pic.get_children():
				child.hide()
		
		# start review timeline
		var scene_review = Dialogic.start("/ReviewScenes/Scene5")
		scene_review.connect("dialogic_signal", self, "dl_sig")
		add_child(scene_review)
		
		yield(scene_review, 'timeline_end')
		
		# hide stuff
		hide_all($ScoreBreakdown)
		if collated_player_choices[4]["GroupPic"] == "A":
			tagA.hide()
		else:
			tagB.hide()
	
	# SCENE 6
	if player_incorrects.find(5) != -1:
		print("REVIEWING SCENE 6...")
		# dialogic variable
		Dialogic.set_variable("Scene6_RevealsInfo", collated_player_choices[5]["CaptionRevealsInfo"])
		
		# show stuff
		$PickCaption/SaySomething/.show()
		$PickCaption/SaySomething/Done.hide()
		$PickCaption/SaySomething/Caption.show()
		
		$ScoreBreakdown/scene6_header/scene6_label.text = "Privacy Risk: Caption Selection"
		hide_all($ScoreBreakdown)
		show_all($ScoreBreakdown/scene6_header)
		$ScoreBreakdown.show()
		
		pickCaption.visible = true
		
		if selected_pic == 0:
			picA.show()
		else:
			picB.show()
		
		# review timeline
		var scene_review = Dialogic.start("/ReviewScenes/Scene6")
		scene_review.connect("dialogic_signal", self, "dl_sig")
		add_child(scene_review)
		yield(scene_review, 'timeline_end')
		
		# hide stuff
		pickCaption.visible = false
		captionForm.hide()
		hide_all($ScoreBreakdown)
		
	# SCENE 7
	if player_incorrects.find(6) != -1:
		print("REVIEWING SCENE 7...")
		# dialogic variable
		Dialogic.set_variable("Scene7_LocationOpt", collated_player_choices[6]["LocationOption"])
		Dialogic.set_variable("Scene7_VisibilityOpt", collated_player_choices[6]["VisibilityOption"])
		# show stuff
		$ScoreBreakdown/scene7_header/scene7_label.text = "Privacy Risk: Location Data and Post Visibility"
		hide_all($ScoreBreakdown)
		show_all($ScoreBreakdown/scene7_header)
		$ScoreBreakdown.show()
		
		advSettings.visible = true
		if permission_settings[0] == 1:
			noLocData.visible = true
			locButton.visible = false
		else:
			noLocData.visible = false
			locButton.visible = true
		
		# review timeline
		var scene_review = Dialogic.start("/ReviewScenes/Scene7")
		scene_review.connect("dialogic_signal", self, "dl_sig")
		add_child(scene_review)
		yield(scene_review, 'timeline_end')
		
		# hide stuff
		advSettings.visible = false
		hide_all($ScoreBreakdown)
		
	# SCENE 8
	if player_incorrects.find(7) != -1:
		print("REVIEWING SCENE 8...")
		# dialogic variable
		Dialogic.set_variable("Scene8_TagRemoved", collated_player_choices[7]["TagRemoved"])
		
		# show stuff
		$ScoreBreakdown/scene8_header/scene8_label.text = "Privacy Risk: Removal of Tags"
		hide_all($ScoreBreakdown)
		show_all($ScoreBreakdown/scene8_header)
		$ScoreBreakdown.show()
	
		if selected_pic == 0:
			removeTagA.visible = true
			picATag.show()
			picATags.show()
		elif selected_pic == 1:
			removeTagB.visible = true
			picBTag.show()
			picBTags.show()
			
		# review timeline
		var scene_review = Dialogic.start("/ReviewScenes/Scene8")
		scene_review.connect("dialogic_signal", self, "dl_sig")
		add_child(scene_review)
		yield(scene_review, 'timeline_end')
		
		# hide stuff
		if selected_pic == 0:
			removeTagA.visible = false	
		elif selected_pic == 1:
			removeTagB.visible = false
		hide_all($ScoreBreakdown)
		
	# SCENE 9
	# ADD SCENE X -> stuff
	if player_incorrects.find(8) != -1:
		print("REVIEWING SCENE 9...")
		# dialogic variables
		Dialogic.set_variable("Scene9_IsDiscarded", collated_player_choices[8]["IsDiscarded"])
		Dialogic.set_variable("Scene9_Gaslighted", collated_player_choices[8]["Gaslighted"])
		# show stuff
		$ScoreBreakdown/scene9_header/scene9_label.text = "Privacy Risk: Persuasive Features"
		hide_all($ScoreBreakdown)
		show_all($ScoreBreakdown/scene9_header)
		$ScoreBreakdown.show()
		
		x_scene.show()
		addiplayer.show()
		gaslight.show()
		
		# review timeline
		var scene_review = Dialogic.start("/ReviewScenes/Scene9")
		scene_review.connect("dialogic_signal", self, "dl_sig")
		add_child(scene_review)
		yield(scene_review, 'timeline_end')
		
		# hide stuff
		x_scene.hide()
		addiplayer.hide()
		gaslight.hide()
		hide_all($ScoreBreakdown)
	
	# SCENE 10
	if player_incorrects.find(9) != -1:
		print("REVIEWING SCENE 10...")
		# dialogic variable
		Dialogic.set_variable("Scene10_IsDiscarded", collated_player_choices[9]["IsDiscarded"])
		Dialogic.set_variable("Scene10_Everyone", collated_player_choices[9]["Everyone"])
		# show stuff
		$ScoreBreakdown/scene10_header/scene10_label.text = "Privacy Risk: Tagging Behavior"
		hide_all($ScoreBreakdown)
		show_all($ScoreBreakdown/scene10_header)
		$ScoreBreakdown.show()
		
		background.texture = load("res://Background/crowd.png")
		background.show()
		bg_next = 24	# ADAPT TO SCENE X CHANGE
		playerIcon.visible = true
		$PlayerIcon/Discard.visible = true
		$PlayerIcon/Keep.visible = true
		
		# review timeline
		var scene_review = Dialogic.start("/ReviewScenes/Scene10")
		scene_review.connect("dialogic_signal", self, "dl_sig")
		add_child(scene_review)
		yield(scene_review, 'dialogic_signal')
		playerIcon.hide()
		tagSetting.show()
		yield(scene_review, 'timeline_end')
		
		# hide stuff
		background.hide()
		tagSetting.hide()
		playerIcon.visible = false
		$PlayerIcon/Discard.visible = false
		$PlayerIcon/Keep.visible = false
		hide_all($ScoreBreakdown)
	
	background.texture = load("res://Background/End_Background.png")
	background.show()
	
	var end_scene = Dialogic.start("/ReviewScenes/End_Scene")
	add_child(end_scene)
	yield(end_scene, 'timeline_end')
	# $FinalScore/Label.text = "Game Over!\n\n\nYour Score:\n %d" % player_score
	# $FinalScore/Label.show()
	# $FinalScore.show()
		
	$ScoreBreakdown/end.text = "App Permission: " + str(scene2_score) + "\nUsername Selection: " + str(scene3_score) + "\nPhoto Selection: " + str(scene4_score) + "\nTagging of Friends: " + str(scene5_score) + "\nCaption Selection: " + str(scene6_score) + "\nLocation Visibility: " + str(scene7a_score) + "\nPost Visibility: " + str(scene7b_score) + "\nTag Removal: " + str(scene8_score) + "\nFeature Persuasion: " + str(scene9_score) + "\nTag Setting Behavior: " + str(scene10_score) + "\nTotal Score: " + str(player_score)
	$ScoreBreakdown/end.show()
	$ScoreBreakdown.show()
	return null
	# SCENE 3
		# setup dialogic variables
	
