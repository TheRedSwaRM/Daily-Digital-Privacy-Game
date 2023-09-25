extends Sprite

onready var Name = $Name
onready var PI_A = $PlayerIconA
onready var PI_B = $PlayerIconB
onready var PI_C = $PlayerIconC
onready var Submit = $Submit

var name_select = "";
var icon_select = "Player Icon A";

func _ready():
	pass # Replace with function body.


func _on_PlayerIconA_pressed():
	icon_select = "Player Icon A";
	PI_A.modulate = Color(0.64, 0.87, 0.44)
	PI_B.modulate = Color(1, 1, 1)
	PI_C.modulate = Color(1, 1, 1)

func _on_PlayerIconB_pressed():
	icon_select = "Player Icon B";
	PI_A.modulate = Color(1, 1, 1)
	PI_B.modulate = Color(0.64, 0.87, 0.44)
	PI_C.modulate = Color(1, 1, 1)

func _on_PlayerIconC_pressed():
	icon_select = "Player Icon C";
	PI_A.modulate = Color(1, 1, 1)
	PI_B.modulate = Color(1, 1, 1)
	PI_C.modulate = Color(0.64, 0.87, 0.44)


func _on_Submit_pressed():
	print(Dialogic.get_variable("PlayerIcon"));
	name_select = Name.text;
	Dialogic.set_variable("PlayerName", name_select);
	Dialogic.set_variable("PlayerIcon", icon_select);
	print(name_select);
	print(icon_select);
	self.visible = false;
	self.hide();
	
