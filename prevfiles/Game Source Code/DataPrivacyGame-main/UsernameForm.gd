extends Sprite

onready var Username = $Username
onready var Submit = $Submit

var username_select = "";

func _ready():
	self.visible = false

func _on_Submit_pressed():
	print(Dialogic.get_variable("PlayerIcon"));
	username_select = Username.text;
	Dialogic.set_variable("Username", username_select);
	print(username_select);
	self.visible = false;
	self.hide();
	
