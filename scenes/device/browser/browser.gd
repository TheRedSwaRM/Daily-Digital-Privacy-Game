extends Control

@onready var tabs_button = $TabsButton
@onready var link_label = $LinkLabel
@onready var tab_section_panel = $TabSection
@onready var tab_section = $TabSection/Scroller/ScrollerHorizon
@onready var available_tabs = $Tabs

@onready var online: bool = false
@onready var home = $Tabs/Home

var current_tab: Control

# Called when the node enters the scene tree for the first time.
func _ready():
	Events.back_button_pressed.connect(_phone_back_button_pressed)
	Events.connection_change.connect(_check_for_wifi_connection)
	Events.link_pressed.connect(_show_tab)
	_create_tab_thumbnails()
	_change_tab_number()
	
	# The current tab you should be in. For use of the refresh button.
	current_tab = $Tabs/Home

## Crazy helper function that will help us create the tab thumbnails which
## will also trigger specific signals when needed.
func _create_tab_thumbnails():
	for child in available_tabs.get_children():
		var pre_tab_sections = preload("res://scenes/device/browser/tab_thumbnail.tscn")
		var new_tab_section = pre_tab_sections.instantiate()
		
		new_tab_section.node_name = child.name
		new_tab_section.link_data = child.link_name
		new_tab_section.tab_name = child.tab_name
		new_tab_section.tab_image = child.thumbnail 
		
		tab_section.add_child(new_tab_section)
		new_tab_section.thumbnail_touched.connect(_thumbnail_touched)
		
		if not child.visible:
			new_tab_section.visible = false
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _check_for_wifi_connection(connection_name: String):
	match connection_name:
		"none":
			online = false
			print("Browser Offline")
		_:
			online = true
			print("Browser Online")

# Opens tabs
func _on_tabs_button_pressed():
	tab_section_panel.show()

# Closes tabs
func _on_tab_exit_pressed():
	tab_section_panel.hide()

# Only is called when a tab is opened.
# Checks how many tabs are currently open.
func _change_tab_number():
	var current_num: int = 0
	for child in tab_section.get_children():
		if child.visible:
			current_num += 1
	
	tabs_button.text = str(current_num)

func _thumbnail_touched(node_name: String, special: bool = false):
	# var target_node = available_tabs.get_node(node_name)	
	for child in available_tabs.get_children():
		if child.name == node_name:
			child.show()							# Show child needed.
			link_label.text = child.link_name
			
			current_tab = child
			if special: _on_refresh_button_pressed() # Only for the 1st time case
			
		else:
			child.hide()	
	
	_on_tab_exit_pressed()

# Finally show the tab.
func _show_tab(link: String):
	for child in tab_section.get_children():
		if child.link_data == link:
			child.show()
			_thumbnail_touched(child.node_name, true)
			
	_change_tab_number()
	Events.force_phone_go_to.emit("Browser")

func _on_refresh_button_pressed():
	if not current_tab == home:
		current_tab.no_wifi_page(online)

func _phone_back_button_pressed():
	if not visible:
		print("Browser already not visible.")
		return
	
	if tab_section_panel.visible:
		tab_section_panel.hide()
		return
		
	hide()
	



