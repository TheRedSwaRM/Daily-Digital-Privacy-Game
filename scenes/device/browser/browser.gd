extends Control

@onready var tabs_button = $TabsButton
@onready var link_label = $LinkLabel
@onready var tab_section_panel = $TabSection
@onready var tab_section = $TabSection/Scroller/ScrollerHorizon
@onready var available_tabs = $Tabs

# Called when the node enters the scene tree for the first time.
func _ready():
	Events.back_button_pressed.connect(_phone_back_button_pressed)
	_create_tab_thumbnails()

## Crazy helper function that will help us create the tab thumbnails which
## will also trigger specific signals when needed.
func _create_tab_thumbnails():
	for child in available_tabs.get_children():
		var pre_tab_sections = preload("res://scenes/device/browser/tab_thumbnail.tscn")
		var new_tab_section = pre_tab_sections.instantiate()
		
		new_tab_section.node_name = child.name
		new_tab_section.tab_name = child.tab_name
		new_tab_section.tab_image = child.thumbnail 
		
		tab_section.add_child(new_tab_section)
		new_tab_section.thumbnail_touched.connect(_thumbnail_touched)
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

# Special function
func _phone_back_button_pressed():
	hide()

# Opens tabs
func _on_tabs_button_pressed():
	tab_section_panel.show()

# Closes tabs
func _on_tab_exit_pressed():
	tab_section_panel.hide()

func _thumbnail_touched(node_name: String):
	# var target_node = available_tabs.get_node(node_name)	
	for child in available_tabs.get_children():
		if child.name == node_name:
			child.show()							# Show child needed.
		else:
			child.hide()	
	
	_on_tab_exit_pressed()
