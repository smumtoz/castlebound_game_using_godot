extends ParallaxBackground

var t := 0.0
var amplitude := 8.0      # tiny movement in pixels
var period := 12.0        # seconds for a full left -> right -> left cycle

func _process(delta: float) -> void:
	t += delta
	var phase := t * (TAU / period)
	var raw_x := sin(phase) * amplitude
	var snapped_x := int(round(raw_x))
	scroll_offset.x = snapped_x
